void setup() {
  size(800, 800);
}

int eyeXOffset, eyeYOffset =0;

void draw() {
  background(178, 255, 250);

  fill(245, 157, 89);
  circle(width/2, height/2, 220);

  //left eye
  // eyeball white
  fill(255);
  circle(width/2 - 50, height/2, 60);

  //dark brown colour of eye
  fill(80, 50, 20);
  circle(width/2 - 50, height/2, 40);

  // black pupil, smallest
  eyeXOffset=int(map(mouseX,0,width,-8,8));
  fill(0);
  circle(width/2 - 50+eyeXOffset, height/2+eyeYOffset, 16);

  //right eye white eyeball
  //eyeXOffset=int(map(mouseX,0,width,-8,8));
  fill(255);
  circle(width/2 + 50, height/2, 60);
  //circle(width/2 + 50+eyeXOffset, height/2+eyeYOffset, 60);

  fill(80, 50, 20); //brown eye colour
  circle(width/2 + 50, height/2, 40);

  eyeXOffset=int(map(mouseX,0,width,8,-8));
  fill(0); //black pupil
  circle(width/2 + 50-eyeXOffset, height/2-eyeXOffset, 16);

  // mouth
  fill(204, 102, 102);
  noStroke();

  beginShape();
  vertex(width/2 - 40, height/2 + 40);
  bezierVertex(width/2, height/2 + 110,
    width/2, height/2 + 110,
    width/2 + 40, height/2 + 40);
  bezierVertex(width/2, height/2 + 70,
    width/2, height/2 + 70,
    width/2 - 40, height/2 + 40);
  endShape();
  //curly hair
  fill(85, 24, 12);

  circle(width/2 - 90, height/2 - 90, 70);
  circle(width/2 - 50, height/2 - 130, 70);
  circle(width/2, height/2 - 130, 70);
  circle(width/2 + 60, height/2 - 110, 70);
  circle(width/2 + 100, height/2 - 90, 70);


  //bangs
  beginShape();
  vertex(width/2 - 80, height/2 - 50);

  bezierVertex(width/2 - 60, height/2 - 20,
    width/2 - 20, height/2 - 20,
    width/2, height/2 - 60);

  bezierVertex(width/2 + 20, height/2 - 20,
    width/2 + 60, height/2 - 20,
    width/2 + 90, height/2 - 60);

  vertex(width/2 + 90, height/2 - 110);
  vertex(width/2 - 90, height/2 - 110);

  endShape(CLOSE);
}
void keyPressed(){
saveFrame();
}