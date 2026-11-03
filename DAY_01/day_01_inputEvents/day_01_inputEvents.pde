int posX = 0;
int posY = 0;

int rectSize = 50;

int grayTone = 255;

boolean isStarted = false;

void setup(){
  size(800,400);
  rectMode(CENTER);
  background(255,0,0);
  
  noStroke();
}

void draw(){
  println(rectSize);
  if (isStarted == true){ //if this statement is true
    //do something
    fill(grayTone,5); // fill(255,255,255);
    rect(posX, posY, rectSize,rectSize);
  }
  
  
}

void mousePressed(){
  isStarted = true;
  
  rectSize = rectSize + 10;
  
  posX = mouseX;
  posY = mouseY;
  
  grayTone = int(map(mouseX, 0, width, 0, 255)); //map(value, minInput, maxInput, minOutput, maxOutput)
  
  print("x:");
  print(posX);
  print(" / y:");
  println(posY);
  
}

void keyPressed(){
  background(255,0,0);
  isStarted = false;
}
