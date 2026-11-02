float   sum_of_two_numbers = 2.0;
int     another_value      = 3;
boolean one_of_two_values  = true;

void setup() {
    size(1024, 768);

    sum_of_two_numbers = add_two_numbers(100.0, 27.0);
    println(sum_of_two_numbers);
    println(add_two_numbers(1, 2));
    println(add_two_numbers(100, 200));
    println(add_two_numbers(10, 30));
}

void draw() {
    background(255);

    circle(512, 384, sum_of_two_numbers);
}

float add_two_numbers(float a, float b) {
    // a = 100, b = 27
    float my_result;
    my_result = a + b; // 127 = 100 + 27
    return my_result; // 127
}
