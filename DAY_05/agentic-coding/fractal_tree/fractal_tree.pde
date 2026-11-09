// Fractal tree installation (v1: mouse input).
// A tree grows, holds, loses its limbs, fades, and a new tree grows.
// The whole tree tilts toward the person (mouse); when idle it sways gently.

// ===================== Tunable values =====================

// ---- Display ----
final boolean FULLSCREEN = false;    // true on the installation machine (also hides the cursor)
final int     DEV_WIDTH  = 1920;
final int     DEV_HEIGHT = 1080;
final int     BACKGROUND_COLOR = 0xFF000000;
final int     BRANCH_COLOR     = 0xFFFFFFFF;

// ---- Tree shape (lengths are fractions of screen height) ----
final int   TREE_DEPTH            = 10;     // levels below the trunk
final float TRUNK_LENGTH          = 0.20;
final float TRUNK_THICKNESS       = 0.018;
final float LENGTH_RATIO_MIN      = 0.66;   // child length / parent length
final float LENGTH_RATIO_MAX      = 0.80;
final float THICKNESS_RATIO       = 0.68;   // child thickness / parent thickness
final float MIN_THICKNESS_PX      = 1.0;
final float SPREAD_MIN_DEG        = 15;     // angle between a child and its parent
final float SPREAD_MAX_DEG        = 35;
final float ANGLE_JITTER_DEG      = 8;
final float THREE_CHILD_CHANCE    = 0.25;   // otherwise two children
final float MISSING_BRANCH_CHANCE = 0.08;   // never applied to the first two levels
final int   MAX_BRANCHES          = 6000;   // hard cap, keeps frame time and memory bounded

// ---- Life cycle (seconds) ----
final float GROW_TIME          = 90;   // seed to full tree
final float HOLD_TIME          = 60;   // full tree stands
final float FALL_TIME          = 40;   // longest time limbs keep breaking off
final float FADE_TIME          = 6;    // what is left fades out
final float BREAK_INTERVAL_MIN = 1.0;  // time between two limbs breaking
final float BREAK_INTERVAL_MAX = 3.0;
final int   BREAK_MAX_DEPTH    = 3;    // only limbs from depth 1..this break off (larger limbs)

// ---- Falling limbs ----
final float GRAVITY        = 0.6;  // fractions of screen height per second^2
final float LIMB_SPIN_MIN  = 15;   // degrees per second
final float LIMB_SPIN_MAX  = 60;
final float LIMB_PUSH      = 0.05; // sideways start speed, fractions of screen height per second
final float LIMB_FADE_TIME = 3.5;  // seconds until a falling limb is invisible

// ---- Interaction ----
final float MAX_TILT_DEG    = 15;  // strongest lean toward the person
final float TILT_SMOOTHING  = 1.2; // seconds; higher = slower, softer lean
final float IDLE_TIMEOUT    = 15;  // seconds without input until the piece is idle
final float SWAY_ANGLE_DEG  = 1.5; // idle sway
final float SWAY_PERIOD     = 7;   // seconds per sway

// ---- Sound (library: wellen) ----
final boolean SOUND_ENABLED     = true;
final float   MASTER_VOLUME     = 0.8;
final float   REVERB_DAMPING    = 0.5;
final float   REVERB_ROOMSIZE   = 0.85;
final float   REVERB_WET        = 0.4;
final int     ROOT_NOTE         = 45;   // MIDI note, 45 = A2 (110 Hz); drone pitch and key of all notes
final float   DRONE_VOLUME      = 0.25; // drone amplitude with a full tree
final float   DRONE_PAN_AMOUNT  = 0.6;  // how far the drone follows the tilt, 0..1
final int     GROWTH_VELOCITY   = 50;   // 0..127
final float   GROWTH_NOTE_LENGTH = 1.5; // seconds held before release
final float   GROWTH_PAN_SPREAD = 0.4;
final int     BREAK_VELOCITY    = 90;
final float   BREAK_NOTE_LENGTH = 0.6;
final int     CRACK_VELOCITY    = 70;
final float   CRACK_LENGTH      = 0.05;

// ===================== State =====================

final int PHASE_GROW = 0;
final int PHASE_HOLD = 1;
final int PHASE_FALL = 2;
final int PHASE_FADE = 3;

Tree tree;
ArrayList<FallingLimb> limbs = new ArrayList<FallingLimb>();
int   phase;
float phaseTime;   // seconds since the current phase started
float nextBreak;   // phaseTime at which the next limb breaks
float treeAlpha;   // 1 = fully visible
float tilt;        // radians, current lean of the whole tree
float clock;       // seconds since start
int   lastMillis;

void settings() {
    if (FULLSCREEN) {
        fullScreen(P2D);
    } else {
        size(DEV_WIDTH, DEV_HEIGHT, P2D);
    }
    smooth(8);
}

void setup() {
    if (FULLSCREEN) {
        noCursor();
    }
    strokeCap(ROUND);
    startNewTree();
    setupSound();
    lastMillis = millis();
}

void exit() {
    stopSound();
    super.exit();
}

void draw() {
    int now = millis();
    float dt = min((now - lastMillis) / 1000.0, 0.1); // clamp so a stall never causes a jump
    lastMillis = now;
    clock += dt;

    updateInput();
    updateTilt(dt);
    updateLifeCycle(dt);
    updateLimbs(dt);
    updateSound();

    background(BACKGROUND_COLOR);
    tree.draw(tilt, treeAlpha);
    drawLimbs();
}

// ===================== Life cycle =====================

void startNewTree() {
    tree = new Tree(width / 2.0, height);
    treeAlpha = 1;
    enterPhase(PHASE_GROW);
}

void enterPhase(int p) {
    phase = p;
    phaseTime = 0;
    if (p == PHASE_FALL) {
        nextBreak = random(BREAK_INTERVAL_MIN, BREAK_INTERVAL_MAX);
    }
}

void updateLifeCycle(float dt) {
    phaseTime += dt;
    tree.age += dt;

    if (phase == PHASE_GROW) {
        if (tree.age >= tree.growDuration) {
            enterPhase(PHASE_HOLD);
        }
    } else if (phase == PHASE_HOLD) {
        if (phaseTime >= HOLD_TIME) {
            enterPhase(PHASE_FALL);
        }
    } else if (phase == PHASE_FALL) {
        if (phaseTime >= nextBreak) {
            if (breakRandomLimb()) {
                nextBreak = phaseTime + random(BREAK_INTERVAL_MIN, BREAK_INTERVAL_MAX);
            } else {
                enterPhase(PHASE_FADE); // nothing left to break off
                return;
            }
        }
        if (phaseTime >= FALL_TIME) {
            enterPhase(PHASE_FADE);
        }
    } else if (phase == PHASE_FADE) {
        treeAlpha = max(0, 1 - phaseTime / FADE_TIME);
        if (treeAlpha <= 0) {
            startNewTree();
        }
    }
}

// ===================== Interaction =====================

void updateTilt(float dt) {
    float target;
    if (personPresent) {
        // angle from the trunk base to the person, measured from vertical, positive = right
        float toPerson = atan2(personX - tree.baseX, tree.baseY - personY);
        float maxTilt = radians(MAX_TILT_DEG);
        target = constrain(toPerson, -maxTilt, maxTilt);
    } else {
        target = radians(SWAY_ANGLE_DEG) * sin(TWO_PI * clock / SWAY_PERIOD);
    }
    tilt += (target - tilt) * (1 - exp(-dt / TILT_SMOOTHING));
}
