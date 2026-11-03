void setup() {
    size(1024, 768);
    noStroke();
}

void draw() {
    background(255);
    draw_face(width / 2, height / 2);
    draw_face(mouseX, mouseY);    
}
