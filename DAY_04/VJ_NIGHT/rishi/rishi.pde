import wellen.*;

// One beat-lit dot grows into a line, rotation and a music-sized kaleidoscope.
// Keep the data folder beside this sketch. I: MIDI input. H: controls.
final int W = 1920, H = 1080, COUNT = 18, BLOB_COUNT = 18, HISTORY = 42;
PGraphics scene, picture, flare;
PShader blobShader, flareShader;
float[] blobPoints = new float[BLOB_COUNT*4], paint = new float[18];
// The original VJBlobs 4 moving field, viewed through six mirrored sections.
// The mirror is in the shader: every change appears identically in every section.
// Performance parameters: fewer layers = fewer cells, never random extra shapes.
final int GRID_MIN = 4, GRID_BASE = 6, GRID_MAX = 8;
final float FLASH_DECAY = 12, GRID_RESPONSE = 1.8;
final int SEEDS = GRID_MAX*GRID_MAX;
float gridSpan = GRID_MIN, gridTarget = GRID_MIN, blink;
float[] seedFade = new float[SEEDS];
Circle[] reactiveCells = new Circle[SEEDS];
float reactiveZoom = 1.1, reactiveRotation;
float[] kaleidoSeeds = new float[SEEDS*4];
float[] voices = new float[3]; // Three musical groups drive the shape families.
color[][] palettes = {
    {#02020A, #101426, #303B74, #62769C, #A7B8C5, #D2DAD8},
    {#0137A0, #135BA7, #65B4CF, #D9E3D7, #E5B26E, #C77818},
    {#A87FA1, #7D6F9D, #A28BAE, #C8A1AA, #E3B260, #D4A10C}
};
int palette = 1;
boolean palettePending;
float merge, introStyle, introFlood, introKaleido;
float fold, foldTarget;
final int LINE_DOTS=6;
final float LINE_GAP=220, LINE_LOOP=LINE_DOTS*LINE_GAP;
float lineTravel;
int musicStage; // 0 blinking dot, 1 rising line, 2 rotating circles, 3 blobs.
String lastChange = "Listening for music";
boolean grain = true, lightFlares = true;
float musicLight;
float[] energy = new float[3];
float[][] trailX = new float[COUNT][HISTORY];
float[][] trailY = new float[COUNT][HISTORY];
float[] riseY = new float[COUNT], dotAlpha = new float[COUNT];
boolean[] newDot = new boolean[COUNT];
int dotCount = 1, countedBeats;
float lastGrowthBeat = -10;
color[] rainbow = {#FF4726, #FFB629, #FFE52E, #31E660, #1749FF, #D62AFF, #E7FAFF};
float motion, introSpin, stage, pulse, clockTime;
float bpm = 120;             // Listening-window estimate; never a scene timer.
int lastTime;
boolean playing, blackout, help, soundCheck, freshTrails = true;
String[] stageNames = {"ONE BLINKING DOT", "RISING LINE", "ROTATING CIRCLES", "BLOBS"};

// A colour-wave passage for a confirmed change in musical texture.
// Ordinary beats launch waves during the passage; the blobs keep moving underneath.
final int MAX_RINGS = 12;
float[] ringData = new float[MAX_RINGS*4];
float[] ringRadius = new float[MAX_RINGS], ringStrength = new float[MAX_RINGS];
int ringSlot, ringLaunches, ringPassages;
float ringMix, ringFlood, ringFlow;
boolean bridgeMidpoint;

int ringMode, ringEndBeat = -100;
float ringProgress;

void setup() {
    fullScreen(P2D);            // Replace with size(960, 540, P2D) to practise.
    pixelDensity(1);
    frameRate(60);
    noCursor();
    noStroke();
    textFont(createFont("Monospaced", 16));
    scene = createGraphics(W, H, P2D);
    picture = createGraphics(W, H, P2D);
    blobShader = loadShader("journey_blobs.glsl");
    flare = createGraphics(W/2, H/2, P2D);
    flareShader = loadShader("light_flare.glsl");
    updatePalette(1);
    resetDots();
    resetRings();
    resetMovingField();
    setupInput();
    lastTime = millis();
    println("I hardware input | A MIDI monitor | 1-4 stages | H help");
}

void draw() {
    int now = millis();
    float elapsed = max(0, (now-lastTime)/1000.0);
    float dt = constrain(elapsed, 0.001, 0.05);
    lastTime = now;
    clockTime += elapsed;
    readInput(dt);
    if (playing) {
        updateVisualStage(dt); // Only a musical change sets the destination stage.
        pulse *= exp(-dt*5);
        blink *= exp(-dt*FLASH_DECAY);
        moveWithSound(dt);
        fold += (foldTarget-fold)*min(1, dt*1.6);
        updateMusicPalette(dt);
        updateRings(dt);
    }
    if (playing) {
        // Once the kaleidoscope takes over, its hidden opening circles need no drawing.
        if (introKaleido<0.5 || introStyle<1) {
            scene.beginDraw();
            scene.background(0);
            scene.noStroke();
            drawJourney(dt);
            scene.endDraw();
        } else freshTrails=true;
        arrangeBlobs(dt);
        if (merge > 0) drawBlobs();
        if (lightFlares) drawFlare();
    }
    float wantedLight = min(1, pow(audio.level, 0.70)*1.25);
    musicLight = follow(musicLight, wantedLight, wantedLight > musicLight ? 16 : 5, dt);
    if (audio.level < 0.001 && musicLight < 0.002) musicLight = 0;
    background(0);
    float fit = min(width/(float)W, height/(float)H);
    pushMatrix();
    translate((width-W*fit)/2, (height-H*fit)/2);
    scale(fit);
    if (playing && !blackout) {
        // The first dot already blinks with alpha; avoid dimming its flash twice.
        float displayLight=lerp(1, musicLight, ease(stage));
        tint(255, 255*displayLight);
        image(merge > 0 ? picture : scene, 0, 0);
        if (lightFlares) {
            blendMode(ADD);
            image(flare, 0, 0, W, H);
            blendMode(BLEND);
        }
        noTint();
    }
    if ((help || !playing) && !blackout) drawHelp();
    if (soundCheck && !blackout) drawSoundCheck();
    popMatrix();
}

void moveWithSound(float dt) {
    // Keep the original fast response to the three musical families.
    energy[0] = audio.bass;
    energy[1] = audio.mids;
    energy[2] = audio.highs;
    motion += dt*(audio.level*0.9 + audio.mids*1.5 + audio.highs*0.5);
    if (audio.beatNow) motion += 0.16*audio.kick;
    audio.beatNow = false;
    introSpin += dt*(audio.mids*2.4 + audio.highs*1.1 + audio.bass*0.6);
    reactiveRotation += dt*audio.mids*0.10;
    float wantedZoom = 1.05+audio.bass*0.35-audio.highs*0.12+audio.kick*0.05;
    reactiveZoom = follow(reactiveZoom, wantedZoom, 8, dt);
}

void updateVisualStage(float dt) {
    // This is just smoothing after a cue, not a schedule for choosing stages.
    float rate=musicStage==3 && stage<2.999 ? 1.5 : 5;
    stage += (musicStage-stage)*(1-exp(-dt*audio.level*rate));
    if (abs(stage-musicStage) < 0.001) stage = musicStage;
    float nextMerge=ease(stage-2);
    // Show exactly the shared colour once when the two geometries exchange places.
    if ((merge<0.66 && nextMerge>=0.66) || (merge>0.66 && nextMerge<=0.66)) merge=0.66;
    else merge=nextMerge;
    introStyle=ease((merge-0.12)/0.20);
    introFlood=merge<0.66 ? ease((merge-0.32)/0.34) : 1-ease((merge-0.66)/0.34);
    // Reverse previews also exchange geometry at the full-colour frame.
    introKaleido=merge==0.66 ? (musicStage==3 ? 1 : 0) : (merge>0.66 ? 1 : 0);
}

boolean musicalChange(String reason) {
    if (!playing || abs(stage-musicStage) > 0.08) return false;
    if (ringMode == 2) {
        ringMode = 3;
        ringProgress = 0;
        lastChange = reason + " / returning to blobs";
        return true;
    }
    if (ringMode != 0) return false;
    if (musicStage < 3) {
        musicStage++;
        if (musicStage==1) revealLine();
        lastChange = reason;
        return true;
    }
    if (countedBeats-ringEndBeat < 4) return false;
    startRings(reason, false);
    return ringMode != 0;
}

void drawJourney(float dt) {
    float lineGrowth = ease(stage);
    float gather = ease(stage-1);
    float arrange = ease(stage-2);
    float overlap = arrange;
    // The line is one convoy: music changes its common speed, never its spacing.
    float speed=audio.level*65+audio.bass*90+audio.mids*45+max(audio.kick, max(audio.swell, audio.tick))*150;
    if (gather<0.001) lineTravel=(lineTravel+dt*speed*lineGrowth)%LINE_LOOP;
    float trailFade=1-ease(merge/0.12);
    // One stationary dot blinks on hits. New parts let it grow into a moving line.
    int tail = round(lerp(lerp(0, HISTORY-1, gather), 2, overlap));

    for (int i = 0; i < dotCount; i++) {
        float seed = i*TWO_PI/COUNT;
        int family = i%3;
        float voice = energy[family];
        float attack = family == 0 ? audio.kick : family == 1 ? audio.swell : audio.tick;
        // Fixed slots wrap beyond the screen. Freeze their endpoints as the line curls.
        if (i<LINE_DOTS && gather<0.001) {
            float y=linePosition(i);
            if (abs(y-riseY[i])>LINE_LOOP/2) newDot[i]=true;
            riseY[i]=y;
        }
        float freeX=W/2, freeY=riseY[i];
        dotAlpha[i] = min(1, dotAlpha[i]+dt*4);
        // The same circles gather around a slowly drifting centre.
        float orbit = introSpin + seed;
        float radius = (130 + family*85)*(1 + voice*0.35 + attack*0.30);
        float orbitX = W/2 + sin(motion*0.28)*170 + cos(orbit)*radius;
        float orbitY = H/2 + cos(motion*0.23)*65 + sin(orbit)*radius;
        // Extra orbit dots are born on their orbit, not on top of a line slot.
        if (i>=LINE_DOTS) {
            freeX=orbitX;
            freeY=orbitY;
        }
        // Three groups of six become the foundation of the eventual blob field.
        int ring = i/6;
        float angle = (i%6)*TWO_PI/6 + introSpin*0.65 + ring*0.18;
        float ringVoice = energy[ring];
        float ringAttack = ring == 0 ? audio.kick : ring == 1 ? audio.swell : audio.tick;
        float reach = (145 + ring*140)*(1 + ringVoice*0.20 + ringAttack*0.18);
        reach *= 1 + fold*0.45;
        float patternX = W/2 + cos(angle)*reach;
        float patternY = H/2 + fold*H/2 + sin(angle)*reach;
        float x = lerp(lerp(freeX, orbitX, gather), patternX, arrange);
        float y = lerp(lerp(freeY, orbitY, gather), patternY, arrange);

        for (int j = HISTORY-1; j > 0; j--) {
            trailX[i][j] = trailX[i][j-1];
            trailY[i][j] = trailY[i][j-1];
        }
        trailX[i][0] = x;
        trailY[i][0] = y;
        if (freshTrails || newDot[i]) {
            for (int j = 1; j < HISTORY; j++) {
                trailX[i][j] = x;
                trailY[i][j] = y;
            }
            newDot[i] = false;
        }

        float diameter = lerp(27+family*6, ring == 0 ? 44 : ring == 1 ? 100 : 76, overlap);
        diameter *= 1 + voice*0.65 + attack*0.9;
        diameter *= 1 + merge*(0.18*sin(motion*(0.55+ring*0.2)+ring) + pulse*0.15 + energy[ring]*0.22);
        diameter *= 1 + fold*0.45;
        if (i==0) diameter=lerp(24+blink*34, diameter, lineGrowth);
        float visibility=lerp(ease(blink*1.5), 1, lineGrowth);
        if (i>=LINE_DOTS) visibility*=gather;
        // The shader receives these exact positions and sizes, in bottom-up coordinates.
        blobPoints[i*4] = (x-W/2)/H;
        blobPoints[i*4+1] = (H/2-y)/H;
        blobPoints[i*4+2] = diameter*0.5/H * dotAlpha[i] * (i>=LINE_DOTS ? gather : 1);
        blobPoints[i*4+3] = ring;
        color ink = lerpColor(rainbow[i%rainbow.length], #C77818, introStyle);
        for (int j = tail; j >= 0; j--) {
            float strength = 1-j/(float)(tail+1);
            scene.fill(ink, pow(strength, 1.6)*220*dotAlpha[i]*visibility*(j==0 ? 1 : trailFade));
            scene.circle(trailX[i][j], trailY[i][j], diameter*(0.6+strength*0.4));
        }
        // Geometry stays continuous when the shader takes over.
    }
    freshTrails = false;
}

float ease(float value) {
    float t = constrain(value, 0, 1);
    return t*t*(3-2*t);
}

void onBeat(float strength) {
    playing = true;
    pulse = max(pulse, strength);
    blink = max(blink, strength);
    // Keep double hits from growing several dots at once.
    if (clockTime-lastGrowthBeat < 0.18) return;
    lastGrowthBeat = clockTime;
    countedBeats++;
    introSpin += strength*0.10;
    if (ringMode != 0) {
        launchRing(strength);
        ringFlow = 0;
        // Hits help carry a requested bridge; no sound means no bridge progress.
        if (ringMode == 1 || ringMode == 3) advanceRingBridge(strength*0.08);
    }
    // The first part stays a single dot. New parts open the line; hits add its dots.
    int wantedDots=min(COUNT, 1+max(1, parts-1)*5);
    if (musicStage==2 && dotCount<wantedDots) {
        riseY[dotCount] = H*0.68;
        newDot[dotCount] = true;
        dotAlpha[dotCount] = 0;
        dotCount++;
    }
}

void resetDots() {
    dotCount = 1;
    blink=0;
    lineTravel=0;
    countedBeats = 0;
    lastGrowthBeat = -10;
    for (int i = 0; i < COUNT; i++) {
        riseY[i] = i<LINE_DOTS ? linePosition(i) : H*0.68;
        dotAlpha[i] = i==0 ? 1 : 0;
        newDot[i] = true;
    }
}

float linePosition(int slot) {
    float margin=(LINE_LOOP-H)/2;
    float y=H*0.68-slot*LINE_GAP-lineTravel+margin;
    return -margin+((y%LINE_LOOP)+LINE_LOOP)%LINE_LOOP;
}

void revealLine() {
    // Reveal the complete lattice together: there are no missing slots or clumps.
    for (int i=dotCount; i<LINE_DOTS; i++) {
        riseY[i]=linePosition(i);
        dotAlpha[i]=0;
        newDot[i]=true;
    }
    dotCount=max(dotCount, LINE_DOTS);
}

void resetJourney() {
    stage = 0;
    motion = introSpin = pulse = musicLight = 0;
    resetMovingField();
    for (int i = 0; i < 3; i++) energy[i] = 0;
    musicStage = 0;
    lastChange = "Listening for music";
    merge = introStyle = introFlood = introKaleido = fold = foldTarget = 0;
    palette = 1;
    updatePalette(1);
    for (int i = 0; i < blobPoints.length; i++) blobPoints[i] = 0;
    for (int i = 0; i < voices.length; i++) voices[i] = 0;
    playing = blackout = false;
    palettePending = false;
    freshTrails = true;
    resetDots();
    resetInput();
    resetRings();
}

void keyPressed() {
    if (keyEvent.isAutoRepeat()) return;
    if (key == ' ') onBeat(1);
    if (key >= '1' && key <= '4') {
        playing = true;
        musicStage = key-'1';
        if (key > '1') dotCount = key=='2' ? LINE_DOTS : COUNT;
        else {
            resetDots();
            java.util.Arrays.fill(blobPoints, 0);
        }
        freshTrails = true;
    }
    if (key == 'n' || key == 'N') {
        playing = true;
        musicalChange("manual new element");
    }
    if (key == 'r' || key == 'R') resetJourney();
    if (key == 'b' || key == 'B') blackout = !blackout;
    if (key == 'h' || key == 'H') help = !help;
    if (key == 'a' || key == 'A') soundCheck = !soundCheck;
    inputKey();
    if (key == 'c' || key == 'C') {
        palette = (palette+1)%palettes.length;
        palettePending = false;
    }
    if (key == 'f' || key == 'F') foldTarget = 1-foldTarget;
    if (key == 'g' || key == 'G') grain = !grain;
    if (key == 'l' || key == 'L') lightFlares = !lightFlares;
    if (key == 't' || key == 'T') startRings("manual rings", true);
}

void mousePressed() {
    onBeat(1);
}

void drawHelp() {
    fill(0, 210);
    rect(25, 25, 1830, 150);
    fill(255);
    text("I hardware input | A MIDI monitor | N new part | T rings | 1-4 stages | H", 45, 55);
    String state = ringMode != 0 ? "RINGS" : stageNames[musicStage];
    text(state + " / " + dotCount + " dots / hits " + countedBeats + " / last cue: " + lastChange, 45, 86);
    text(inputStatus, 45, 117);
    text("MIDI parts " + parts + " / " + round(bpm) + " BPM | L light flare | R restart | B blackout | C palette", 45, 148);
}

// New musical texture requests one colour change; normal hits keep the palette.
void musicPaletteChange() {
    if (musicStage==3 && merge>0.99) palettePending=true;
}

void updateMusicPalette(float dt) {
    // Finish the shared-colour transition before starting the next palette fade.
    float difference=0;
    for (int i=0; i<6; i++) {
        difference=max(difference, abs(paint[i*3]-red(palettes[palette][i])/255.0));
        difference=max(difference, abs(paint[i*3+1]-green(palettes[palette][i])/255.0));
        difference=max(difference, abs(paint[i*3+2]-blue(palettes[palette][i])/255.0));
    }
    if (palettePending && difference<0.01 && audio.level>0.01 && ringMode!=1 && ringMode!=3) {
        palette=(palette+1)%palettes.length;
        palettePending=false;
    }
    updatePalette(1-exp(-dt*0.8));
}

void updatePalette(float amount) {
    for (int i = 0; i < 6; i++) {
        color c = palettes[palette][i];
        paint[i*3] += (red(c)/255.0-paint[i*3])*amount;
        paint[i*3+1] += (green(c)/255.0-paint[i*3+1])*amount;
        paint[i*3+2] += (blue(c)/255.0-paint[i*3+2])*amount;
    }
}

// The original spring movement, extended to a smoothly growing grid.
void resetMovingField() {
    reactiveZoom=1.1;
    reactiveRotation=0;
    gridSpan=gridTarget=GRID_MIN;
    java.util.Arrays.fill(seedFade, 0);
    for (int i=0; i<SEEDS; i++) reactiveCells[i]=new Circle(i);
}

void arrangeBlobs(float dt) {
    // Four parts retain the familiar 6x6 field; five make 7x7, six or more 8x8.
    if (parts>0) gridTarget=constrain(parts+2, GRID_MIN, GRID_MAX);
    gridSpan=follow(gridSpan, gridTarget, GRID_RESPONSE, dt*audio.level);
    if (abs(gridSpan-gridTarget)<0.001) gridSpan=gridTarget;
    for (int i=0; i<SEEDS; i++) {
        reactiveCells[i].move(dt);
        kaleidoSeeds[i*4]=reactiveCells[i].position.x;
        kaleidoSeeds[i*4+1]=reactiveCells[i].position.y;
        // Keep a similar amount of overlap as the number of cells changes.
        kaleidoSeeds[i*4+2]=reactiveCells[i].size*GRID_BASE/gridSpan;
        seedFade[i]=min(ease(gridSpan-reactiveCells[i].column), ease(gridSpan-reactiveCells[i].row));
        kaleidoSeeds[i*4+3]=reactiveCells[i].edge;
    }
}

float follow(float current, float target, float rate, float dt) {
    return lerp(current, target, 1-exp(-rate*dt));
}

void drawBlobs() {
    blobShader.set("resolution", (float)W, (float)H);
    blobShader.set("circles", blobPoints, 4);
    blobShader.set("colours", paint, 3);
    blobShader.set("uMerge", introStyle);
    blobShader.set("seeds", kaleidoSeeds, 4);
    blobShader.set("seedFade", seedFade, 1);
    blobShader.set("uZoom", reactiveZoom);
    blobShader.set("uRotation", reactiveRotation+audio.tick*0.018);
    blobShader.set("uKaleido", introKaleido);
    blobShader.set("uFold", fold);
    blobShader.set("uGrain", grain ? 0.12 : 0);
    blobShader.set("rings", ringData, 4);
    blobShader.set("uRingMix", ringMix);
    blobShader.set("uFlood", max(ringFlood, introFlood));
    picture.beginDraw();
    picture.shader(blobShader);
    picture.image(scene, 0, 0);
    picture.resetShader();
    picture.endDraw();
}

// Separate highlight-only light pass. The original picture stays full resolution.
void drawFlare() {
    flareShader.set("uTexel", 1.0/W, 1.0/H);
    flareShader.set("uStrength", 0.06+0.44*max(audio.kick, max(audio.swell, audio.tick)));
    flareShader.set("uTransition", max(introFlood, ringFlood));
    flare.beginDraw();
    flare.shader(flareShader);
    flare.image(merge>0 ? picture : scene, 0, 0, flare.width, flare.height);
    flare.resetShader();
    flare.endDraw();
}

// Ring passages and their full-colour transitions.
void startRings(String reason, boolean manual) {
    if (!playing || musicStage != 3 || merge < 0.99 || ringMode != 0) return;
    if (!manual && countedBeats-ringEndBeat < 4) return;
    ringMode = 1;
    ringProgress = 0;
    ringFlow = 0;
    bridgeMidpoint = false;
    lastChange = reason;
    ringPassages++;
    launchRing(1);
}

void launchRing(float strength) {
    ringRadius[ringSlot] = 0.025;
    ringStrength[ringSlot] = constrain(strength, 0.25, 1);
    ringSlot = (ringSlot+1)%MAX_RINGS;
    ringLaunches++;
}

void advanceRingBridge(float amount) {
    float next = min(1, ringProgress+amount);
    // Show one fully filled frame exactly where the two pictures exchange places.
    if (ringProgress < 0.5 && next >= 0.5) {
        ringProgress = 0.5;
        bridgeMidpoint = true;
    } else if (!bridgeMidpoint) ringProgress = next;
}

void updateRings(float dt) {
    // Only a confirmed musical change starts/ends this passage.
    // Energy and actual hits carry its full-colour bridge, including during entrance.
    if (ringMode == 1 || ringMode == 3) {
        if (!bridgeMidpoint) advanceRingBridge(dt*audio.level*0.45);
        ringFlood = ringProgress < 0.5 ? ease(ringProgress*2) : 1-ease((ringProgress-0.5)*2);
        ringMix = ringMode == 1 ? (ringProgress < 0.5 ? 0 : 1) : (ringProgress < 0.5 ? 1 : 0);
        bridgeMidpoint = false;
        if (ringProgress >= 1) {
            if (ringMode == 1) {
                ringMode = 2;
                ringMix = 1;
            } else {
                ringMode = 0;
                ringMix = 0;
                ringEndBeat = countedBeats;
            }
            ringFlood = 0;
        }
    } else {
        ringFlood = 0;
        ringMix = ringMode == 2 ? 1 : 0;
    }
    if (ringMode != 0) {
        // Sustained notes still carry waves; actual attacks reset this energy phase.
        ringFlow += dt*(audio.bass*0.3+audio.mids*0.6+audio.highs*0.4+audio.level*0.2);
        if (ringFlow >= 1) {
            ringFlow %= 1;
            launchRing(max(audio.bass, max(audio.mids, audio.highs)));
        }
    }
    float speed = audio.level*0.10 + audio.bass*0.26 + audio.mids*0.22 + audio.highs*0.14
        + max(audio.kick, max(audio.swell, audio.tick))*0.32;
    for (int i=0; i<MAX_RINGS; i++) {
        if (ringStrength[i] == 0) continue;
        ringRadius[i] += dt*speed;
        float radius = ringRadius[i];
        if (radius>=1.3) {
            ringStrength[i]=0;
            ringData[i*4+2]=0;
            continue;
        }
        ringData[i*4] = radius;
        ringData[i*4+1] = (0.018+radius*0.055)*(1+audio.bass*0.8+audio.kick*0.5);
        ringData[i*4+2] = ringStrength[i]*(0.5+audio.level*0.5)*(1-ease((radius-0.85)/0.45));
    }
}


void resetRings() {
    ringSlot = ringLaunches = ringPassages = 0;
    ringMode = 0;
    ringProgress = 0;
    ringEndBeat = -100;
    ringMix = ringFlood = ringFlow = 0;
    bridgeMidpoint = false;
    for (int i = 0; i < MAX_RINGS; i++) {
        ringRadius[i] = 0;
        ringStrength[i] = 0;
    }
    for (int i = 0; i < ringData.length; i++) ringData[i] = 0;
}


// MIDI shows actual messages and active channels; it does not listen to the mic.
void drawSoundCheck() {
    pushStyle();
    fill(8, 12, 24, 235);
    rect(28, H-245, W-56, 217, 12);
    fill(240);
    textSize(20);
    text("MIDI MONITOR / A hides this", 52, H-210);
    text(inputStatus, 52, H-174);
    text("Parts: "+parts+" / "+round(bpm)+" BPM / "+(transportRunning ? "RUNNING" : "STOPPED")+
        " / grid: "+nf(gridSpan, 1, 1)+" toward "+round(gridTarget)+"x"+round(gridTarget)+
        " / messages: "+receivedMessages, 52, H-140);
    text("Last: "+lastMidiMessage+" / cue: "+lastChange, 52, H-106);
    int shown=0;
    for (int c=0; c<confirmed.length && shown<8; c++) {
        if (!confirmed[c]) continue;
        fill(palettes[palette][4]);
        rect(52+shown*216, H-80, 202, 26);
        fill(#102138);
        textSize(14);
        String label=partLabel[c];
        if (label.length()>22) label=label.substring(label.length()-22);
        text(label, 58+shown*216, H-61);
        shown++;
    }
    if (shown==0) {
        fill(190);
        textSize(15);
        text("Play a pad, turn a control, or send MIDI notes.", 52, H-61);
    }
    popStyle();
}

// Original VJBlobs 4 springs and band response; grid anchors now ease with density.
class Circle {
    PVector position = new PVector(), velocity = new PVector(), destination = new PVector();
    float size = 0.025, edge, phase;
    int column, row, family;

    Circle(int number) {
        column = number / GRID_MAX;
        row = number % GRID_MAX;
        family = (column + row) % 3;  // Bass, mids, highs alternate across the grid.
        phase = column * 1.73 + row * 2.41;
        position.set(anchor());
    }

    PVector anchor() {
        return new PVector(((column + 0.5) / gridSpan - 0.5) * W / H,
            (row + 0.5) / gridSpan - 0.5);
    }

    void move(float dt) {
        float voice = family == 0 ? audio.bass : family == 1 ? audio.mids : audio.highs;
        float attack = family == 0 ? audio.kick : family == 1 ? audio.swell : audio.tick;

        // Large, soft bass masses; medium ribbons; small, sharp high-frequency cells.
        float reach = family == 0 ? 0.25 : family == 1 ? 0.18 : 0.14;
        float breath = 0.65 + 0.35 * sin(phase + motion * (0.65 + family * 0.45));
        float wantedSize = 0.018 + voice * reach * breath
            + attack * reach * (family == 2 ? 0.45 : 0.20);
        float response = family == 2 ? (wantedSize > size ? 48 : 18)
            : (wantedSize > size ? 25 : 8);
        size = follow(size, wantedSize, response, dt);
        edge = follow(edge, family == 2 ? 0.20 + audio.highs * 0.80 : 0, 24, dt);

        destination.set(((column+0.5)/gridSpan-0.5)*W/H, (row+0.5)/gridSpan-0.5);
        float sweep = 0.012 * audio.level + 0.055 * audio.mids;
        destination.x += sin(phase + motion * 0.9) * sweep;
        destination.y += cos(phase * 1.3 + motion * 0.7) * sweep;
        if (family == 0) destination.mult(1 - audio.kick * 0.16);
        if (family == 2) destination.x += sin(phase + motion * 8) * audio.tick * 0.018;

        // Damped springs keep the weight, while the high-frequency cells move faster.
        float stiffness = family == 2 ? 180 : 75;
        float damping = family == 2 ? 16 : 10;
        int steps = max(1, ceil(dt * 120));
        float step = dt / steps;
        float drag = exp(-damping*step);
        for (int i = 0; i < steps; i++) {
            velocity.x += (destination.x - position.x) * stiffness * step;
            velocity.y += (destination.y - position.y) * stiffness * step;
            velocity.mult(drag);
            position.x += velocity.x * step;
            position.y += velocity.y * step;
        }
    }
}
