String currentRoom = "start";
String introText = "You stand infront of the IDP 1 door.";
String[] choicesA= {"1. Listen", "2. Open Door.", "3. Return to La Frasca."};

void setup() {
    size (800, 600);
    background(0); //why might I need to move this?
    textSize(20); //needed because I want text
}

void draw () {
    background(0);
    text(introText, 200, 200);
    int y = 400;
    for (int index = 0; index < choicesA.length; index++) {
        text(choicesA[index], 50, y);
        y+=40;
    }
}

void keyPressed () {
    if (key == '1') {
        String listenText = "You hear Dennis and Jose talking about coding";
        text(listenText, 200, 200); // only for once frame … when key was pressed
    }
}
