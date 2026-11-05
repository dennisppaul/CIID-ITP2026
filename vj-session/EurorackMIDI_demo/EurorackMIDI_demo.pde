import wellen.*;

EurorackMIDI em;

//Adding variables to activate when getting MIDI Input
boolean inPort1_isActive = false;
boolean inPort2_isActive = false;
boolean inPort3_isActive = false;
boolean inPort4_isActive = false;
boolean inPort5_isActive = false;

//Array for hi hat elements
ArrayList<Particle> hiHatParticles;

//Array for the FM drum rings
ArrayList<FmRing> fmRings;

void setup() {
    size(1024, 768);

    Wellen.dumpMidiInputDevices();
    String midiDeviceName = "Eurorack Gate to MIDI";
    em = new EurorackMIDI(this, midiDeviceName);

    hiHatParticles = new ArrayList<Particle>();
    fmRings = new ArrayList<FmRing>();
}

void draw() {
    // semi transparent black rectangle to create a trail effect
    noStroke();
    fill(0, 50);
    rect(0, 0, width, height);

    if (inPort1_isActive == true) {
        kickVisual();
    }
    if (inPort2_isActive == true) {
        snareVisual();
    }
    if (inPort5_isActive == true) {
        addHiHatParticles();
    }

    updateHiHatParticles();
    displayHiHatParticles();
    
    updateFmRings();
    displayFmRings();
}

// ---------- KICK ----------

void kickVisual() {
    fill(255, 0, 0);
    noStroke();
    rect(0, 0, width, height);
    inPort1_isActive = false;
}

// ---------- SNARE ----------

void snareVisual() {
    stroke(255, 0, 0);
    fill(0);
    int posX = width/2;
    int posY = height/2;
    for (int index = 5; index > 0; index--) {
        strokeWeight(index);
        circle(posX, posY, index*50);
    }
    //inPort2_isActive = false;
}

// ---------- FM DRUM ----------

void mouseClicked() {
    // create a new ring where the mouse is and add it to the list
    addFmRing(mouseX, mouseY);
    em.send_output(EurorackMIDI.EM_PORT_3);
}

void addFmRing(float x, float y) {
    FmRing newRing = new FmRing(x, y);
    fmRings.add(newRing);
}

void updateFmRings() {
    // first, update all rings (grow and fade)
    for (FmRing thisRing : fmRings) {
        thisRing.update();
    }
    // then remove every ring that has fully faded out
    fmRings.removeIf(r -> !r.isAlive);
}

void displayFmRings() {
    for (FmRing thisRing : fmRings) {
        thisRing.display();
    }
}

// ---------- HI HAT ----------

void addHiHatParticles() {
    Particle newParticle = new Particle();
    hiHatParticles.add(newParticle);
}

void updateHiHatParticles() {
    // first, update all particles
    for (Particle thisParticle : hiHatParticles) {
        thisParticle.update();
    }
    // then remove every particle whose isAlive is false
    hiHatParticles.removeIf(p -> !p.isAlive);
}

void displayHiHatParticles() {
    for (Particle thisParticle : hiHatParticles) {
        thisParticle.display();
    }
}

// ---------- KEYBOARD ----------

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

// ---------- MIDI INPUT ----------

void em_note_on(int pitch, int velocity) {
    println("on : " + pitch + ", " + velocity);
    switch(pitch) {
    case EurorackMIDI.EM_PORT_1:
        inPort1_isActive = true;
        break;
    case EurorackMIDI.EM_PORT_2:
        inPort2_isActive = true;
        break;
    case EurorackMIDI.EM_PORT_3:
        inPort3_isActive = true;
        break;
    case EurorackMIDI.EM_PORT_4:
        inPort4_isActive = true;
        break;
    case EurorackMIDI.EM_PORT_5:
        inPort5_isActive = true;
        break;
    }
}

void em_note_off(int pitch, int velocity) {
    println("off: " + pitch + ", " + velocity);
    switch(pitch) {
    case EurorackMIDI.EM_PORT_1:
        inPort1_isActive = false;
        break;
    case EurorackMIDI.EM_PORT_2:
        inPort2_isActive = false;
        break;
    case EurorackMIDI.EM_PORT_3:
        inPort3_isActive = false;
        break;
    case EurorackMIDI.EM_PORT_4:
        inPort4_isActive = false;
        break;
    case EurorackMIDI.EM_PORT_5:
        inPort5_isActive = false;
        break;
    }
}
