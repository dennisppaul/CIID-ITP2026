// Input: provides one person position plus "present yes/no".
// v1 uses the mouse. v2 replaces updateInput() with camera tracking;
// the rest of the sketch reads only personX, personY and personPresent.

float   personX;
float   personY;
boolean personPresent;

int     lastMouseX;
int     lastMouseY;
int     lastMoveMillis;
boolean mouseEverMoved = false;

void updateInput() {
    if (mouseX != lastMouseX || mouseY != lastMouseY) {
        // the first reading only records the start position, it is not movement
        if (frameCount > 1) {
            mouseEverMoved = true;
            lastMoveMillis = millis();
        }
        lastMouseX = mouseX;
        lastMouseY = mouseY;
    }
    personX = mouseX;
    personY = mouseY;
    personPresent = mouseEverMoved && millis() - lastMoveMillis < IDLE_TIMEOUT * 1000;
}
