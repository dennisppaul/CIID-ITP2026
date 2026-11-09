// Falling limbs: a branch breaks off with everything attached, falls, spins and fades.

class FallingLimb {
    Branch branch;
    float x, y;     // screen position of the limb's base
    float angle;    // screen angle of the limb
    float vx, vy;
    float spin;
    float alpha = 1;

    FallingLimb(Branch branch, float x, float y, float angle) {
        this.branch = branch;
        this.x = x;
        this.y = y;
        this.angle = angle;
        float outward = sin(angle) >= 0 ? 1 : -1; // tip over away from the trunk
        vx = outward * random(0.3, 1) * LIMB_PUSH * height;
        vy = 0;
        spin = outward * radians(random(LIMB_SPIN_MIN, LIMB_SPIN_MAX));
    }

    void update(float dt) {
        vy += GRAVITY * height * dt;
        x += vx * dt;
        y += vy * dt;
        angle += spin * dt;
        alpha -= dt / LIMB_FADE_TIME;
    }

    boolean isGone() {
        return alpha <= 0 || y > height * 2;
    }

    void draw() {
        pushMatrix();
        translate(x, y);
        rotate(angle - branch.angle); // drawBranch() adds branch.angle back
        drawBranch(branch, Float.MAX_VALUE, alpha);
        popMatrix();
    }
}

// Detaches a random larger limb and lets it fall. Returns false if none is left.
boolean breakRandomLimb() {
    Branch b = tree.pickLimbToBreak();
    if (b == null) {
        return false;
    }
    b.attached = false;
    // tree space -> screen: rotate by the current tilt around the trunk base
    float c = cos(tilt);
    float s = sin(tilt);
    float wx = tree.baseX + b.baseX * c - b.baseY * s;
    float wy = tree.baseY + b.baseX * s + b.baseY * c;
    limbs.add(new FallingLimb(b, wx, wy, tilt + b.absAngle));
    tree.attachedCount -= countBranches(b);
    soundLimbBreak(b, wx);
    return true;
}

void updateLimbs(float dt) {
    for (int i = limbs.size() - 1; i >= 0; i--) {
        FallingLimb l = limbs.get(i);
        l.update(dt);
        if (l.isGone()) {
            limbs.remove(i);
        }
    }
}

void drawLimbs() {
    for (FallingLimb l : limbs) {
        l.draw();
    }
}
