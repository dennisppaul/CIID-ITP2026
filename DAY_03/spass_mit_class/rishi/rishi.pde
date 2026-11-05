
PImage car;
PImage[] stickers = new PImage[22];

int currentSticker = 0;
float stickerSize = 70;

void setup() {
    size(1080, 607);
    background(255);

    // Car image
    car = loadImage("redbull car.png");
    imageMode(CENTER);

    float w = 1120;
    float h = w * car.height / car.width;

    image(car, 500, 300, w, h);

    // Stickers
    for (int i = 0; i < 22; i++) {
        stickers[i] = loadImage("sticker " + (i + 1) + ".png");
    }
}

void draw() {

    // Sticker preview
    noStroke();
    fill(255);
    rect(780, 0, 220, 110);

    fill(0);
    textSize(10);
    text("Sticker " + (currentSticker + 1), 900, 25);

    if (stickers[currentSticker] != null) {
        image(stickers[currentSticker], 850, 40, 70, 55);
    }
}


void mousePressed() {

    // Add sticker
    if (stickers[currentSticker] != null) {

        float w = stickerSize;
        float h = w * stickers[currentSticker].height / stickers[currentSticker].width;

        imageMode(CENTER);
        image(stickers[currentSticker], mouseX, mouseY, w, h);
    }
}


void keyPressed() {

    // Next sticker
    if (key == ' ') {
        currentSticker++;

        if (currentSticker == 22) {
            currentSticker = 0;
        }
    }

    // Increase sticker size
    if (key == '+' || key == '=') {
        stickerSize = stickerSize + 10;
    }

    // Decrease sticker size
    if (key == '-') {
        stickerSize = stickerSize - 10;

        if (stickerSize < 20) {
            stickerSize = 20;
        }
    }


    // Clear
    if (key == '0') {
        car = loadImage("redbull car.png");
        imageMode(CENTER);

        float w = 1120;
        float h = w * car.height / car.width;

        image(car, 500, 300, w, h);
    }
}
