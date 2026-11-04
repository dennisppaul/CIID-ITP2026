FloatList myXList;
FloatList myYList;
FloatList mySizeList;
FloatList myAlphaList;
FloatList myColorList;

FloatList lineXList;
FloatList lineYList;

void setup() {
    size(600, 400);
    background(10, 15, 30);

    myXList = new FloatList();
    myYList = new FloatList();
    mySizeList = new FloatList();
    myAlphaList = new FloatList();
    myColorList = new FloatList();

    lineXList = new FloatList();
    lineYList = new FloatList();
}

void draw() {
    background(10, 15, 30);
    noFill();

    // Add ripples automatically
    automaticAddElements();

    // Draw ripples
    for (int i = 0; i < myXList.size(); i++) {

        float x = myXList.get(i);
        float y = myYList.get(i);
        float s = mySizeList.get(i);
        float a = myAlphaList.get(i);
        float c = myColorList.get(i);

        // Five colours
        if (c % 5 == 0) {
            stroke(180, 245, 255, a);
        } else if (c % 5 == 1) {
            stroke(255, 120, 180, a);
        } else if (c % 5 == 2) {
            stroke(255, 190, 90, a);
        } else if (c % 5 == 3) {
            stroke(180, 140, 255, a);
        } else {
            stroke(120, 255, 160, a);
        }

        // Draw ripple
        strokeWeight(4);
        circle(x, y, s);

        // Increase size and fade
        mySizeList.set(i, s + 2);
        myAlphaList.set(i, a - 1);

        // Remove invisible ripples
        if (a <= 1) {
            myXList.remove(i);
            myYList.remove(i);
            mySizeList.remove(i);
            myAlphaList.remove(i);
            myColorList.remove(i);
            i--;
        }
    }

    // Add neon lines automatically
    if (frameCount % 15 == 0) {
        lineXList.append(random(0, 600));
        lineYList.append(random(0, 400));
    }

    // Draw neon lines
    for (int i = 0; i < lineXList.size(); i++) {

        float x = lineXList.get(i);
        float y = lineYList.get(i);

        // Soft glow
        stroke(100, 220, 255, 40);
        strokeWeight(10);
        line(x, y, x + 30, y - 15);

        // Bright line
        stroke(220, 250, 255);
        strokeWeight(2);
        line(x, y, x + 30, y - 15);

        // Move lines
        lineXList.set(i, x + 2);
        lineYList.set(i, y - 1);

        // Remove lines outside canvas
        if (x > 650 || y < -50) {
            lineXList.remove(i);
            lineYList.remove(i);
            i--;
        }
    }
}

// Automatically create ripples
void automaticAddElements() {
    if (frameCount % 30 == 0) {

        float x = random(0, 600);
        float y = random(0, 400);

        myXList.append(x);
        myYList.append(y);
        mySizeList.append(10);
        myAlphaList.append(255);
        myColorList.append(int(random(0, 5)));
    }
}
