int counter = 0;

void setup() {
    size(640, 480);
}

void draw() {
    background(255);

    fill(255, 0, 0);
    noStroke();
    circle(width / 2, height / 2, counter + 50);

    stroke(0);
    noFill();
    circle(mouseX, mouseY, 100);
    if (mouseX > 300 && mouseX < 340) {
        if (mouseY > 220 && mouseY < 260) {
            counter = counter + 1;
        }
    }

    if (counter > 200) {
        println("YOU WON!!!");
        exit();
    }
}
