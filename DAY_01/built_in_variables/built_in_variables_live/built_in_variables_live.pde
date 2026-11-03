float square_size = 100;
float square_alpha = 8;

void setup() {
    size(1024, 768);
    background(255, 0, 0);
    rectMode(CENTER);
    noStroke();
    println("setup done");
}

void draw() {
    if (frameCount > 300) {
        println("application exited");
        exit();
    }
    if (keyPressed) {
        background(255, 0, 0);
    }
    if (mousePressed) {
        // draw grey shape
        float grey_value = map(mouseX, 0, width, 0, 255);
        fill(grey_value, square_alpha);
        square(mouseX, mouseY, square_size);
    }
}
