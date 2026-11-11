class SketchCross extends Sketch {

    boolean mouse_pressed = true;

    SketchCross(PApplet p) {
        super(p);
        graphics = createGraphics(1024, 768, P2D);
    }

    void setup() {
        println("setup in SketchCross");
    }

    void draw() {
        graphics.beginDraw();
        graphics.background(0);
        graphics.noFill();
        graphics.stroke(255);
        graphics.strokeWeight(16);
        final float cross_size = mouse_pressed ? 100 : 50;
        graphics.line(mouseX - cross_size, mouseY - cross_size, mouseX + cross_size, mouseY + cross_size);
        graphics.line(mouseX + cross_size, mouseY - cross_size, mouseX - cross_size, mouseY + cross_size);
        graphics.endDraw();
    }

    void mousePressed() {
        mouse_pressed = !mouse_pressed;
        println("mouse pressed in SketchCross");
    }

    void finish() {
        println("finish in SketchCross");
    }
}
