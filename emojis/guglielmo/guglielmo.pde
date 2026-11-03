int clickCounter = 0;
float headX;
float headY;
float eye1X;
float eye1Y;
float eye2X;
float eye2Y;
float mouthX;
float mouthY;
float noseX;
float noseY;
float eyebrowX;
float eyebrowY;
float eyebrow2X;
float eyebrow2Y;
float beardX;
float beardY;

// PVector

color face_color = color(25,29,200);
// fill(face_color)



void setup() {
  pixelDensity(2);
  size(600, 400);
  noStroke();
  rectMode(CENTER);
  println("setup done");
}


void draw() {
  background(255);


  // head preview
  if (clickCounter == 0) {
    fill(227, 197, 197, 120);
    rect(mouseX, mouseY, 130, 200, 100);
  }

  // placed head
  if (clickCounter >= 1) {
    fill(227, 197, 197);
    rect(headX, headY, 130, 200, 100);
  }

  //eye preview
  if (clickCounter == 1 || clickCounter == 2) {
    fill(114, 145, 255);
    circle(mouseX, mouseY, 20);
    fill(255);
    circle(mouseX, mouseY, 10);
  }
  //placed eye1
  if (clickCounter >= 2) {
    fill(114, 145, 255);
    circle(eye1X, eye1Y, 20);
    fill(255);
    circle(eye1X, eye1Y, 10);
  }

  //placed eye2
  if (clickCounter >= 3) {
    fill(114, 145, 255);
    circle(eye2X, eye2Y, 20);
      fill(255);
    circle(eye2X, eye2Y, 10);
  }


  //mouth preview
  if (clickCounter == 3) {
    fill(114, 145, 255);
    rect(mouseX, mouseY, 70, 20, 30);
  }

  //placed mouth
  if (clickCounter >= 4) {
    fill(114, 145, 255);
    rect(mouthX, mouthY, 70, 20, 30);
  }


  //nose preview
  if (clickCounter == 4) {
    fill(114, 145, 255);
    beginShape();
    vertex(mouseX + 0, mouseY -20);
    vertex(mouseX - 10, mouseY + 40);
    vertex(mouseX + 10, mouseY + 40);
    endShape();
  }
  //placed nose
  if (clickCounter >= 5) {
    fill(114, 145, 255);
    beginShape();
    vertex(noseX + 0, noseY -20);
    vertex(noseX - 10, noseY + 40);
    vertex(noseX + 10, noseY + 40);
    endShape();
  }


  //eyebrow1 preview
  if (clickCounter == 5 || clickCounter == 6) {
    fill(114, 145, 255);
    rect(mouseX, mouseY, 50, 10, 30);
  }
  //placed eyebrow1
  if (clickCounter >= 6) {
    fill(114, 145, 255);
    rect(eyebrowX, eyebrowY, 50, 10, 30);
  }

  if (clickCounter >= 7) {
    fill(114, 145, 255);
    rect(eyebrow2X, eyebrow2Y, 50, 10, 30);
  }
  
  //beard preview
  if (clickCounter == 7) {
    fill(90, 60, 40);
    beginShape();
    vertex(mouseX - 50, mouseY - 20);
    vertex(mouseX - 40, mouseY + 30);
    vertex(mouseX - 20, mouseY + 20);
    vertex(mouseX + 0,  mouseY + 50);
    vertex(mouseX + 20, mouseY + 20);
    vertex(mouseX + 40, mouseY + 30);
    vertex(mouseX + 50, mouseY - 20);
    endShape(CLOSE);
  }
  //placed beard
  if (clickCounter >= 8) {
    fill(90, 60, 40);
    beginShape();
    vertex(beardX - 50, beardY - 20);
    vertex(beardX - 40, beardY + 30);
    vertex(beardX - 20, beardY + 20);
    vertex(beardX + 0,  beardY + 50);
    vertex(beardX + 20, beardY + 20);
    vertex(beardX + 40, beardY + 30);
    vertex(beardX + 50, beardY - 20);
    endShape(CLOSE);
  }
  
  
  
  
}



void mousePressed() {
  clickCounter = clickCounter+1;
  if (clickCounter == 1) {
    headX = mouseX;
    headY = mouseY;
  }
  if (clickCounter == 2) {
    eye1X = mouseX;
    eye1Y = mouseY;
  }
  if (clickCounter == 3) {
    eye2X = mouseX;
    eye2Y = mouseY;
  }
  if (clickCounter == 4) {
    mouthX = mouseX;
    mouthY = mouseY;
  }
  if (clickCounter == 5) {
    noseX = mouseX;
    noseY = mouseY;
  }
  if (clickCounter == 6) {
    eyebrowX = mouseX;
    eyebrowY = mouseY;
  }
  if (clickCounter == 7) {
    eyebrow2X = mouseX;
    eyebrow2Y = mouseY;
  }
  
   if (clickCounter == 8) {
    beardX = mouseX;
    beardY = mouseY;
  }
}

void keyPressed(){
saveFrame("GuglielmoFace-####.png");
}

