import processing.sound.SoundFile;
import processing.sound.FFT;

SoundFile song;
FFT fft;
float[] spectrum;
boolean started = false;
float peak = 0.0001;   // running maximum of the spectrum, used to normalise it to 0-1

final int COLS = 40;
final int ROWS = 40;
final int SPACING = 15;
final int DIAMETER = 15;
final int USEFUL_BINS = 128;
final int BANDS = 1024;   // number of FFT bands

// quiet -> loud scale of letters
final String RAMP = "kbmcgyrw";

String[] GRID = new String[ROWS];
// the same thing as colours: colors[row][col]
color[][] colors = new color[ROWS][COLS];

// retro colours
color palette(char c) {
  switch (c) {
    case 'w': return #ffffff;
    case 'r': return #ff0000;
    case 'y': return #ffff00;
    case 'g': return #00ff00;
    case 'c': return #00ffff;
    case 'b': return #0000ff;
    case 'm': return #ff00ff;
    default:  return #000000;   // 'k'
  }
}

void setup() {
  size(720, 720);
  noStroke();

  fft = new FFT(this, BANDS);
  spectrum = new float[BANDS];

  song = new SoundFile(this, "rainbow.mp3");

  fft.input(song);   // required in Processing: tells the FFT what to analyse
}

void mousePressed() {
  // no autoplay restriction on desktop, so userStartAudio() isn't needed
  if (song == null) return;
  if (song.isPlaying()) {
    song.pause();
  } else {
    song.play();
  }
  started = true;
}

void draw() {
  background(0);

  fft.analyze(spectrum);   // fills the array with values from 0 to 1

  // normalise by hand: follow the loudest bin and let it decay slowly,
  // so quiet passages still show
  float frameMax = 0;
  for (int i = 0; i < spectrum.length; i++) frameMax = max(frameMax, spectrum[i]);
  peak = max(max(peak * 0.998, frameMax), 0.0001);

  GRID = buildGrid(spectrum);
  for (int row = 0; row < ROWS; row++) {
    for (int col = 0; col < COLS; col++) {
      colors[row][col] = palette(GRID[row].charAt(col));
    }
  }

  // centre the grid on the canvas
  float ox = (width - COLS * SPACING) / 2.0 + SPACING / 2.0;
  float oy = (height - ROWS * SPACING) / 2.0 + SPACING / 2.0;

  for (int row = 0; row < ROWS; row++) {
    for (int col = 0; col < COLS; col++) {
      fill(colors[row][col]);
      ellipse(ox + col * SPACING, oy + row * SPACING, DIAMETER, DIAMETER);
    }
  }

  if (!started) {
    fill(255);
    textAlign(CENTER, CENTER);
    text("click to play / pause", width / 2, height - 20);
  }
}

// Turn the spectrum into the letter grid.
String[] buildGrid(float[] spectrum) {
  String[] grid = new String[ROWS];

  for (int row = 0; row < ROWS; row++) {
    String line = "";
    for (int col = 0; col < COLS; col++) {
      // position of this dot from -1 to 1, with (0, 0) at the centre
      float x = (col + 0.5) / COLS * 2 - 1;
      float y = (row + 0.5) / ROWS * 2 - 1;
      float r = sqrt(x * x + y * y);

      // angle around the centre, mirrored top/bottom so there is no seam: 0 to 1
      float a = abs(atan2(y, x)) / PI;

      // 1. loudness of this dot's frequency bin, 0 to 1
      int bin = min(USEFUL_BINS - 1, floor(a * USEFUL_BINS));
      float amp = constrain(spectrum[bin] / peak, 0, 1);

      // 2. the sphere's edge pulses with the loudness
      if (r > 0.7 + amp * 0.3) {
        line += 'k';
        continue;
      }

      // 3. loudness picks the letter: quiet = dark/cool colours, loud = white
      line += RAMP.charAt(floor(amp * (RAMP.length() - 1)));
    }
    grid[row] = line;
  }
  return grid;
}
