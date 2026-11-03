final float rect_size = 192;

void setup() {
    size(1024, 768);
    rectMode(CENTER);
    noStroke();
    background(255, 0, 0);
}

void draw() {
    if (keyPressed) {
        background(255, 0, 0);
    }
    if (mousePressed) {
        float gray_tone = map(mouseX, 0, width, 0, 255);
        fill(gray_tone, 8);
        rect(mouseX, mouseY, rect_size, rect_size);
    }
}

// mouseX + mouseY
// width + height
// frameCount
// mousePressed + keyPressed
