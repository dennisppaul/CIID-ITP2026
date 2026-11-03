void setup() {
  size(600, 600);
}

void draw() {
  background(100);

  //body
  noStroke();
  fill(0);
  circle(300, 510, 400);
  circle(300, 610, 450);

  //pen
  noFill();
  stroke(#E912AC);
  strokeWeight(12);
  line(217, 570, 297, 534);

  //arm
  noStroke();
  fill(#39C2DB);
  circle(200, 580, 100);
  circle(220, 550, 50);

  //head
  noStroke();
  fill(#39C2DB);
  circle(height/2, width/2, 300);
  circle(150, 300, 150);
  circle(450, 300, 150);

  //eye
  float posX = map(mouseX, 0, width, -13, 13);
  float posY = map(mouseY, 0, width, -13, 13);

  noStroke();
  fill(255);
  circle(350, 280, 100);
  rect(190, 250, 100, 60, 10, 10, 10, 10);
  fill(0);
  rect(200+posX, 270+posY, 50, 20, 10, 10, 10, 10);
  rect(325+posX, 270+posY, 50, 20, 10, 10, 10, 10);

  //mouth
  noFill();
  stroke(0);
  strokeWeight(8);
  arc(220, 390, 50, 50, PI + HALF_PI, TWO_PI);

  //hair/hat
  noStroke();
  fill(0);
  triangle(206, 182, 300, 49, 395, 183);
  println(mouseX, mouseY);

  noStroke();
  fill(255);
  circle(190, 170, 50);
  circle(230, 170, 50);
  circle(220, 190, 50);
  circle(260, 190, 50);
  circle(300, 190, 50);
  circle(340, 190, 50);
  circle(380, 190, 50);
  circle(410, 170, 50);
  circle(370, 170, 50);
  circle(300, 55, 25);

  //bow
  fill(100);
  circle(300, 450, 25);

  triangle(250, 470, 250, 420, 300, 450);
  triangle(350, 470, 350, 420, 300, 450);
  endShape();

  //ear
  noFill();
  stroke(#3CA6B9);
  strokeWeight(8);
  arc(140, 300, 70, 70, 3, PI+QUARTER_PI, OPEN);
  arc(470, 300, 70, 70, 3, PI+QUARTER_PI, OPEN);

  //clip
  noFill();
  stroke(#E912AC);
  strokeWeight(8);
  line(217, 176, 227, 186);
  stroke(#5ECF03);
  line(260, 187, 275, 190);
  stroke(#F7E303);
  line(344, 193, 356, 183);
  stroke(#1699F6);
  line(409, 160, 410, 173);

  if (mousePressed == true) {
    fill(#39C2DB);
    noStroke();
    circle(230, 380, 55);
    noFill();
    stroke(0);
    strokeWeight(8);
    arc(250, 360, 50, 40, HALF_PI, PI);
    noFill();
    stroke(#FFEC17);
    strokeWeight(3);
    line(313, 508, 342, 525);
    line(319, 533, 334, 500);
    line(310, 520, 345, 510);
    line(332, 539, 321, 497);
  } else {
    noFill();
    stroke(0);
    strokeWeight(8);
    arc(220, 390, 50, 50, PI + HALF_PI, TWO_PI);
  }
}
void keyPressed() {
  saveFrame();
}
