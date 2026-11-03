import processing.sound.*;

AudioIn in;
Amplitude amp;

//The aspect ratio needs to be 1:1

void setup() {
  in = new AudioIn(this, 0);
  amp = new Amplitude(this);
  
  //fullScreen();
  size(1000,1000);
  rectMode(CENTER);
  background(255,0,0);
  
  cursor(CROSS);
  
  in.start();
  amp.input(in);
  
}

void draw() {
  background(255,0,0);
  drawHead();
  drawBeard();
  
  drawNose();
  //drawBeanie();
  drawCap();
  drawEyes();
  drawGlasses();
  drawMouth();
  drawEarrings();
  
}

void drawEyes() {
  strokeWeight(4);
  stroke(0);
  
  float posX = map(mouseX, 0, width, -width/10 , width/10); 
  float posY = map(mouseY, 0, height, -height/10, height/10);
  fill(255);
  circle(width/3, height/2, width/4);
  circle(2*width/3, height/2, width/4);
  fill(0);
  circle(width/3 + posX, height/2 + posY, width/8);
  circle(2*width/3 + posX, height/2 + posY, width/8);
  
  if(mousePressed) {
    fill(#953636);
    circle(width/3, height/2, width/4);
    circle(2*width/3, height/2, width/4);
    line(width/3 - width/8, height/2, width/3 + width/8, height/2);
    line(2*width/3 - width/8, height/2, 2*width/3 + width/8, height/2);
  }
}

void drawHead() {
  stroke(0);
  strokeWeight(4);
  fill(#953636);
  rect(width/2, height/2, width/3, height/3, width/30);
  arc(width/2, height/2, width/3, height/2, 0, PI);
}

void drawBeanie() {
  stroke(0);
  strokeWeight(4);
  fill(255);
  triangle(10 + width/3, height/3, 2*width/3 - width/60, height/3, width/2, height/8);
  //rect(width/2, height/3, width/3 + 20, 40, 10); 
  beginShape();
  vertex(width/3, height/3);
  bezierVertex(width/2, 0, width/2, 0, 2*width/3, height/3);
  endShape();
  for(int i = width/3; i < 2*width/3 + 10; i += 10){
    rect(i, height/3, 10, 40, 5  );
  }
  circle(width/2, height/12, width/10);
}

void drawGlasses() {
  noFill();
  strokeWeight(10);
  stroke(0);
  rect(width/3, height/2, width/4, height/6, width/30);  //left
  rect(2*width/3, height/2, width/4, height/6, width/30); //right
  line(width/2 - width/25, height/2 - height/30, width/2 + width/25, height/2 - height/30); //bridge
}

void drawMouth() {
  fill(255);
  float mouthMove = map(amp.analyze(), 0, 1, 0, 200);
  arc(width/2, height/2 + height/8 + random(mouthMove), width/6, height/10, 0, PI, CHORD);
}

void drawCap() {
  
  strokeWeight(4);
  stroke(0);
  
  fill(255);
  rect(2 * width/3, height/3, width/3, 10, 5); //cap rim
  
  fill(255,0,0);
  arc(width/2, height/3 + height/30, width/3 + width/30, width/3, PI, TWO_PI, CHORD); //outer half ellipse
  fill(255,255,0);
  arc(width/2, height/3 + height/30, width/4, width/3, PI, TWO_PI,CHORD); //middle half ellipse
  fill(255,0,255);
  arc(width/2, height/3 + height/30, width/8, width/3, PI, TWO_PI, CHORD); //inner half ellipse
  fill(0);
  arc(width/2, height/3, width/10, width/10, PI, TWO_PI, CHORD); //lil half ellipse

}

void drawNose() {
  fill(#953636);
  strokeWeight(4);
  stroke(0);
  arc(width/2, height/2 + height/30, width/20, width/20, 0 - PI/8, PI + PI/8);
}

void drawBeard() {
  fill(0,200);
  noStroke();
  arc(width/2, height/2 + height/30, width/3, height/2, radians(15), PI - radians(15));
}

void drawEarrings() {
  noFill();
  strokeWeight(4);
  stroke(255);
  arc(width/3 + width/120, 2*height/3 - height/120, 20, 20, 0 + radians(30), PI + PI/2);  //left
  arc(2*width/3 - width/120, 2*height/3 - height/120, 20, 20, 0 - PI/2, PI - radians(30));  //right

}

void keyPressed() {
  if (keyCode == ENTER) {
    saveFrame();
  }
}