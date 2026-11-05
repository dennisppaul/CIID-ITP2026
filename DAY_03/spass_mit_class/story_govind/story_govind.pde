PImage photo;
PShape water;
PFont fontTitle;
PShape waterBird;
ArrayList<WaterParticle> waterParticles;
float scaleX;
float scaleY;

class WaterParticle {
    PShape shapeRef;
    PVector pos;
    PVector basePos;
    float noiseSeed;
    float scaleFactor;

    WaterParticle(PShape shape, int index) {
        shapeRef = shape;
        noiseSeed = index*0.15;
        pos = new PVector(0, 0);
    }

        void update() {
            // 3. Updated each frame with wave drift math (e.g., oscillating between -10 and +10)
            pos.x = sin(frameCount * 0.05)*random(0,1)*2 ;
            pos.y = cos(frameCount * 0.05)*random(0,1)*2 ;
        }

        void display() {
            pushMatrix();
            // 4. Used here to nudge the shape relative to its original SVG position
            translate(pos.x, pos.y);
            shape(shapeRef, 0, 0);
            popMatrix();
        }
    }


    void setup() {
        size(1024, 681, P2D);
        //fullScreen();
        photo = loadImage("bg.jpg");

        fontTitle = loadFont("AcademyEngravedLetPlain-48.vlw");
        waterBird = loadShape("waterbird.svg");

        // 1. Load the main traced SVG
        water = loadShape("bg.svg");
        
        float svgWidth = water.width;
        float svgHeight = water.height;
        
        scaleX=(float)width/svgWidth;
        scaleY=(float)height/svgHeight;

        // 2. Count child paths produced by Image Trace
        PShape w = water;
        if (water.getChildCount()==1)
        {
            w=water.getChild(0);
        }
        int totalShapes = w.getChildCount();
        println("Found " + totalShapes +" traced shapes in the SVG.");

        // Declare array of water particles
        waterParticles = new ArrayList<WaterParticle>();

        for (int i = 0; i < totalShapes; i++)

        {
            PShape child = w.getChild(i);
            waterParticles.add(new WaterParticle(child, i));
        }
    }



    int frameSkip=10;
    void draw() {
        image(photo, 0, 0);
        
        
        pushMatrix();
        scale(scaleX, scaleY);
        for(WaterParticle wp : waterParticles)
        {
            if(frameCount%frameSkip==0)
        {
                wp.update();
        }
                 wp.display();
  
        }
        popMatrix();
        shape(waterBird, mouseX, mouseY, 150, 150);
        textFont(fontTitle);
       
        //shape(water, 0, 0, 2048/2, 1363/2);
        fill(255);
        text("This is a story of a little bird...", 50, 100);
       
    }
