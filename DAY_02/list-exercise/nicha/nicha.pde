FloatList myPosXList;
FloatList myPosYList;

int maxElements = 50;

void setup() {
    fullScreen();
    background(255);
    rectMode(CENTER);

    myPosXList = new FloatList();
    myPosYList = new FloatList();

    myPosXList.append(0.0);
    myPosXList.append(1.0);
    myPosXList.append(2.0);

    myPosYList.append(0.0);
    myPosYList.append(1.0);
    myPosYList.append(2.0);

    noStroke();
}

void draw() {
    //background(255);
    fill(0, 10);
    rect(width/2, height/2, width, height);
    fill(255, 100);

    automaticAddElements();
    updateListElements();
    displayListElements();
}

void automaticAddElements() {
    if (myPosXList.size() < maxElements) {
        if (frameCount%50 == 0) {
            float posX = random(0, width);
            float posY = random(0, height);
            addListElement(posX, posY);
        }
    }
}

void updateListElements() {
    for (int index = 0; index < myPosXList.size(); index=index+3) {
        float posX = myPosXList.get(index);
        float posY = myPosYList.get(index);

        myPosXList.set(index, posX + random(2, 0));
        myPosYList.set(index, posY + random(2, 0));
    }
}

void displayListElements() {

    color c1 = color(#69FFFD, 80);
    color c2 = color(#F7FF89, 70);
    color c3 = color(#FF9900, 30);


    for (int index = 0; index < myPosXList.size(); index=index+3) {
        float posX = myPosXList.get(index);
        float posY = myPosYList.get(index);
        gradientRect(posX, posY, 70, 800, c1, c2, c3);
        //rect(posX, posY, 600, 600);
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

void gradientRect(float x, float y, float w, float h, color c1, color c2, color c3) {
    float top = y - h/2;
    float left = x - w/2;

    for (int i = 0; i < h; i++) {
        if (i < h/2) {
            float g = map(i, 0, h/2, 0, 1);
            g = (g + frameCount * 0.02) % 1;
            stroke(lerpColor(c1, c2, g));
        } else {
            float g = map(i, h/2, h, 0, 1);
            g = (g + frameCount * 0.02) % 1;
            stroke(lerpColor(c2, c3, g));
        }
        line(left, top + i, left + w, top + i);
    }
    noStroke();
}

void keyPressed() {
    saveFrame();
}
