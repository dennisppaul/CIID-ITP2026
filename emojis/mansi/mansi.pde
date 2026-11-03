float eyeX =0;
float eyeY =0;

float eyebrowY =0;


void setup() {
  size(500, 500);
  background(#FFFFFF);
  noStroke();
}

void draw() {
  //hair
  fill(#00B71D);
  rect(120, 120, 220, 180, 98, 98, 12, 12);

  fill(#1C1C1C);
  rect(120, 120, 220, 160, 98, 98, 0, 0);


  //ears
  fill(#FFE5CB);
  circle(150, 220, 30);

  fill(#FFE5CB);
  circle(300, 220, 30);

  //face
  fill(#FFE5CB);
  circle(224, 224, 150);

  //blush
  if (dist(mouseX, mouseY, 50, 100)< 250) {
    fill(255, 75, 234, 30);
    circle(179, 224, 39);

    fill(255, 75, 234, 30);
    circle(267, 224, 39);
  }




  //eyebrows
  fill(#0F0F0F);
  rect(175, 175 +eyebrowY, 25, 4);

  fill(#0F0F0F);
  rect(245, 175 +eyebrowY, 25, 4);

  eyebrowY =map(mouseY, 0, height, -10, 10);


  //glasses
  fill(#952F00);
  rect(210, 205, 40, 8);


  fill(#952F00);
  circle(190, 205, 50);

  fill(#952F00);
  circle(255, 205, 50);


  fill(#E5F4FF);
  circle(190, 205, 40);

  fill(#E5F4FF);
  circle(255, 205, 40);



  //eyes
  fill(#581300);
  circle(190 + eyeX, 205 + eyeY, 20);

  fill(#581300);
  circle(255 + eyeX, 205+ eyeY, 20);

  println(mouseX + "," + mouseY);

  //nose
  fill(#FFCC95);
  triangle(222, 226, 216, 240, 228, 238);

  //mouth
  fill(#FF4D86);
  ellipse(220 + eyeX, 262 + eyeY, 40, 20);

  textSize(40);
  text("mansi", 170, 350);
}


void mousePressed() {
  eyeX = random (-15, 15);
  eyeY = random (-10, 10);
}

int x = 0;
void draw_face() {
  background(204);
  if (x < 100) {
    line(x, 0, x, 100);
    x = x + 1;
  } else {
    noLoop();
  }
  // Saves each frame as screen-0001.tif, screen-0002.tif, etc.
  //saveFrame(); 
}

