
void setup() {
  size(1024, 768);
  smooth();
}

void draw() {
  background(170, 190, 150);

  stroke(25, 20, 20);
  strokeWeight(4);
  fill(190, 125, 85);

  // Ears
  circle(365, 400, 55);
  circle(659, 400, 55);

  // Face
  ellipse(512, 390, 300, 370);
  
  
// Hair
  fill(35, 28, 28);
  stroke(25);
  strokeWeight(3);

  beginShape();

  // Mapped Dots
  curveVertex(664, 373);
  curveVertex(664, 373);
  curveVertex(671, 368);
  curveVertex(680, 361);
  curveVertex(682, 347);
  curveVertex(688, 330);
  curveVertex(684, 296);
  curveVertex(680, 261);
  curveVertex(678, 239);
  curveVertex(674, 215);
  curveVertex(671, 202);
  curveVertex(650, 202);
  curveVertex(633, 176);
  curveVertex(603, 158);
  curveVertex(584, 144);
  curveVertex(556, 133);
  curveVertex(506, 134);
  curveVertex(459, 140);
  curveVertex(405, 154);
  curveVertex(383, 177);
  curveVertex(360, 188);
  curveVertex(336, 198);
  curveVertex(336, 222);
  curveVertex(336, 252);
  curveVertex(345, 268);
  curveVertex(343, 285);
  curveVertex(348, 318);
  curveVertex(347, 351);
  curveVertex(356, 367);
  curveVertex(364, 379);
  curveVertex(371, 373);
  curveVertex(375, 357);
  curveVertex(384, 327);
  curveVertex(387, 303);
  curveVertex(404, 292);
  curveVertex(418, 285);
  curveVertex(460, 270);
  curveVertex(486, 270);
  curveVertex(541, 264);
  curveVertex(578, 253);
  curveVertex(596, 279);
  curveVertex(596, 319);
  curveVertex(608, 332);
  curveVertex(632, 364);
  curveVertex(646, 371);
  curveVertex(657, 375);

  // Close the curve smoothly
  curveVertex(664, 373);
  curveVertex(664, 373);

  endShape(CLOSE);

  // Eyes
  stroke(25, 20, 20);
  strokeWeight(4);
  fill(255);

  // White circles
  ellipse(445, 390, 90, 100);
  ellipse(580, 390, 90, 100);

 // Mouse movement for pupils
  float eyeX = map(mouseX, 0, 1024, -30, 15);
  float eyeY = map(mouseY, 0, 768, -20, 15);
  
  // dots
  noStroke();
  fill(25, 20, 20);
  circle(445 + eyeX, 390 + eyeY, 12);
  circle(580 + eyeX, 390 + eyeY, 12);
  
  // Nose
  noFill();
  stroke(25, 20, 20);
  strokeWeight(4);

  line(512, 420, 505, 455);
  line(505, 455, 520, 460);

  // Mouth
  noFill();
  stroke(25, 20, 20);
  strokeWeight(5);

  arc(512, 495, 100, 35, 0, PI);

}
void keyPressed(){
saveFrame();
}