class Particle {
    float x;
    float y;
    float diameter;
    color my_color;

    Particle() { // constructor without parameter
        diameter = 100;
        my_color = color(255, 127, 0);
    }
    
    Particle(float initial_diameter) { // constructor with one parameter
        diameter = initial_diameter;
        my_color = color(255, 127, 0);
    }
}

Particle a_thing;
Particle b_thing;
Particle c_thing;

void setup() {
    size(1024, 768);
    noStroke();

    a_thing = new Particle();
    a_thing.x = width / 2;
    a_thing.y = height / 2;
    a_thing.diameter = 200;
    a_thing.my_color = color(0, 127, 255);

    b_thing = new Particle();
    b_thing.x = width / 2 + 100;
    b_thing.y = height / 2;

    c_thing = new Particle(150);
    c_thing.x = width / 2 - 100;
    c_thing.y = height / 2;
}

void draw() {
    background(255);

    a_thing.x = mouseX;
    a_thing.y = mouseY;

    fill(a_thing.my_color);
    circle(a_thing.x, a_thing.y, a_thing.diameter);

    fill(b_thing.my_color);
    circle(b_thing.x, b_thing.y, b_thing.diameter);

    fill(c_thing.my_color);
    circle(c_thing.x, c_thing.y, c_thing.diameter);
}
