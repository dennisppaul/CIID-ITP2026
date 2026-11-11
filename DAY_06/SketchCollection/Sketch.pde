abstract class Sketch {
    PApplet parent;
    PGraphics graphics;

    Sketch(PApplet p) {
        parent = p;
    }

    abstract void setup();
    abstract void draw();
    abstract void mousePressed();
    abstract void finish();
}
