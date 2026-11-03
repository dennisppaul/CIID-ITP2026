float pos_x;
float pos_y;
float gray_tone;
boolean is_started;

void setup() {
    size(1024, 768);
    rectMode(CENTER);
    noStroke();
    background(255, 0, 0);
}

void draw() {
    if (is_started) {
        rect(pos_x, pos_y, 50, 50);
    }
}

void mousePressed() {
    pos_x = mouseX;
    pos_y = mouseY;
    gray_tone = map(mouseX, 0, width, 0, 255);
    is_started = true;
}

void keyPressed() {
    background(255, 0, 0);
}

// mousePressed()
// keyPressed()
