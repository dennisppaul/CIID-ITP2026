void draw_face(float face_position_x, float face_position_y) {
    draw_head(face_position_x, face_position_y);
    draw_eyes(face_position_x, face_position_y);
}

void draw_head(float x, float y) {
    fill(255, 100, 100);
    circle(x, y, 200);
}

void draw_eyes(float x, float y) {
    fill (255);
    circle(x - 60, y - 30, 50);
    circle(x + 60, y - 30, 50);
}
