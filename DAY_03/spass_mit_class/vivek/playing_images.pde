/*
image processing
mapping pixel -> radius/font-size
*/

PImage img;

void setup() {
  size(400, 400);
  int spacing = 5;
  background(0, 0, 255);
  // describe() has no Processing equivalent, so it's dropped

  img = loadImage("images.jpeg");
  // Processing has no COVER mode. The closest equivalent is:


  // Emoji need a font that has them (pick the one for your OS)
  // Windows: "Segoe UI Emoji" | Mac: "Apple Color Emoji" | Linux: "Noto Color Emoji"
  textFont(createFont("Apple Color Emoji", 32));

  noStroke();
  fill(255);
  for (int i = 0; i < width; i += spacing) {
    for (int j = 0; j < height; j += spacing) {
      color px = img.get(i, j);
      float r = map(red(px), 0, 255, 1, spacing);
       // circle(i, j, r) also works in Processing 4
       //rect(i, j, r, r);
      textSize(r);
      text("🦊️", i, j);
    }
  }
}
