PShader testShader, ppShader;
PGraphics[] buffers = new PGraphics[2];
int currentBuffer = 0;
float beatCounter = 0;

import processing.sound.*;
SoundFile sample;
Amplitude amplitude;
BeatDetector beatDetector;
PitchDetector pitchDetector;
FFT fft;

void setup() {
    // size(720, 480, P2D);
    fullScreen(P2D);
    audioSetup();

    // TEST SHADER
    testShader = loadShader("fragShader.glsl");
    testShader.set("uResolution", float(pixelWidth), float(pixelHeight));

    // PINGPONG SHADER
    ppShader = loadShader("pingpong.glsl");
    ppShader.set("uResolution", float(pixelWidth), float(pixelHeight));

    // CREATE BUFFERS
    for (int i = 0; i < buffers.length; i++) {
        buffers[i] = createGraphics(720, 480, P2D);
        buffers[i].beginDraw();
        buffers[i].background(0);
        buffers[i].endDraw();
    }
}

void draw() {
    float time = millis() / 1000.0;
    beatDetection();
    pingPong(time);

    // TEST SHADER
    testShader.set("uTime", time);
    shader(testShader);
    rect(0, 0, width, height);
}

void audioSetup() {
    // AUDIO SETUP
    sample = new SoundFile(this, "drums.wav");
    sample.loop();
    // AMPLITUDE DETECTOR
    amplitude = new Amplitude(this);
    amplitude.input(sample);
    // BEAT DETECTOR
    beatDetector = new BeatDetector(this);
    beatDetector.input(sample);
    beatDetector.sensitivity(140);
    // PITCH DETECTOR
    pitchDetector = new PitchDetector(this);
    pitchDetector.input(sample);
    // FFT
    fft = new FFT(this, 512);
    fft.input(sample);
}

void pingPong(float time) {
    PGraphics src = buffers[currentBuffer];
    PGraphics dst = buffers[1 - currentBuffer];
    ppShader.set("uTexture", src);
    ppShader.set("uTime", time);

    // BUFFER DRAW
    dst.beginDraw();
    dst.shader(ppShader);
    dst.image(src, 0, 0);
    dst.resetShader();
    dst.endDraw();

    // SET TEXTURE IN MAIN SHADER
    testShader.set("ppTexture", dst);

    // SWAP BUFFERS
    currentBuffer = 1 - currentBuffer;
}

void beatDetection() {
    double[] energyBuffer = beatDetector.getEnergyBuffer();
    int cursor = beatDetector.getEnergyCursor();

    ppShader.set("uEnergy", (float) energyBuffer[cursor] / 100.0);

    if (beatDetector.isBeat()) {
        beatCounter++;
        testShader.set("uBeatCounter", beatCounter);
    }
}

void amplitudeDetection() {
    float amp = amplitude.analyze();
    ppShader.set("uAmplitude", amp);
}
