import wellen.*;
import wellen.dsp.*;

void settings() {
    size(640, 480);
}

void setup() {
    Wellen.dumpMidiInputDevices();
    em_setup("Eurorack-MIDI", "Eurorack-MIDI");
}

void draw() {
    background(255);
}

void mousePressed() {
    em_send_output_start(EM_PORT_1);
}

void mouseReleased() {
    em_send_output_stop(EM_PORT_1);
}

/* Eurorack-MIDI bridge */

final int EM_PORT_1 = 36;
final int EM_PORT_2 = 38;
final int EM_PORT_3 = 39;
final int EM_PORT_4 = 42;
final int EM_PORT_5 = 46;

final int EM_PORT_KICK          = EM_PORT_1; // Kick
final int EM_PORT_SNARE         = EM_PORT_2; // Snare
final int EM_PORT_CLAP          = EM_PORT_3; // Clap
final int EM_PORT_HI_HAT_CLOSED = EM_PORT_4; // Closed hi-hat
final int EM_PORT_HI_HAT_OPEN   = EM_PORT_5; // Open hi-hat

MidiOut em_midi_out;
MidiIn em_midi_in;

void em_setup(String midi_output_device, String midi_input_device) {
    em_midi_in = new MidiIn(midi_input_device);
    em_midi_in.add_listener(new MIDIInput());
    em_midi_out = new MidiOut(midi_output_device);
}

void em_send_output_start(int port) {
    em_midi_out.send_note_on(1, port, 127);
}

void em_send_output_stop(int port) {
    em_midi_out.send_note_off(1, port); // delay 10ms
}

class MIDIInput implements MidiInListener {
    void receive_note_on(int channel, int pitch, int velocity) {
        println(channel + ", " + pitch + ", " + velocity);
    }

    void receive_note_off(int channel, int pitch, int velocity) {
        println(channel + ", " + pitch + ", " + velocity);
    }
}
