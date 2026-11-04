final int NUM_CIRCLE_X = 100;
final int NUM_CIRCLE_Y = 100;

color[] colors = { // thx nicha
    #FFF38A,
    #FE450C,
    #78CBD3,
    #B3489C,
    #DCDCDC
};
int color_counter = 0;

float[][] circle_sizes = new float[NUM_CIRCLE_X][NUM_CIRCLE_Y];

void setup() {
    size(1024, 768);
    noStroke();

    blendMode(MULTIPLY);

    fill_size_buffer_random(20.0, 20.0);
}

void fill_size_buffer_random(float min, float max) {
    for (int x = 0; x < NUM_CIRCLE_X; x++) {
        for (int y = 0; y < NUM_CIRCLE_Y; y++) {
            circle_sizes[x][y] = random(min, max);
        }
    }
}

void fill_size_buffer_noise(float noiseScale, float x_offset, float y_offset, float min, float max) {
    for (int x = 0; x < NUM_CIRCLE_X; x++) {
        for (int y = 0; y < NUM_CIRCLE_Y; y++) {
            circle_sizes[x][y] = min + max * noise((x + x_offset) * noiseScale, (y + y_offset) * noiseScale);
        }
    }
}

void draw() {
    background(255);

    //    float noise_scale = map(mouseX, 0, width, 0.1, 1.0);
    //    println(noise_scale);
    float noise_scale = 0.15;
    fill_size_buffer_noise(noise_scale, frameCount * 0.05, frameCount * 0.033, 2, 10);

    int individual_color_counter = 0;
    for (int x = 0; x < NUM_CIRCLE_X; x++) {
        for (int y = 0; y < NUM_CIRCLE_Y; y++) {
            float x_spacing = float(width) / float(NUM_CIRCLE_X);
            float y_spacing = float(height) / float(NUM_CIRCLE_Y);
            float x_pos = x * x_spacing + x_spacing / 2;
            float y_pos = y * y_spacing + y_spacing / 2;
            individual_color_counter++;
            individual_color_counter %= colors.length;
            fill(colors[individual_color_counter]);
            float circle_size = circle_sizes[x][y];
            //            float circle_size = random(1.0, 50.0);
            circle(x_pos, y_pos, circle_size);
        }
    }
}

void keyPressed() {
    if (key == '1') {
        fill_size_buffer_random(20, 50);
    }
    if (key == '2') {
        fill_size_buffer_random(10, 100);
    }
    if (key == '3') {
    }
    if (key == ' ') {
        color_counter++;
        color_counter %= colors.length;

        //        color_counter = color_counter + 1;
        //        color_counter = color_counter % colors.length;

        // 0 % 5 = 0
        // 1 % 5 = 1
        // 2 % 5 = 2
        // 3 % 5 = 3
        // 4 % 5 = 4
        // 5 % 5 = 0
        // 6 % 5 = 1
        // 7 % 5 = 2
        // ...

        //        if (color_counter >= colors.length) {
        //            color_counter = 0;
        //        }
    }
}
