FloatList myPosXList;
FloatList myPosYList;

int maxElements = 40;
int value = 0;


void setup() {
  size(500, 500);
  background(0);
  rectMode(CENTER);

  myPosXList = new FloatList();
  myPosYList = new FloatList();

  myPosXList.append(20.0);
  myPosXList.append(25.0);
  myPosXList.append(99.0);

  myPosYList.append(30.0);
  myPosYList.append(22.0);
  myPosYList.append(23.0);

  noStroke();
}

void draw() {
  //background(0);
  fill(0, 50);
  rect(width/2, height/2, width, height);
  fill(255, 100);

  automaticAddElements();
  updateListElements();
  displayListElements();
}

void automaticAddElements() {
  if (myPosXList.size() < maxElements) {
    if (frameCount%100 == 0) {
      float posX = random(0, width);
      float posY = random(0, height);
      addListElement(posX, posY);
    }
  }
}

void updateListElements() {
  for (int index = 0; index < myPosXList.size(); index++) {
    float posX = myPosXList.get(index);
    float posY = myPosYList.get(index);

    myPosXList.set(index, posX + random(-20, 20));
    myPosYList.set(index, posY + random(-20, 20));
  }
}

void displayListElements() {
  for (int index = 0; index < myPosXList.size(); index++) {
    float posX = myPosXList.get(index);
    float posY = myPosYList.get(index);
    
    //noStroke();
    //fill(value);
    //rect(250, 250, 200, 200, 20);

    fill(#B300F5);
    circle(posX, posY, 50);

    fill(#FFF303);
    circle(posX, posY, 20);
    
    noFill();
    stroke(#03FF2E);
    circle(posX, posY, 80);

    noFill();
    stroke(#03FF2E);
    circle(posX+150, posY+150, 80);

    fill(#FF7D03);
    circle(posY, posY, 20);
  }
}

void mousePressed() {
  removeListElement(0);
  addListElement(mouseX, mouseY);
}

//void mouseDragged() 
//{
//  value = value + 5;
//  if (value > 255) {
//    value = 0;
//  }
//}

void addListElement(float posX, float posY) {
  myPosXList.append(posX);
  myPosYList.append(posY);
}

void removeListElement(int index) {
  myPosXList.remove(index);
  myPosYList.remove(index);
}
