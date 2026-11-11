// define IDs for all sketches
final int SKETCH_POINTS = 0;
final int SKETCH_RECTS  = 1;
final int SKETCH_CROSS  = 2;
final int NUM_SKETCHES  = 3;

Sketch[] sketches;
int current_sketch_id;

void settings() {
    size(1024, 768, P2D);
}

void setup() {
    // create slots and instances of all sketches
    sketches = new Sketch[NUM_SKETCHES];
    sketches[SKETCH_POINTS] = new SketchPoints(this);
    sketches[SKETCH_RECTS]  = new SketchRects(this);
    sketches[SKETCH_CROSS]  = new SketchCross(this);
    change_sketch(SKETCH_POINTS);
}

void draw() {
    background(0);
    // draw current sketch and show it
    if (sketches[current_sketch_id] != null) {
        sketches[current_sketch_id].draw();
        image(sketches[current_sketch_id].graphics, 10, 10, width - 20, height - 20);
    }
}

void mousePressed() {
    // pass events to current sketch
    if (sketches[current_sketch_id] != null) {
        sketches[current_sketch_id].mousePressed();
    }
}

void keyPressed() {
    // switch to next sketch
    if (key == ' ') {
        int new_sketch_id = current_sketch_id + 1;
        new_sketch_id %= sketches.length;
        change_sketch(new_sketch_id);
    }
    // switch to specific sketch
    if (key == 'r') {
        change_sketch(SKETCH_RECTS);
    }
}

void change_sketch(int sketch_id) {
    // cleanly exit old sketch and switch to new sketch
    if (sketches[current_sketch_id] != null) {
        sketches[current_sketch_id].finish();
    }
    current_sketch_id = sketch_id;
    if (sketches[current_sketch_id] != null) {
        sketches[current_sketch_id].setup();
    }
}
