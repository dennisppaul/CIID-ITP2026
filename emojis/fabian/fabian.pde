float positionX;
float positionY;
float scaleFactor = 1.0f;
float rectangleSize;
void setup() {
  size(500, 500);
  positionX = width / 2;
  positionY = height / 2;
  scaleFactor = mouseX / 5;
  rectangleSize = 100 + scaleFactor;
  rectMode(CENTER);
}
void draw() {
  drawHead();
  drawEyes();
  drawMouth();
  drawHair();
}

void drawHair() {

  fill(0, 150, 20);
  noStroke();
  rect(positionX, positionY - 70, 50, 100, 30);

  fill(150, 175, 0);
  noStroke();
  rect(positionX + 60, positionY + 28, 20, 20, 5);

  fill(150, 175, 0);
  noStroke();
  rect(positionX - 60, positionY + 28, 20, 20, 5);
}

void drawMouth() {

  noFill();
  strokeWeight(8);
  stroke(0);
  strokeCap(ROUND);
  arc(positionX, height/2, 40, 40, 0, PI, OPEN);
}

void drawHead() {

  fill (234, 12, 71); //Red
  noStroke();
  rect(positionX, positionY, rectangleSize, rectangleSize, rectangleSize/4);
  fill (234, 12, 71);
  circle(200, positionY, 50);
  circle(300, positionY, 50);
}


void drawEyes() {

  float eyePosition = 200;

  fill(255, 255, 255);
  strokeWeight(10);
  stroke(0);
  circle(eyePosition, positionY, 25);

  fill(255, 255, 255);
  strokeWeight(10);
  stroke(0);
  circle(eyePosition + 100, positionY, 25);

  fill(0, 120, 10);
  noStroke();
  rect(positionX + 30, positionY - 55, 50, 70, 30);

  fill(0, 120, 10);
  noStroke();
  rect(positionX - 30, positionY - 55, 50, 70, 30);
}

void keyPressed(){
saveFrame();
}
