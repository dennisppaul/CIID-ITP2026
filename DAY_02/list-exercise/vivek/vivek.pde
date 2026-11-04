int W = 400;
int H = 400;
ArrayList<PVector> vertices = new ArrayList<PVector>();

void setup() {
    size(400, 400);
    noLoop();

    hairCoords();
}

void draw() {
    background(220);
    strokeWeight(4);

    fill(#e8b459);
    face();

    fill(100);
    beginShape();
    // curveVertex needs the neighbouring points repeated to close smoothly
    int n = vertices.size();
    PVector last = vertices.get(n - 1);
    curveVertex(last.x, last.y);
    for (PVector v : vertices) {
        curveVertex(v.x, v.y);
    }
    PVector first = vertices.get(0);
    PVector second = vertices.get(1);
    curveVertex(first.x, first.y);
    curveVertex(second.x, second.y);
    endShape();
}

void face() {
    arc(W/2, H/2, 150, 300, 0, PI);
}

void hairCoords() {
    for (int i = 70, j = 70; i <= 290; i += 10, j += 10) {
        float x1 = sin(radians(i)) * 100 + W/2;
        float y1 = cos(radians(i)) * 100 + H/2;

        float x2 = sin(radians(j)) * 70 + W/2;
        float y2 = cos(radians(j)) * 70 + H/2;

        vertices.add(new PVector(x1, y1));
        vertices.add(new PVector(x2, y2));
    }
}
