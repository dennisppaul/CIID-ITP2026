final int STATE_START = 0;
final int STATE_MAIN = 1;
final int STATE_END = 2;

int application_state;
int state_counter;

void setup() {
    size(1024, 768);
    application_state = STATE_START;
    state_counter = 0;
    noStroke();
}

void draw() {
    background(255);

    if (application_state == STATE_START) {
        fill(255, 0, 0);
        circle(width / 2, height / 2, 100);
    } else if (application_state == STATE_MAIN) {
        fill(255, 0, 0);
        float x = width / 2 + random(-10, 10);
        float y = height / 2 + random(-10, 10);
        circle(x, y, 100);
        // state_counter = state_counter + 1;
        // state_counter += 1;
        state_counter++;
        if (state_counter > 3 * 60) {
            application_state = STATE_END;
        }
    } else if (application_state == STATE_END) {
        fill(255, 0, 0, 91);
        circle(width / 2, height / 2, 100);
    }
}

void keyPressed() {
    // "press space to (re)start the main application"
    if (key == ' ') {
        application_state = STATE_MAIN;
        state_counter = 0;
    }
}
