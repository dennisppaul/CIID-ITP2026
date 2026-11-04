class Particle {
    PVector position = new PVector();
    float diameter = 100;
    color my_color = color(255, 127, 0);
}

Particle a_thing;
Particle b_thing;

void setup() {
    size(1024, 768);
    noStroke();

    a_thing = new Particle();
    a_thing.position.x = width / 2;
    a_thing.position.y = height / 2;
    a_thing.diameter = 200;
    a_thing.my_color = color(0, 127, 255);

    b_thing = new Particle();
    b_thing.position.x = width / 2 + 100;
    b_thing.position.y = height / 2;
}

void draw() {
    background(255);

    a_thing.position.x = mouseX;
    a_thing.position.y = mouseY;

    fill(a_thing.my_color);
    circle(a_thing.position.x, a_thing.position.y, a_thing.diameter);

    fill(b_thing.my_color);
    circle(b_thing.position.x, b_thing.position.y, b_thing.diameter);
}
