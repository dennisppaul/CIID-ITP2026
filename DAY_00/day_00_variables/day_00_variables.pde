final float SIZE_MODIFIER_CONST = 10; // constant value
float size_of_circle = 100.0; // global in snake case
float sizeOfCircle = 100.0;   // global in camel case

void setup() {
    size(1024, 768);
    float size_modifier = SIZE_MODIFIER_CONST;
    size_of_circle = size_of_circle + size_modifier;
}


void draw() {
    circle(312, 384, size_of_circle);
    circle(512, 384, size_of_circle);
    circle(712, 384, size_of_circle);
}
