PFont font;

float[] x = new float[10];
float[] y = new float[10];

int mode = 1;

Float pulse; //for triangle

String[] words = {
  "ENTER",
  "RAVE",
  "NIGHT",
  "DANCE",
  "NOISE",
  "EXIT",
  "METRO",
  "NEVER",
  "GIRLS",
  "BOYS",
  "EVERYONE"
};

final boolean PERFORMANCE_MODE = true;

void settings() {
  if (!PERFORMANCE_MODE) {
    // size(1280,720);   // 720p
    size(1920, 1080); // 1080p
  } else {
    fullScreen();
  }
}

void setup() {
  println("size: " + width + ", " + height);

  //size(1000, 1000);
  noCursor();
  noStroke();

  background(0);

  colorMode(HSB, 360, 100, 100, 255);

  font = createFont("Retro Blendy.otf", 60);
  textFont(font);
  textAlign(CENTER);

  for (int i = 0; i < 10; i++) {
    x[i] = random(width/2);
    y[i] = random(height/2);
  }
}

void draw() {

  switch(mode) {

  case 1:
    randomWalkMode();
    break;

  case 2:
    gaussianMode();
    break;

    //case 3:
    // triangleMode();
    //break;
  }

  fill(frameCount % 360, 100, 100);
  textSize(60);
  text("Copenhagen Underground", width/2, 100);
}

void randomWalkMode() {

  for (int i = 0; i < 10; i++) {

    stroke(random(360), 100, 100);
    strokeWeight(random(1, 10));

    float nextX = x[i] + random(-20, 20);
    float nextY = y[i] + random(-20, 20);

    line(x[i], y[i], nextX, nextY);

    x[i] = nextX;
    y[i] = nextY;

    //if (random(1) < 0.002) {
    //stroke(0);
    //strokeWeight(2);
    //fill(280 + sin(frameCount *0.05) * 40, 100, 100);
    //textSize(25);
    //text(words[int(random(words.length))], nextX, nextY);


    if (random(1) < 0.005) {
      fill(frameCount % 360, 100, 100);
      textSize(25);
      text(words[int(random(words.length))], nextX, nextY);
    }
  }
}

void gaussianMode() {

  float val = randomGaussian();

  float sd = 80;
  float mean = width/2;

  float xpos = (val * sd) + mean;
  float ypos = height/2 + randomGaussian() * sd;

  noStroke();
  fill(random(360), 100, 100);
  ellipse(xpos, ypos, 20, 20);

  // Optional rave words
  if (random(1) < 0.01) {
    //fill(frameCount % 360, 100, 100);
    //textSize(20);
    //text(words[int(random(words.length))], xpos, ypos);
  }

  // ==========================
  // RAVE TRIANGLE TUNNEL
  // ==========================

  pushMatrix();

  translate(width/2, height/2);

  float pulse = sin(frameCount * 0.05);

  float baseSize = 250 + pulse * 50;

  for (int t = 0; t < 3; t++) {

    pushMatrix();

    rotate(frameCount * 0.005 + t * TWO_PI/3);

    float hue = (frameCount * 2 + t * 120) % 360;

    // Glow layers
    for (int i = 6; i > 0; i--) {

      noFill();
      stroke(hue, 100, 100, 20);
      strokeWeight(i * 2);

      float s = baseSize + i * 15;

      triangle(
        0, -s/2,
        -s/2, s/2,
        s/2, s/2
        );
    }

    // Bright outline
    noFill();
    stroke(hue, 100, 100);
    strokeWeight(3);

    triangle(
      0, -baseSize/2,
      -baseSize/2, baseSize/2,
      baseSize/2, baseSize/2
      );

    popMatrix();
  }

  popMatrix();
}

void colorMode() {

  float hue = map(
    sin(frameCount * 0.01),
    -1, 1,
    290, 350
    );

  background(hue, 90, 15);
}


void keyPressed() {

  switch(key) {

  case '1':
    mode = 1;
    background(0);
    break;

  case '2':
    mode = 2;
    background(0);
    break;

  case '3':
    mode = 3;
    colorMode();
    break;
  }
}
