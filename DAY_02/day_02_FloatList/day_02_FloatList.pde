FloatList myPosXList;
FloatList myPosYList;

int maxElements = 10;

void setup() {
  size(400, 400);
  background(0);
  rectMode(CENTER);

  myPosXList = new FloatList();
  myPosYList = new FloatList();

  myPosXList.append(7.0);
  myPosXList.append(325.0);
  myPosXList.append(399.0);

  myPosYList.append(300.0);
  myPosYList.append(220.0);
  myPosYList.append(223.0);
  
  noStroke();
}

void draw() {
  //background(0);
  fill(0,50);
  rect(width/2, height/2, width, height);
  fill(255,100);

  automaticAddElements();
  updateListElements();
  displayListElements();
}

void automaticAddElements() {
  if (myPosXList.size() < maxElements) {
    if (frameCount%60 == 0) {
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

    myPosXList.set(index, posX + random(-5, 5));
    myPosYList.set(index, posY + random(-5, 5));
  }
}

void displayListElements() {
  for (int index = 0; index < myPosXList.size(); index++) {
    float posX = myPosXList.get(index);
    float posY = myPosYList.get(index);
    rect(posX, posY, 50, 50);
  }
}

void mousePressed() {
  removeListElement(0);
  addListElement(mouseX, mouseY);
}

void addListElement(float posX, float posY) {
  myPosXList.append(posX);
  myPosYList.append(posY);
}

void removeListElement(int index) {
  myPosXList.remove(index);
  myPosYList.remove(index);
}
