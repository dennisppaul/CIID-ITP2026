final int NUM_ELEMENTS = 1000;
float[] x = new float[NUM_ELEMENTS];
float[] y = new float[NUM_ELEMENTS];

void setup() {
    size(700, 700);
    background(0);

    for (int i = 0; i < NUM_ELEMENTS; i++) {
        x[i] = random(width);
        y[i] = random(height);
    }
}

void draw() {
    for (int i = 0; i < NUM_ELEMENTS; i++) {
        stroke(random(255), random(255), random(255));
        strokeWeight(random(1, 10));

        float nextX = x[i] + random(-20, 20);
        float nextY = y[i] + random(-20, 20);

        line(x[i], y[i], nextX, nextY);

        x[i] = nextX;
        y[i] = nextY;
    }
}

void keyPressed() {
    saveFrame();
}
