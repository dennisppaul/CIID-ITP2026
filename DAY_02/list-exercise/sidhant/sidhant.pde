// ==============================
//  Sketch name — Waves
//  Author: Sidhant Tibrewal
//  Date:
// ==============================

// ---------- Globals ----------

ArrayList<Particle> particles;
int size, noiseSeed, randomSeed;
float scale, speed;
color bg;

// ---------- Init ----------

void init() {
    noiseSeed = int(random(0, 6000));
    randomSeed = int(random(0, 400));

    noiseSeed(noiseSeed);
    randomSeed(randomSeed);

    size =int(random(1000, 2500));
    scale = random(0.001, 0.005);
    speed=random(0.1, 2);
    bg = #0E0E0E;

    particles = new ArrayList<Particle>();
    for (int i=0; i<size; i++) {
        float x = random(width);
        float y = random(height);
        particles.add(new Particle(x, y, random(50, 400), 320, 300));
    }
    background(bg);
}

// ---------- Setup ----------

void setup() {
    //size(1024, 768);
    fullScreen();
    frameRate(60);
    smooth();
    init();
    colorMode(HSB, 400);
    strokeWeight(4);
    background(bg);
}

// ---------- Draw ----------
void draw() {
    fill(bg, 35);
    noStroke();
    rect(0, 0, width, height);
    render();
}

// ---------- Logic ----------



// ---------- Rendering ----------
void render() {
    for (int i=0; i<particles.size(); i++) {
        Particle particle = particles.get(i);
        PVector newCoordinates = particle.getNewCoordinates();
        stroke(particle.rgbColor.x, particle.rgbColor.y, particle.rgbColor.z);
        if (newCoordinates.z==0)
            line(newCoordinates.x, newCoordinates.y, particle.position.x, particle.position.y);
        particle.setNewCoordinates(newCoordinates);
    }
}

// ---------- Input ----------
void keyPressed() {
}

void mousePressed() {
    init();
}

// ---------- Class ----------

class Particle {
    PVector position;
    PVector rgbColor;

    Particle(float x, float y, float r, float b, float g) {
        position = new PVector(x, y);
        rgbColor = new PVector(r, g, b);
    }

    PVector getNewCoordinates() {
        int didWeReset = 0;
        float theta = noise(this.position.x*scale, this.position.y*scale)*TWO_PI;
        float newX=this.position.x+speed*cos(theta);
        float newY=this.position.y+speed*sin(theta);

        if (newX>width || newY>height || newX<0 || newY<0 ) {
            newX = random(width);
            newY = random(height);
            didWeReset=1;
        }

        return new PVector(newX, newY, didWeReset);
    }

    void setNewCoordinates(PVector newCoordinates) {
        this.position.x = newCoordinates.x;
        this.position.y = newCoordinates.y;
    }
}
