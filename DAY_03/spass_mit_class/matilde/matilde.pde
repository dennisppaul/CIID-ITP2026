PImage img1;
PImage imgA;
PImage imgB;
PImage imgC;

void setup() {
  fullScreen();
  img1 = loadImage("party.jpg");
  imgA = loadImage("happy.jpg");
  imgB = loadImage("happyarm.png");
  imgC = loadImage("strong.jpg");
}
int state = 0;

void draw() {
  switch(state) {

  case 0:
    image(img1, 0, 0);
    break;
  case 1:
    image(imgA, 0, 0, 100, 100);
    break;
  case 2:
    image(imgB, 0, 0);
    break;
  case 3:
    image(imgC, 0, 0);
    break;
  }
}
void mousePressed() {
  state++;

  if (state > 3) {
    state = 0;
  }
}
