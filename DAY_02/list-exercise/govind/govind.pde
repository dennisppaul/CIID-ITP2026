PShape vautour;
PShape[] bird = new PShape[4];
ArrayList<Flamingo> flamingos;
ArrayList<PVector> coordinates;
float[][] sizeF = new float[4][2];

PGraphics vautourBuffer;
PShape bg;

void setup() {
  size(1024, 768);
  background(255);
  shapeMode(CENTER);
  for (int i=0; i<4; i++)
  {
    sizeF[i][0]=random(100, 300);
    sizeF[i][1]=sizeF[i][0]/4;
  }
  vautour = loadShape("vautour_moine.svg");
  bird[0]=loadShape("bird1.svg");
  bird[1]=loadShape("bird2.svg");
  bird[2]=loadShape("bird3.svg");
  bird[3]=loadShape("bird4.svg");
  bg=loadShape("bg.svg");
  flamingos=new ArrayList<Flamingo>();
  coordinates=new ArrayList<PVector>();

  coordinates.add(new PVector(random(-1024/2, 1024/2), random(-768/2, 768)));
  coordinates.add(new PVector(random(-1024/2, 1024/2), random(-768/2, 768)));
  coordinates.add(new PVector(random(-1024/2, 1024/2), random(-768/2, 768)));
  coordinates.add(new PVector(random(-1024/2, 1024/2), random(-768/2, 768)));
}

void draw() {
  float widthV=100;
  pushMatrix();
  translate(width/2, height/2);
  shape(bg, 0, 0, width, height);
  popMatrix();
  noStroke();
  fill(255, 5);
  rect(0, 0, width, height);
  pushMatrix();
  translate(mouseX, mouseY);
  rotate(1000*TWO_PI/mouseY); 
  shape(vautour, 0, 0, widthV*2, 2*(widthV*2.267));

  //for (int i=0; i<10; i++)
  //{
  //  shape(vautour, 0+i*width/5, 0+i*height/5, widthV, (widthV*2.267));
  //}
  popMatrix();

  pushMatrix();
  translate(width/2, height/2);
  int j=0;
  for (PVector pos : coordinates)
  {
    shape(bird[j], pos.x, pos.y, sizeF[j][0], sizeF[j][1]);
    pos.x=(pos.x+5)%1024;

    j=(j+1)%4;
  }

  //shape(bird[0], -300, 300, coordinates.get(0), 100/2);
  //shape(bird[1], 300, 300, 400/2, 100/2);
  //shape(bird[2], 300, -300, 400, 100);
  //shape(bird[3], -300, -300, 400, 100);
  popMatrix();
}

void mousePressed () {
  //  background(255);
}

class Flamingo {
  PShape birdShape;
  PVector pos;
  PVector vel;
  float angle;
  float rotSpeed;
  float alpha;
  float size;

  Flamingo(float x, float y) {
  }
}
