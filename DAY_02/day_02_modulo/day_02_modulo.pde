int rectSize = 50;
float xPadding = 1.5;
float yPadding = 1.5;

void setup() {
  size(600, 400);
  background(255);
  //noStroke();
  //blendMode(DARKEST);
  
}

void draw() {
  //background(0);
  noStroke();
  fill(255,100);
  rect(0,0,width,height);
  
  noFill();
  strokeWeight(4);

  xPadding = map(mouseX, 0, width, 0, 2);
  yPadding = map(mouseY, 0, height, 0, 2);

  for (int row = 0; row < 4; row++) {
    for (int column = 0; column < 6; column++) {
      if (row%2 == 0) { // == asking if it's equal / != asking if it's different
        if (column%3 == 0) {
          stroke(255, 0, 0);
        } else if (column%3 == 1) {
          stroke(0, 255, 0);
        } else {
          stroke(0, 0, 255);
        }
      } else {
        if (column%2 == 1) {
          stroke(255, 0, 0);
        } else {
          stroke(0, 0, 255);
        }
      }
      rect(column*rectSize*xPadding + 50, row*rectSize*yPadding + 50, rectSize, rectSize);
    }
  }

  //for(int posX = 100; posX < width; posX+=100){ //posX+=65 --> posX = posX+65
  //  fill(0,255,0);
  //  rect(posX, 100, rectSize, rectSize);
  //}
}
