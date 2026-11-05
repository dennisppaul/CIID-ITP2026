String[] fontFileNames = {
  "Queensides-48.vlw",
  "SFPro-CompressedRegular-50.vlw",
  "Vonique64-Bold-70.vlw",
  "Wingdings3-70.vlw",
  "Wingdings2-70.vlw",
  "Sarabun-LightItalic-70.vlw"
};

color[] colorList = {
  #F9DA3F,
  #2A6678,
  #FFA400,
  #BBDB3B,
  #FF4ACF,
  #F47B5E,
  #B3FFFF,
  #2EA1C2,
  #D9D9D9,
  #6694F5,
  #642200,
  #FF97C7,
  #BF8AE4,
  #DE1D58,
  #E2FF57,
  #98D1FF,
  #01B53D,
  #A31D98,
  #B28D3D,
  #FFB6F4
};

color[] palette = new color[10];
char[] letters = new char[10];
float[] phase = new float[10];
//float[] wiggleSpeeds = new float[10];

PFont[] loadedFonts;
PFont[] letterFonts = new PFont[10];

float wiggleHeight = 5;
float wiggleTilt = 0.2;
float wiggleSpeed = 0.09;

void setup() {
  size(600, 200);
  pixelDensity(2);

  loadedFonts = new PFont[fontFileNames.length];
  for (int i = 0; i < fontFileNames.length; i++) {
    loadedFonts[i] = loadFont(fontFileNames[i]);
  }


  shuffleLetters();
  shuffleFont();
  shuffleColors();
}

void draw() {
  background(255);
  fill(0);
  textAlign(CENTER, CENTER);
  //frameRate(20);

  for (int i = 0; i < letters.length; i++) {
    float t = frameCount * wiggleSpeed + phase[i];

    pushMatrix();
    translate(50 + i * 55, 100 + cos(t) * wiggleHeight);
    rotate(sin(t * 0.7) * wiggleTilt);

    // 3. Use the actual PFont object stored in letterFonts[i]
    textFont(letterFonts[i]);

    textSize(100);
    fill(palette[i]);
    text(letters[i], 0, 0);
    popMatrix();
  }
}

void mousePressed() {
  shuffleLetters();
  shuffleFont();
  shuffleColors();
}

void shuffleLetters() {
  for (int i = 0; i < letters.length; i++) {
    letters[i] = char('A' + int(random(60)));
    phase[i] = random(PI);
  }
}

void shuffleFont() {
  for (int i = 0; i < letters.length; i++) {

    int index = int(random(loadedFonts.length));
    //assign
    letterFonts[i] = loadedFonts[index];
  }
}

void shuffleColors() {
  for (int i = 0; i < palette.length; i++) {
    int index = int(random(colorList.length));
    palette[i] = colorList[index];
  }
}

void shuffleFrameRate() {
  wiggleSpeed = random(0.03, 0.2);
}
  
