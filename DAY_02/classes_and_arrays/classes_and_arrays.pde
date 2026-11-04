class Particle {
    float x;
    float y;
    float diameter;
    color my_color;
    float speed;

    Particle() {
        diameter = 100;
        my_color = color(255, 127, 0);
        speed = 10;
    }

    void move_random() {
        x += random(-speed, speed);
        y += random(-speed, speed);
    }

    void display() {
        fill(my_color);
        circle(x, y, diameter);
    }
}

Particle[] particles;

void setup() {
    size(1024, 768);
    noStroke();
    blendMode(MULTIPLY);

    particles = new Particle[300];

    for (int i = 0; i < particles.length; i++) {
        particles[i] = new Particle();
        particles[i].x = width / 2 + random(-400, 400);
        particles[i].y = height / 2 + random(-400, 400);
        particles[i].diameter = random(5, 50);
        particles[i].my_color = color(random(0, 255), 127, 255);
        particles[i].speed = random(0, 20);
    }
}

void draw() {
    background(255);

    particles[0].x = mouseX;
    particles[0].y = mouseY;

    for (int i = 0; i < particles.length; i++) {
        particles[i].move_random();
        particles[i].display();
    }
}
