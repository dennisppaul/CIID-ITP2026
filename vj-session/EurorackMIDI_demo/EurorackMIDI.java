import wellen.*;
import java.util.concurrent.*;
import java.lang.reflect.Method;
import java.lang.reflect.InvocationTargetException;
import processing.core.PApplet;

public final class EurorackMIDI {
    private static final String em_note_on_callback    = "em_note_on";
    private static final String em_note_off_callback   = "em_note_off";

    public static final int EM_PORT_1 = 36;
    public static final int EM_PORT_2 = 38;
    public static final int EM_PORT_3 = 39;
    public static final int EM_PORT_4 = 42;
    public static final int EM_PORT_5 = 46;

    public static final int EM_PORT_KICK          = EM_PORT_1; // Kick
    public static final int EM_PORT_SNARE         = EM_PORT_2; // Snare
    public static final int EM_PORT_CLAP          = EM_PORT_3; // Clap
    public static final int EM_PORT_HI_HAT_CLOSED = EM_PORT_4; // Closed hi-hat
    public static final int EM_PORT_HI_HAT_OPEN   = EM_PORT_5; // Open hi-hat

    private boolean em_note_on_callback_warning_once = true;
    private boolean em_note_off_callback_warning_once = true;

    private int send_milliseconds_delay        = 10;
    private boolean send_clear_queue           = true;
    private ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
    private ScheduledFuture<?> pending         = null;

    private MidiOut em_midi_out;
    private MidiIn em_midi_in;
    private PApplet parent;

    /**
     * Use this when the MIDI input and output have different names.
     *
     * @param parent             the sketch (just pass "this")
     * @param midi_output_device name of the MIDI device we send notes to
     * @param midi_input_device  name of the MIDI device we receive notes from
     */
    public EurorackMIDI(PApplet parent, String midi_output_device, String midi_input_device) {
        this.parent = parent;
        em_midi_in = new MidiIn(midi_input_device);
        em_midi_in.add_listener(new MIDIInput());
        em_midi_out = new MidiOut(midi_output_device);
    }

    /**
     * Use this when the MIDI input and output have the same name
     * (the usual case with the Eurorack module).
     *
     * @param parent           the sketch (just pass "this")
     * @param midi_device_name name of the MIDI device, used for both input and output
     */
    public EurorackMIDI(PApplet parent, String midi_device_name) {
        this(parent, midi_device_name, midi_device_name);
    }

    public void configure_send(int milliseconds, boolean clear_queue) {
        send_milliseconds_delay = milliseconds;
        send_clear_queue = clear_queue;
    }

    public void send_output_start(int port) {
        em_midi_out.send_note_on(1, port, 127);
    }

    public void send_output_stop(int port) {
        em_midi_out.send_note_off(1, port);
    }

    public void send_output(int port) {
        send_output_start(port);
        if (send_clear_queue && pending != null) {
            pending.cancel(false);
        }
        pending = scheduler.schedule(() -> {
            send_output_stop(port);
        }
        , send_milliseconds_delay, TimeUnit.MILLISECONDS);
    }

    public void invoke_note_on(int pitch, int velocity) {
        try {
            Method m = parent.getClass().getMethod(em_note_on_callback, int.class, int.class);
            m.invoke(parent, pitch, velocity);
        }
        catch (NoSuchMethodException e) {
            if (em_note_on_callback_warning_once) {
                em_note_on_callback_warning_once = false;
                System.err.println("WARNING cannot find callback function 'void "+em_note_on_callback+"(int, int)'");
            }
        }
        catch (IllegalAccessException e) {
            System.err.println("not accessible: " + e.getMessage());
        }
        catch (InvocationTargetException e) {
            e.getCause().printStackTrace(); // the invoked method itself threw
        }
    }

    public void invoke_note_off(int pitch, int velocity) {
        try {
            Method m = parent.getClass().getMethod(em_note_off_callback, int.class, int.class);
            m.invoke(parent, pitch, velocity);
        }
        catch (NoSuchMethodException e) {
            if (em_note_off_callback_warning_once) {
                em_note_off_callback_warning_once = false;
                System.err.println("WARNING cannot find callback function 'void "+em_note_off_callback+"(int, int)'");
            }
        }
        catch (IllegalAccessException e) {
            System.err.println("not accessible: " + e.getMessage());
        }
        catch (InvocationTargetException e) {
            e.getCause().printStackTrace(); // the invoked method itself threw
        }
    }

    private class MIDIInput implements MidiInListener {
        public void receive_note_on(int channel, int pitch, int velocity) {
            // System.out.println(channel + ", " + pitch + ", " + velocity);
            invoke_note_on(pitch, velocity);
        }

        public void receive_note_off(int channel, int pitch, int velocity) {
            // System.out.println(channel + ", " + pitch + ", " + velocity);
            invoke_note_off(pitch, velocity);
        }
    }
}
