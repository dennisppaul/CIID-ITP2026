void setup() {
    size(1024, 768);
    noFill();
    strokeWeight(2);
}

void draw() {
    background(255);
    // 'i' is for iteration
    //  (start)   | (end) | (after each iteration)
    for (int j = -1; j < 2; j++) { // <- this might blow your brains out
        float circle_y = height / 2 + j * 100;
        for (int i = 0; i < 50; i++) {
            float circle_alpha = map(i, 0, 49, 100, 0);
            stroke(0, 255, 127, circle_alpha);
            circle(i * 12 + 242, circle_y, i * 10 + 10);
            // println(i);
        }
    }
}
