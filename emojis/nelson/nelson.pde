final float[] pupilPositionsX = new float[2];
final float[] eyePositionsXY = new float[2];
final float EIGHTH_PI = PI / 8;
float pupilPositionsY;
float eyeWidth;
float eyeHeight;
float eyeSpacing;
float pupilRadius;
float pupilSize;
float eyeStrokeWeight;
float eyebrowStrokeWeight;

void setup() {
  fullScreen();

  eyeWidth = width / 5;
  eyeHeight = eyeWidth / 1.8;
  eyeSpacing = eyeWidth * 1.75;
  pupilRadius = eyeWidth / 3;
  eyeStrokeWeight = eyeWidth / 8;
  eyebrowStrokeWeight = eyeStrokeWeight * 2;

  eyePositionsXY[0] = width / 2 - (eyeSpacing / 2);
  eyePositionsXY[1] = height / 2 + (eyeHeight / 2);

  pupilPositionsX[0] = eyePositionsXY[0];
  pupilPositionsX[1] = eyePositionsXY[1];
  pupilPositionsY = eyePositionsXY[1];
}

void draw() {
  background(255);
  drawEyebrows();
  drawEyes();
  moveEyes();

  fill(255, 0, 0);
  circle(mouseX, mouseY, 20);
}

void drawEyes() {
  stroke(0);
  strokeWeight(eyeStrokeWeight);
  noFill();
  arc(eyePositionsXY[0], eyePositionsXY[1], eyeWidth, eyeHeight, PI * 1.1, PI * 2);
  arc(eyePositionsXY[0] + eyeSpacing, eyePositionsXY[1], eyeWidth, eyeHeight, PI, PI * 1.9);

  fill(0);
  noStroke();
  arc(pupilPositionsX[0], pupilPositionsY, pupilRadius, pupilRadius * 1.25, EIGHTH_PI, TAU, PIE);
  arc(pupilPositionsX[1], pupilPositionsY, pupilRadius, pupilRadius * 1.25, EIGHTH_PI, TAU, PIE);
}

void moveEyes() {
  float normX = map(mouseX, 0, width, -1, 1);
  float normY = map(mouseY, 0, height, -1, 3);

  pupilPositionsX[0] = eyePositionsXY[0] + normX * (eyeWidth - pupilRadius * 2);
  pupilPositionsX[1] = eyePositionsXY[0] + eyeSpacing + normX * (eyeWidth - pupilRadius * 2);
  pupilPositionsY = eyePositionsXY[1] + normY * (eyeHeight - pupilRadius * 1.5);
}

void drawEyebrows() {
  float normY = map(mouseY, 0, height, -1, 0);

  stroke(0);
  strokeWeight(eyebrowStrokeWeight);
  noFill();

  beginShape();
  vertex(eyePositionsXY[0] - eyeWidth / 2, eyePositionsXY[1] - eyeHeight * 1.5);
  vertex(eyePositionsXY[0], eyePositionsXY[1] - eyeHeight * 1.25 + normY * eyeHeight * 0.25);
  vertex(eyePositionsXY[0] + eyeWidth / 2, eyePositionsXY[1] - eyeHeight);
  endShape();

  beginShape();
  vertex(eyePositionsXY[0] + eyeSpacing - eyeWidth / 2, eyePositionsXY[1] - eyeHeight);
  vertex(eyePositionsXY[0] + eyeSpacing, eyePositionsXY[1] - eyeHeight * 1.25 + normY * eyeHeight * 0.25);
  vertex(eyePositionsXY[0] + eyeSpacing + eyeWidth / 2, eyePositionsXY[1] - eyeHeight * 1.5);
  endShape();
}
