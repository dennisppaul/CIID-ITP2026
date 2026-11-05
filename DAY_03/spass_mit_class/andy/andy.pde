PImage[] cows = new PImage[3];
PFont moo;
//float[] x = new float [20];
//float [] y = new float [20]


 void setup() {
  size(600, 400);
  background(#B6EAB8);
  cows[0] = loadImage("cow1.jpg");
  cows[1] = loadImage("cow2.jpg");
  cows[2] = loadImage("cow3.jpg");

  for (int i =0; i < 20; i++) {
    int pick = int(random(3));
    float x = random(width);
    float y = random(height);
    image(cows[pick], x, y, 70, 70);
  }
  //moo = createFont("HarlowSolid-40", 10);
  moo = loadFont ("OldEnglishTextMT-48.vlw"); 
  textFont(moo);
  textSize(30); 
  textAlign(CENTER); 
  fill(0);
  text("MOOOVE OUT THE WAY, Bitch", width/2, 250);
}
