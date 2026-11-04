float ten=10;
float r=100;
float eyeA=30;
float eyeB=15;
int hueValue=0;

void setup() {
  size(1024, 768);
  colorMode(HSB, 360, 100, 100); // Max Hue=360, Sat=100, Bright=100
  translate(width*0.5, height*0.5);
}

void draw() {
  background(0);
  noStroke();
  fill(hueValue, 100, 100);
  pushMatrix();
  translate(width*0.5, height*0.5);
  rotate(mouseX / 400.0);
  fill(64, 32, 84);
  noStroke();
  beginShape();
  curveVertex(-r, 0);
  curveVertex(0, -r);  // Top
  curveVertex(r, 0);   // Right
  curveVertex(0, r);   // Bottom
  curveVertex(-r, 0);  // Left
  curveVertex(0, -r);  // Target back to Top
  curveVertex(r, 0);   // Exit control point (Right)
  endShape(CLOSE);
  noFill();
  popMatrix();

  pushMatrix();
  translate(width*0.5, height*0.5);
  rotate(-mouseX / 2000.0);
  fill(57, 66, 85);
  eye(-30, -50, 4*eyeA);
  fill(57, 72, 93);
  eye(30, -50, 4*eyeB);
  popMatrix();

  pushMatrix();
  translate(width*0.5, height*0.5);
  tongue();
  popMatrix();

  hueValue = (hueValue + 1) % 360; // Cycle from 0 to 359
}

void eye(float posX, float posY, float eyeM) {
  rectMode(CENTER);
  noStroke();
  circle(posX, posY, eyeM);
  stroke(360, 80, 90);   // Dark Blue outline (Same Hue, lower Brightness)
  strokeWeight(4);
  fill(57, 20, 2);
  noStroke();
  rect(posX+(mouseY-height/2)/20, posY+(mouseY-height/2)/20, eyeA, eyeB, 30);
  noFill();
}

void tongue()
{
  stroke(360, 80, 90);   // Dark Blue outline (Same Hue, lower Brightness)
  strokeWeight(4);
  beginShape();
  vertex(0, 60);
  fill(360, 80, 90);
  bezierVertex(-mouseX/10, mouseY/5, 80+mouseX/10, mouseY/5, 20, 50);
  bezierVertex(0, 60, 0, 60, 0, 60);
  endShape();


  stroke(57, 57, 66);   // Dark Blue outline (Same Hue, lower Brightness)
  strokeWeight(10);
  noFill();
  beginShape();
  vertex(-40, 30);
  bezierVertex(10, 60, 10, 60, 30, 40);
  endShape();
}

void mouseClicked() {
  r = random(80, 200);
  eyeA=random(40);
  eyeB=random(25);
  println(mouseY);
}