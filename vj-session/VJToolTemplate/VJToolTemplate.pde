final boolean PERFORMANCE_MODE = true;

void settings() {
    if (!PERFORMANCE_MODE) {
        // size(1280,720);   // 720p
        size(1920, 1080); // 1080p
    } else {
        fullScreen();
    }
}

void setup() {
    noCursor();
    noStroke();
}

void draw() {
    background(255);
    float mSize = 100;
    if (keyPressed) {
        mSize = height * 0.9;
    }
    fill(0);
    circle(width/2, height/2, mSize);
    fill(255);
    circle(mouseX, mouseY, 150);
}
