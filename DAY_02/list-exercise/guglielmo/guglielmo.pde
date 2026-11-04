FloatList myPosXList;
FloatList myPosYList;
float noiseScale = 0.01;

void setup() {
    pixelDensity(2);
    size(400, 400);
    background(0, 0, 0);
    rectMode(CENTER);
    //create lists
    myPosXList = new FloatList();
    myPosYList = new FloatList();

    //appends(adds and sets) 3 starting positions
    myPosXList.append(120.0);
    myPosXList.append(325.0);
    myPosXList.append(200.0);

    myPosYList.append(221.0);
    myPosYList.append(79.0);
    myPosYList.append(250.0);
}

void draw() {
    //background(0, 0, 0);
    fill(0, 20);
    rect(0, 0, 1000, 1000);
    displayListElements();
    updateListElements();
}


void updateListElements() {
    // this moves the elements, without adding new ones
    // go through every point in the lists, one by one
    for (int index = 0; index < myPosXList.size(); index++) {

        // GET: read the current X and Y of this point
        // (copies the values into local variables)
        float posX= myPosXList.get(index);
        float posY= myPosYList.get(index);

        // SET: write a new value back into the same slot
        // new position = old position + a small random step
        myPosXList.set(index, posX + (noise(index * 10, frameCount * noiseScale) - 0.5) * 200);
        myPosYList.set(index, posY + (noise(index * 10 + 1000, frameCount * noiseScale) - 0.5) * 200);
    }
}

void displayListElements() {

    // // spawn, every 60 frames adds a circle at a random spot
    if (frameCount%60 == 0 ) {
        float posX = random(0, width);
        float posY = random(0, height);
        addListElement(posX, posY);
    }
    //rendering function. makes the circles
    for (int index=0; index< myPosXList.size(); index++) {
        float posX=myPosXList.get(index);
        float posY= myPosYList.get(index);
        stroke(255);
        strokeWeight(1);
        line(posX, posY, width/2, height/2);
    }
}

void mouseDragged() {
    // removes one element of the FloatList
    removeListElement(0);
    // adds a element of the FloatList
    addListElement(mouseX, mouseY);
}


void addListElement(float posX, float posY) {
    myPosXList.append(posX);
    myPosYList.append(posY);
}

void removeListElement (int index) {
    myPosXList.remove(index);
    myPosYList.remove(index);
}
