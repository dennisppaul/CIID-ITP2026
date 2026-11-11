class SketchRects extends Sketch {

    boolean mouse_pressed = true;

    SketchRects(PApplet p) {
        super(p);
        graphics = createGraphics(1024, 768, P2D);
    }

    void setup() {
        println("setup in SketchRects");
        graphics.beginDraw();
        graphics.rectMode(CENTER);
        graphics.endDraw();
    }

    void draw() {
        graphics.beginDraw();
        graphics.background(255);
        graphics.fill(255, 0, 0);
        graphics.noStroke();
        graphics.square(mouseX, mouseY, mouse_pressed ? 100 : 50);
        graphics.endDraw();
    }

    void mousePressed() {
        mouse_pressed = !mouse_pressed;
        println("mouse pressed in SketchRects");
    }

    void finish() {
        println("finish in SketchRects");
    }
}
