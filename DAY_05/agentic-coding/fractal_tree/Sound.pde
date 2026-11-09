// Sound (library: wellen, https://github.com/dennisppaul/wellen)
//
// - drone:   a low sustained tone that swells as the tree grows, thins as limbs fall,
//            fades with the tree, and pans with the tilt toward the person.
// - growth:  a soft note each time a new level of branches starts to sprout,
//            rising through a pentatonic scale from trunk to tips.
// - breaks:  a short noise crack plus a low note when a limb snaps off,
//            panned to where it breaks; larger limbs sound lower.
//
// All calls run on the animation thread. Note-offs are timed here, not by wellen's timer,
// so no other thread changes the selected instrument.
// If audio fails, sound switches off and the visuals keep running.

import wellen.*;
import wellen.dsp.*;

final int DRONE_VOICE        = 0;
final int GROWTH_VOICE_FIRST = 1;   // voices 1..6
final int GROWTH_VOICE_COUNT = 6;
final int BREAK_VOICE_FIRST  = 7;   // voices 7..10, tone
final int BREAK_VOICE_COUNT  = 4;
final int CRACK_VOICE_FIRST  = 11;  // voices 11..14, noise
final int CRACK_VOICE_COUNT  = 4;
final int VOICE_COUNT        = 16;

boolean soundOn = false;
Tree    soundTree;           // tree the growth notes belong to
int     nextGrowthLevel;
int     nextGrowthVoice;
int     nextBreakVoice;
int     nextCrackVoice;
int[]   voiceNote  = new int[VOICE_COUNT];
float[] voiceOffAt = new float[VOICE_COUNT]; // clock time for note-off, < 0 = not playing

void setupSound() {
    if (!SOUND_ENABLED) {
        return;
    }
    try {
        Tone.enable_reverb(REVERB_DAMPING, REVERB_ROOMSIZE, REVERB_WET);
        Tone.get_DSP_engine().set_gain(MASTER_VOLUME);

        Instrument drone = Tone.instrument(DRONE_VOICE);
        drone.preset(Wellen.INSTRUMENT_PRESET_SUB_SINE);
        drone.enable_ADSR(false); // amplitude is set directly every frame
        drone.set_frequency(Note.note_to_frequency(ROOT_NOTE));
        drone.set_amplitude(0);

        for (int i = 0; i < GROWTH_VOICE_COUNT; i++) {
            Instrument v = Tone.instrument(GROWTH_VOICE_FIRST + i);
            v.preset(Wellen.INSTRUMENT_PRESET_SIMPLE);
            v.set_oscillator_type(Wellen.WAVEFORM_SINE);
            v.set_adsr(0.02, 0.4, 0.3, 2.5);
        }
        for (int i = 0; i < BREAK_VOICE_COUNT; i++) {
            Instrument v = Tone.instrument(BREAK_VOICE_FIRST + i);
            v.preset(Wellen.INSTRUMENT_PRESET_SUB_SINE);
            v.set_adsr(0.005, 0.3, 0.2, 1.2);
        }
        for (int i = 0; i < CRACK_VOICE_COUNT; i++) {
            Instrument v = Tone.instrument(CRACK_VOICE_FIRST + i);
            v.preset(Wellen.INSTRUMENT_PRESET_NOISE);
            v.set_adsr(0.001, 0.06, 0.0, 0.08);
        }
        Tone.instrument(0); // leave a defined selection

        for (int i = 0; i < VOICE_COUNT; i++) {
            voiceOffAt[i] = -1;
        }
        soundOn = true;
    } catch (Exception e) {
        soundFailed(e);
    }
}

void updateSound() {
    if (!soundOn) {
        return;
    }
    try {
        // growth notes, one per branch level as it starts to sprout
        if (soundTree != tree) {
            soundTree = tree;
            nextGrowthLevel = 0;
        }
        while (nextGrowthLevel <= TREE_DEPTH && tree.age >= tree.levelStart[nextGrowthLevel]) {
            int note = Scale.get_note(Scale.MINOR_PENTATONIC, ROOT_NOTE + 12, nextGrowthLevel);
            float pan = random(-GROWTH_PAN_SPREAD, GROWTH_PAN_SPREAD);
            playNote(GROWTH_VOICE_FIRST + nextGrowthVoice, note, GROWTH_VELOCITY, GROWTH_NOTE_LENGTH, pan);
            nextGrowthVoice = (nextGrowthVoice + 1) % GROWTH_VOICE_COUNT;
            nextGrowthLevel++;
        }

        // drone follows the tree's life: grown fraction, branches left, fade, tilt
        float grown = constrain(tree.age / tree.growDuration, 0, 1);
        float left = 0.3 + 0.7 * tree.attachedCount / (float) tree.branches.size();
        float amp = DRONE_VOLUME * grown * left * treeAlpha;
        Instrument drone = Tone.instrument(DRONE_VOICE);
        drone.set_amplitude(amp, Wellen.millis_to_samples(100));
        drone.set_pan(constrain(tilt / radians(MAX_TILT_DEG), -1, 1) * DRONE_PAN_AMOUNT);

        // timed note-offs
        for (int i = 0; i < VOICE_COUNT; i++) {
            if (voiceOffAt[i] >= 0 && clock >= voiceOffAt[i]) {
                Tone.note_off_instrument(i, voiceNote[i]);
                voiceOffAt[i] = -1;
            }
        }
    } catch (Exception e) {
        soundFailed(e);
    }
}

// called when a limb snaps off; screenX is where it breaks
void soundLimbBreak(Branch b, float screenX) {
    if (!soundOn) {
        return;
    }
    try {
        float pan = constrain(map(screenX, 0, width, -1, 1), -1, 1);
        // depth 1 (largest limbs) lowest, smaller limbs a step higher each
        int note = Scale.get_note(Scale.MINOR_PENTATONIC, ROOT_NOTE - 12, (b.depth - 1) * 2);
        playNote(BREAK_VOICE_FIRST + nextBreakVoice, note, BREAK_VELOCITY, BREAK_NOTE_LENGTH, pan);
        nextBreakVoice = (nextBreakVoice + 1) % BREAK_VOICE_COUNT;
        playNote(CRACK_VOICE_FIRST + nextCrackVoice, ROOT_NOTE, CRACK_VELOCITY, CRACK_LENGTH, pan);
        nextCrackVoice = (nextCrackVoice + 1) % CRACK_VOICE_COUNT;
    } catch (Exception e) {
        soundFailed(e);
    }
}

void playNote(int voice, int note, int velocity, float length, float pan) {
    if (voiceOffAt[voice] >= 0) {
        Tone.note_off_instrument(voice, voiceNote[voice]); // voice reused before its note ended
    }
    Tone.instrument(voice).set_pan(pan);
    Tone.note_on_instrument(voice, note, velocity);
    voiceNote[voice] = note;
    voiceOffAt[voice] = clock + length;
}

void soundFailed(Exception e) {
    println("sound disabled: " + e);
    soundOn = false;
}

void stopSound() {
    if (soundOn) {
        try {
            Tone.stop();
        } catch (Exception e) {
            // shutting down anyway
        }
        soundOn = false;
    }
}
