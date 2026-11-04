IntList colourList; // do not use FloatList

void setup() {
    size(400, 400);
    colourList = new IntList();
    colourList.append(#ff10CD);
    colourList.append(#D10F4C);
}

void draw() {
    background(10, 10, 255);
    size(400, 400);

    for (int i = 120; i < 200; i = i+10) {
        for (int j = 0; j<320; j= j+20) {
            fill(colourList.get(1));
            ellipse(j*0.8+20, i*0.8+20, j+10, i+10);
        }
    }
}
