import wellen.*;

EurorackMIDI em;

void setup() {
    size(1024, 768);

    Wellen.dumpMidiInputDevices(); // make sure "Eurorack-MIDI" is present
    em = new EurorackMIDI(this);
}

void draw() {
    background(255);
}

void keyPressed() {
    if (key == '1') {
        println("send to port 1");
        em.send_output(EurorackMIDI.EM_PORT_1);
    }
    if (key == '2') {
        println("send to port 2");
        em.send_output(EurorackMIDI.EM_PORT_2);
    }
    if (key == ' ') { // DEBUGGING ONLY
        em.invoke_note_on(1, 2);
        em.invoke_note_off(3, 4);
    }
}

void em_note_on(int pitch, int velocity) {
    println("on : " + pitch + ", " + velocity);
    if (pitch == EurorackMIDI.EM_PORT_1) {
        println("received from port 1: on");
    }
}

void em_note_off(int pitch, int velocity) {
    println("off: " + pitch + ", " + velocity);
    if (pitch == EurorackMIDI.EM_PORT_1) {
        println("received from port 1: off");
    }
}
