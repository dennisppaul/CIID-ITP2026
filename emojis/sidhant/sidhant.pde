color facecolor = #EAD095;
int eyesOffsetX, eyesOffsetY, eyeSquint=0;
void setup() {
  size(640, 640);
}

void draw() {
  background(255);

  noStroke();

  fill(0);
  rectMode(CENTER);
  rect(width/2, height/2-20, 100, 135, 25, 25, 17, 17);


  fill(facecolor);
  rect(width/2, height/2, 100, 135, 25, 25, 30, 30);

  fill(0);
  rectMode(CENTER);
  rect(width/2, height/2-70, 70, 30, 0, 0, 20, 20);

  fill(#FFFFFF, 70);
  strokeWeight(2);
  stroke(0);
  arc(width/2-22, height/2-18, 40, 40, 0, PI+QUARTER_PI, CHORD);
  //circle(width/2-22, height/2-20, 34);
  circle(width/2+22, height/2-20, 34);
  line(width/2-3, height/2-18, width/2+5, height/2-18);

  fill(#000000);
  noStroke();
  eyesOffsetX = int(map(mouseX, 0, width, -8, 8));
  eyesOffsetY = int(map(mouseY, 0, height, -8, 8));
  ellipse(width/2-22+eyesOffsetX, height/2-20+eyesOffsetY, 17, 17);
  ellipse(width/2+22+eyesOffsetX, height/2-20+eyesOffsetY, 17, 17);
  
  fill(#B27E0E,80);
  triangle(319 ,313, 332, 335,315, 334);
  
  noStroke();
  fill(#C5CACB,90);
  rect(width/2, height/2+25, 55, 10, 17, 17, 0, 0);

  fill(#FF678D,75);
  rect(width/2, height/2+40, 45, 10, 17, 17, 17, 17);
  
  fill(#C5CACB,95);
  rect(width/2, height/2+63, 90, 10, 20, 20, 20, 20);
  rect(width/2-45, height/2+48, 10, 30, 20, 20, 100,100);
  rect(width/2+45, height/2+48, 10, 30, 20, 20, 100, 100);
  
}


