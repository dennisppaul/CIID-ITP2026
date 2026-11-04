int myValue = 5;
float[] myList = {90, 40, 30, 60, 70}; //Andrew, Matilde, Nelson, Vivek
int listSize = myList.length;

color[] myPalette = {#cdb4db, #ffc8dd, #ffafcc, #bde0fe, #a2d2ff};

void setup() {
  size(400, 400);
  background(0);
  rectMode(CENTER);

  //stroke(255, 0, 0);
  noStroke();
  frameRate(1);
}

void draw() {
  background(0);
  //for (int index = 0; index < listSize; index++) {
  //  myList[index]+=1.5; // x+= 0.1 ---> x = x + 0.1 // x++
  //}


  for (int index = 0; index < listSize; index++) {
    //myList[index]+=0.5;
    println(myList[index]);
    float rectSize = myList[index];
    fill(myPalette[int(random(0,listSize))]);
    rect(index*50*1.1+100, height/2, rectSize, rectSize);
  }
}
