class FmRing {
    PVector pos;      
    float rad;        
    float alpha;      
    float growSpeed;  
    float fadeSpeed;  
    boolean isAlive;

    FmRing(float x, float y) {
        pos = new PVector(x, y);
        rad = 10;
        alpha = 255;
        growSpeed = 10;
        fadeSpeed = 4;
        isAlive = true;
    }

    void update() {
        rad += growSpeed;
        alpha -= fadeSpeed;

        // once it's invisible there's no reason to keep it
        if (alpha <= 0) {
            isAlive = false;
        }
    }

    void display() {
        noStroke();
        fill(255, 0, 0, alpha);
        circle(pos.x, pos.y, rad);
    }
}
