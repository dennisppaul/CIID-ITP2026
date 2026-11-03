void setup() {
    size(1024, 768);
}

void draw_face(float position_x, float position_y, float face_scale, color face_color) {
    float head_size = 200 * face_scale;
    float eye_size = 20 * face_scale;
    float eye_position_x = 50 * face_scale;
    float eye_position_y = 50 * face_scale;

    noStroke();
    fill(face_color);
    circle(position_x, position_y, head_size);
    fill(255);
    circle(position_x - eye_position_x, position_y - eye_position_y, eye_size);
    circle(position_x + eye_position_x, position_y - eye_position_y, eye_size);
}

void draw() {
    background(255);
    
    float current_face_scale = map(mouseX, 0, width, 0.5, 4);
    draw_face(width / 2 - 200, height / 2, current_face_scale, color(255, 0, 0, 127));
    
    float current_face_scale2 = map(mouseY, 0, height, 0.5, 4);
    draw_face(width / 2 + 200, height / 2, current_face_scale2, color(0, 255, 0, 127));
}
