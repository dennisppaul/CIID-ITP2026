void setup() {
    size(1024, 768);
    background(255);
    println("beginShape();");
    noStroke();
    fill(0);
}

void draw() {}

void mousePressed() {
    println("vertex(" + mouseX + ", " + mouseY + ");"); // could also be `curveVertex()`
    circle(mouseX, mouseY, 10);
}

void dispose() {
    println("endShape();");
}
