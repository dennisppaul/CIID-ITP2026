PVector a_position;
String name;

void setup() {
    size(1024, 768);
    noStroke();
    a_position = new PVector();
    name = new String("Jose");
    name = "Jose"; // short version to `new` a string
    println(name);
    println(name.length());
    for (int i = 0; i < name.length(); i++) {
        char c = name.charAt(i);
        println(c);
    }
}

void draw() {
    background(255);
    fill(0, 127, 255);
    circle(width/2, height/2, 100);
}
