class Particle {
    PVector pos;
    float xOff;
    float yOff;
    float rad;
    boolean isAlive;
    float speed;
    float alpha;

    Particle() {
        float posX = random(0, width);
        float posY = random(0, height);
        pos = new PVector(posX, posY);
        rad = random(10, 50);
        isAlive = true;
        xOff = random(0, 1000);
        yOff = random(0, 1000);
        speed = 0.1;
    }

    void update() {
        xOff += speed;
        yOff += speed;

        pos.x += map(noise(xOff), 0, 1, -1, 1);
        pos.y += map(noise(yOff), 0, 1, -1, 1);

        rad--;

        if (rad <= 0) {
            isAlive = false;
        }
    }

    void display() {
        fill(255);
        noStroke();
        circle(pos.x, pos.y, rad);
    }
}
