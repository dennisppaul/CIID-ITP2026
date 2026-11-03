void setup () {
  size(1060, 768);
  println("Start here");
}

void draw() {
  //hair
  noStroke ();
  fill(86, 58, 50);
  circle(500, 360, 240);
  //ellipse(413, 295, 50, 40);
  // ellipse(394, 320, 50, 40);

  beginShape();
  curveVertex(426, 331);
  curveVertex(490, 301);
  curveVertex(545, 312);
  curveVertex(594, 379);
  curveVertex(615, 328);
  curveVertex(594, 302);
  curveVertex(575, 262);
  curveVertex(546, 255);
  curveVertex(504, 224);
  curveVertex(474, 230);
  curveVertex(444, 245);
  curveVertex(448, 259);
  curveVertex(438, 268);
  curveVertex(426, 263);
  curveVertex(406, 275);
  curveVertex(379, 269);
  curveVertex(390, 287);
  curveVertex(408, 295);
  curveVertex(389, 305);
  curveVertex(374, 314);
  curveVertex(362, 339);
  curveVertex(380, 344);
  curveVertex(375, 361);
  curveVertex(366, 370);
  curveVertex(378, 377);
  curveVertex(377, 390);
  curveVertex(376, 414);
  curveVertex(387, 435);
  curveVertex(400, 418);
  endShape();

  beginShape();
  curveVertex(529, 241);
  curveVertex(545, 241);
  curveVertex(554, 247);
  curveVertex(562, 254);
  curveVertex(561, 262);
  curveVertex(578, 264);
  curveVertex(592, 266);
  curveVertex(602, 270);
  curveVertex(606, 282);
  curveVertex(610, 292);
  curveVertex(606, 306);
  curveVertex(603, 314);
  curveVertex(606, 330);
  curveVertex(618, 330);
  curveVertex(627, 334);
  curveVertex(630, 343);
  curveVertex(632, 360);
  curveVertex(615, 354);
  curveVertex(615, 367);
  curveVertex(620, 382);
  curveVertex(630, 394);
  curveVertex(625, 406);
  curveVertex(610, 398);
  curveVertex(604, 380);
  endShape();

  /*fill(86, 58, 50);
  beginShape();
  curveVertex(435, 324);
  curveVertex(436, 335);
  curveVertex(448, 322);
  curveVertex(453, 314);
  curveVertex(473, 315);
  curveVertex(489, 310);
  curveVertex(502, 314);
  curveVertex(513, 299);
  curveVertex(524, 303);
  curveVertex(530, 323);
  curveVertex(549, 324);
  curveVertex(558, 307);
  curveVertex(540, 295);
  curveVertex(483, 291);
  curveVertex(454, 298);
  curveVertex(422, 314);
  curveVertex(411, 331);
  curveVertex(407, 346);
  endShape();*/

  //ears
  fill(250, 203, 64);
  ellipse(398, 390, 30, 40);
  ellipse(600, 390, 30, 40);

  //face
  fill (255, 232, 98);
  noStroke();
  circle(500, 400, 200);
  
   fill(86, 58, 50);
  beginShape();
  curveVertex(435, 324);
  curveVertex(436, 335);
  curveVertex(448, 322);
  curveVertex(453, 314);
  curveVertex(473, 315);
  curveVertex(489, 310);
  curveVertex(502, 314);
  curveVertex(513, 299);
  curveVertex(524, 303);
  curveVertex(530, 323);
  curveVertex(549, 324);
  curveVertex(558, 307);
  curveVertex(540, 295);
  curveVertex(483, 291);
  curveVertex(454, 298);
  curveVertex(422, 314);
  curveVertex(411, 331);
  curveVertex(407, 346);
  endShape();

  //eye
  fill (0);
  circle (448, 382, 30);
  circle (545, 382, 30);

  //facial hair
  fill(90, 60, 20, 50);
  ellipse(498, 466, 132, 67);

  //mouth
  //fill (242, 77, 71);
  noFill();
  stroke(242, 77, 71);
  strokeWeight(10);
  //ellipse(491, 463, 50, 25);
  arc(498, 466, 50, 25, 0, PI);

  //eyebrows
  noFill() ;
  stroke(86, 58, 50);
  strokeWeight(10);
  strokeCap(ROUND);
  arc(444, 358, 35, 16, PI + .6, TWO_PI - .6 );
  arc(544, 358, 35, 16, PI + .6, TWO_PI - .6);

  //nose
  stroke (250, 203, 64);
  arc(497, 411, 15, 8, 0, PI, CHORD);
}

void mousePressed () {
  println("curveVertex("+ mouseX + "," + mouseY + ");");
  circle(mouseX, mouseY, 10);
  saveFrame(); 
}