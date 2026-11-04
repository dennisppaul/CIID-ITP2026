/*
click to make 'em panic
 */

int squareSize = 100;
int gap = 20;
int stride;
int rows = 20;
int cols = 20;

int gridWidth, gridHeight;
float gridMoveX, gridMoveY, newX, newY;
int startX, startY;

float colorLerpFactor = 0.1;
float moveLerpFactor = 0.5;

int colorTime = 0;
int moveTime = 0;
int colorInterval = 500;
int moveInterval = 1000;
int currentTime = 0;

int[] oldStrokeColor = new int[5];
int[] strokeColor = new int[5];
int[] newStrokeColor = new int[5];

boolean strobe = false;


void setup() {
    //size(640, 480);
    fullScreen();
    noCursor();
    pixelDensity(1);

    ellipseMode(CENTER);
    background(20);

    stride = squareSize + gap;

    gridWidth = cols * stride + gap;
    gridHeight = rows * stride + gap;

    startX = (width - gridWidth) / 2;
    startY = (height - gridHeight) / 2;
}

void draw() {

    // background
    fill(20, 50);
    rect(-10, -10, width + 20, height + 20);

    smooth();

    stroke(255);

    currentTime = millis();
    if (currentTime - colorTime > colorInterval) {
        colorTime = currentTime;

        for (int i = 0; i < strokeColor.length; i++) {
            strokeColor[i] = newStrokeColor[i];
            newStrokeColor[i] = color(random(255), 0, random(255));
        }
    }

    if (currentTime - moveTime > moveInterval) {
        moveTime = currentTime;

        newX = random(-gap, gap);
        newY = random(-gap, gap);
    }

    gridMoveX = lerp(gridMoveX, newX, moveLerpFactor);
    gridMoveY = lerp(gridMoveY, newY, moveLerpFactor);

    for (int i = 0; i < strokeColor.length; i++) {
        strokeColor[i] = lerpColor(strokeColor[i], newStrokeColor[i], colorLerpFactor);
    }

    noFill();
    strokeWeight(4);

    pushMatrix();

    translate(startX, startY);
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (i % 2 == 0) {
                if (j % 2 == 0) {
                    stroke(strokeColor[0]);
                } else {
                    stroke(strokeColor[1]);
                }
            } else {
                if (j % 2 == 0) {
                    stroke(strokeColor[2]);
                } else {
                    stroke(strokeColor[3]);
                }
            }
            circle(gap + squareSize/2 + i * stride + gridMoveX, gap + squareSize/2 + j * stride + gridMoveY, squareSize);
        }
    }

    popMatrix();
}

// int(random(0, strokeColor.length))

void mousePressed() {
    strobe = !strobe;
    if (strobe) {
        colorInterval = 10;
        moveInterval = 100;
    } else {
        colorInterval = 500;
        moveInterval = 1000;
    }
}

void keyPressed() {
    if (keyCode == ENTER) {
        saveFrame();
    }
}
