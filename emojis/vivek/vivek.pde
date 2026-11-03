final int W = 400;
final int H = 400;

void settings() {
  size(W, H);
}

void draw() {
  background(220);

  eyes();
  mouth("surprise");
  nose();
}

void nose() {
  circle(W / 2, H / 2 + 50, 50);
}

void mouth(String type) {
  if (type.equals("smile")) {
    fill(255);
    arc(W / 2, H / 2 + 100, 300, 100, 0, PI, CHORD);
  }
  if (type.equals("surprise")) {
    fill(255);
    arc(W / 2, H / 2 + 150, 50, 80, 0, TWO_PI, CHORD);
  }
}

void eyes() {
  // left & right eye
  fill(#FFFFFF);
  arc(W / 4, H / 2, 100, 200, PI, TWO_PI, CHORD);        // left white eye
  arc(W / 4 + 200, H / 2, 100, 200, PI, TWO_PI, CHORD);  // right white eye

  fill(#000000);
  arc(                                                   // left black eye
    map(mouseX, 0, W, W / 4 - 20, W / 4 + 20),
    H / 2, 50, 100, PI, TWO_PI, CHORD
  );
  arc(                                                   // right black eye
    map(mouseX, 0, W, W / 4 + 180, W / 4 + 220),
    H / 2, 50, 100, PI, TWO_PI, CHORD
  );
}
