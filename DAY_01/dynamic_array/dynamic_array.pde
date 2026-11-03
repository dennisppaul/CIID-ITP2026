FloatList circle_x_positions;

void setup() {
    size(1024, 768);
    circle_x_positions = new FloatList();
    circle_x_positions.append(0);
    circle_x_positions.append(width);
    fill(0);
    noStroke();
}

void draw() {
    background(255);
    for (int i=0; i<circle_x_positions.size(); i++) {
        float x = circle_x_positions.get(i);
        circle(x, height / 2, size);
    }
    if (mousePressed) {
        circle_x_positions.append(mouseX);
    }
}
