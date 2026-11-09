// Tree: random fractal structure, grown depth by depth, drawn as tapered lines.

class Branch {
    Branch parent;
    ArrayList<Branch> children = new ArrayList<Branch>();
    int   depth;
    float angle;        // radians, relative to parent
    float length;
    float thickness;
    float growStart;    // seconds after tree birth
    float growDuration;
    // geometry in tree space (trunk base at 0,0, untilted), used when the branch breaks off
    float baseX, baseY;
    float absAngle;
    boolean attached = true;

    Branch(Branch parent, float angle, float length, float thickness, float growStart, float growDuration) {
        this.parent = parent;
        this.angle = angle;
        this.length = length;
        this.thickness = thickness;
        this.growStart = growStart;
        this.growDuration = growDuration;
        if (parent == null) {
            depth = 0;
            absAngle = angle;
            baseX = 0;
            baseY = 0;
        } else {
            depth = parent.depth + 1;
            absAngle = parent.absAngle + angle;
            baseX = parent.tipX();
            baseY = parent.tipY();
        }
    }

    float tipX() {
        return baseX + length * sin(absAngle);
    }

    float tipY() {
        return baseY - length * cos(absAngle);
    }

    float progress(float age) {
        return constrain((age - growStart) / growDuration, 0, 1);
    }

    boolean isOnTree() {
        for (Branch b = this; b != null; b = b.parent) {
            if (!b.attached) {
                return false;
            }
        }
        return true;
    }
}

class Tree {
    float baseX, baseY;
    float age;           // seconds since birth
    float growDuration;  // seconds until the last tip is fully grown
    Branch root;
    ArrayList<Branch> branches = new ArrayList<Branch>();
    ArrayList<Branch> candidates = new ArrayList<Branch>();
    float[] levelStart = new float[TREE_DEPTH + 1]; // when the first branch of each depth starts growing
    int attachedCount;                               // branches still on the tree

    Tree(float baseX, float baseY) {
        this.baseX = baseX;
        this.baseY = baseY;
        for (int d = 0; d <= TREE_DEPTH; d++) {
            levelStart[d] = Float.MAX_VALUE;
        }
        float levelTime = GROW_TIME / (TREE_DEPTH + 1);

        root = new Branch(null, 0, height * TRUNK_LENGTH, height * TRUNK_THICKNESS, 0, levelTime);
        branches.add(root);

        // breadth first, so the branch cap trims the finest tips evenly instead of one side
        for (int i = 0; i < branches.size(); i++) {
            Branch b = branches.get(i);
            growDuration = max(growDuration, b.growStart + b.growDuration);
            levelStart[b.depth] = min(levelStart[b.depth], b.growStart);
            if (b.depth >= TREE_DEPTH) {
                continue;
            }
            int n = random(1) < THREE_CHILD_CHANCE ? 3 : 2;
            float spread = radians(random(SPREAD_MIN_DEG, SPREAD_MAX_DEG));
            for (int k = 0; k < n; k++) {
                if (branches.size() >= MAX_BRANCHES) {
                    break;
                }
                if (b.depth >= 2 && random(1) < MISSING_BRANCH_CHANCE) {
                    continue;
                }
                float a = (n == 2) ? (k == 0 ? -spread : spread) : (k - 1) * spread;
                a += radians(random(-ANGLE_JITTER_DEG, ANGLE_JITTER_DEG));
                Branch c = new Branch(b, a,
                    b.length * random(LENGTH_RATIO_MIN, LENGTH_RATIO_MAX),
                    max(MIN_THICKNESS_PX, b.thickness * THICKNESS_RATIO),
                    b.growStart + b.growDuration,
                    levelTime * random(0.8, 1.2));
                b.children.add(c);
                branches.add(c);
            }
        }
        attachedCount = branches.size();
    }

    void draw(float tilt, float alpha) {
        pushMatrix();
        translate(baseX, baseY);
        rotate(tilt);
        drawBranch(root, age, alpha);
        popMatrix();
    }

    // a random larger limb that is still on the tree, or null if none is left
    Branch pickLimbToBreak() {
        candidates.clear();
        for (Branch b : branches) {
            if (b.depth >= 1 && b.depth <= BREAK_MAX_DEPTH && b.isOnTree()) {
                candidates.add(b);
            }
        }
        if (candidates.isEmpty()) {
            return null;
        }
        return candidates.get((int) random(candidates.size()));
    }
}

// b plus its descendants that are still attached (limbs that fell earlier are already subtracted)
int countBranches(Branch b) {
    int n = 1;
    for (Branch c : b.children) {
        if (c.attached) {
            n += countBranches(c);
        }
    }
    return n;
}

// Draws b and its attached children. Expects the current transform at b's base,
// oriented like b's parent.
void drawBranch(Branch b, float age, float alpha) {
    float p = b.progress(age);
    if (p <= 0) {
        return;
    }
    pushMatrix();
    rotate(b.angle);
    strokeWeight(b.thickness);
    stroke(BRANCH_COLOR, 255 * alpha);
    line(0, 0, 0, -b.length * p);
    if (p >= 1) {
        translate(0, -b.length);
        for (Branch c : b.children) {
            if (c.attached) {
                drawBranch(c, age, alpha);
            }
        }
    }
    popMatrix();
}
