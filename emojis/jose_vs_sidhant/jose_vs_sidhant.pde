int eyesOffsetX, eyesOffsetY, eyeSquint=0;
color facecolor = #EAD095;
boolean moustachePulledLeft, moustachePulledRight = false;
void setup() {
  size(300, 320);
}

void draw() {
  background(#F9F9F9);

  //hat
  fill(0);
  noStroke();
  rect(100, 100, 100, 50, 8, 8, 0, 0);

  //face
  noStroke();
  fill(facecolor);
  rect(100, 150, 100, 75, 0, 0, 17, 17);


  stroke(0);
  strokeWeight(7);
  strokeCap(SQUARE);
  line(80, 150, 220, 150);


  strokeWeight(10);
  stroke(155);
  strokeCap(SQUARE);
  line(100, 141, 200, 141);


  //eyes
  //150,177
  eyesOffsetX = int(map(mouseX, 0, width, -8, 8));
  eyesOffsetY = int(map(mouseY, 0, height, -8, 8));
  fill(#000000);
  noStroke();
  ellipse(126+eyesOffsetX, 177+eyesOffsetY, 17, 17-eyeSquint);
  ellipse(174+eyesOffsetX, 177+eyesOffsetY, 17, 17-eyeSquint);

  fill(255);
  rect(137, 195, 23, 10, 17, 17, 17, 17);

  //moustache
  fill(#090909);
  if (!moustachePulledLeft) {
    noStroke();
    rect(125, 190, 23, 10, 17, 0, 17, 0);
    
  } else {
    stroke(0);
    strokeWeight(10);
    strokeCap(ROUND);
    line(mouseX,mouseY,145,195);
  }
  
  if(!moustachePulledRight){
    noStroke();
    rect(150, 190, 23, 10, 0, 17, 0, 17);
  } else {
    stroke(0);
    strokeWeight(10);
    strokeCap(ROUND);
    line(mouseX,mouseY,155,195);
  }


  //glasses
  fill(#FFFFFF, 70);
  strokeWeight(2);
  stroke(0);
  circle(126, 177, 34);
  circle(174, 177, 34);
  line(142, 177, 158, 177);


  //goatee
  fill(0);
  rect(140, 220, 18, 15, 2, 2, 7, 7);
}

void mousePressed() {
  if (mouseX>100 && mouseX<200 && mouseY>100 && mouseY<150 && eyeSquint<13) {
    eyeSquint = eyeSquint + 7;
    if (eyeSquint>10)
      facecolor= #E8AD96;
  } else if (moustachePulledLeft || moustachePulledRight){
    moustachePulledLeft= false;
    moustachePulledRight= false;
  }
}

void mouseDragged() {

  if (mouseX>140 && mouseX<158 && mouseY>220 && mouseY<235 && eyeSquint>0) {
    eyeSquint = eyeSquint - 7;
    facecolor= #EAD095;
  }
  
  if (mouseX>125 && mouseX<148 && mouseY>190 && mouseY<200 && !moustachePulledLeft && !moustachePulledRight) {
    moustachePulledLeft = !moustachePulledLeft;
  }
  
  if (mouseX>150 && mouseX<173 && mouseY>190 && mouseY<200 && !moustachePulledLeft && !moustachePulledRight) {
    moustachePulledRight = !moustachePulledRight;
  }
}


