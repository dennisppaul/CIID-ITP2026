class SketchPoints extends Sketch {

    boolean mouse_pressed = true;

    SketchPoints(PApplet p) {
        super(p);
        graphics = createGraphics(1024, 768, P2D);
    }

    void setup() {
        println("setup in SketchPoints");
    }

    void draw() {
        graphics.beginDraw();
        graphics.background(255, 0, 0);
        graphics.fill(255);
        graphics.noStroke();
        graphics.circle(mouseX, mouseY - 50, mouse_pressed ? 100 : 50);
        graphics.circle(mouseX, mouseY + 50, mouse_pressed ? 100 : 50);
        graphics.endDraw();
    }

    void mousePressed() {
        mouse_pressed = !mouse_pressed;
        println("mouse pressed in SketchPoints");
    }

    void finish() {
        println("finish in SketchPoints");
    }
}
