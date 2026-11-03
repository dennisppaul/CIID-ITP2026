color face_color = color(227, 157, 192, 120);
float eye_position_x;
float eye_position_y;

PVector eye_position;

void setup() {
    size(1024, 768);
    noStroke();

    eye_position = new PVector(); // instantiation ( i.e create ) vector
    eye_position.x = 50;
    eye_position.y = 60;

    eye_position_x = 50;
    eye_position_y = 60;
}


void draw() {
    draw_background();
    draw_head();
    draw_ears();
    draw_eyes(width/2, height/2);
    draw_eyes(mouseX, mouseY);
}

void draw_eyes(float x, float y) {
    fill(0);
    circle(x - 50, y, 30);
    circle(x + 50, y, 30);
}

void draw_head() {
    fill(0);
    circle(eye_position.x, eye_position.y, 100);
    //    circle(eye_position_x, eye_position_y, 100);
}

void draw_ears() {
    fill(face_color);
    circle(width/2, height/2, 50);
}

void draw_background() {
    background(255);
    fill(face_color);
    circle(mouseX, mouseY, 100);
}
