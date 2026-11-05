// ASSIGNMENT: play with classes and arrays: 
//     ideally use also PImage and PFont
//     maybe create an array of images and show
//     them on the screen.

PImage my_image;
PFont my_font;
PFont my_installed_font;

void setup() {
    size(1024, 768);
    noStroke();
    my_image = loadImage("Toyokawa-city.png"); // copy into data folder ( drag-n-drop also works )

//    String[] fontList = PFont.list();
//    printArray(fontList);

    my_font = loadFont("Futura-Medium-48.vlw");
    my_installed_font = createFont("Futura-Bold", 24);
}

void draw() {
    background(255);
    fill(255, 0, 0);
    circle(width/2, height/2, 200);

    image(my_image, mouseX, mouseY);
    fill(0);
    textFont(my_font);
    text("Toyokawa", mouseX, mouseY);
    textFont(my_installed_font);
    text("20261105", 20, 36);
}
