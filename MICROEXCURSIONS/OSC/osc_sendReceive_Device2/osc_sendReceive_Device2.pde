/*
OSC TWO WAY: DEVICE TWO
Based on the oscP5 examples by Andreas Schlegel.
oscP5 website: http://www.sojamo.de/oscP5

WHAT IT DOES
 - SENDS:    when the mouse moves, it sends "/mouse" (x, y) to Device One.
 - RECEIVES: "/click" from Device One, and changes the circle to a random color.

HOW TO USE IT
1. Install the oscP5 library (Sketch > Import Library > Manage Libraries).
2. Run deviceOne and deviceTwo (the order does not matter).
3. Move the mouse here: the circle moves in Device One.
   Click in Device One: the circle here changes color.

KEY IDEA
Every sketch can be a sender AND a receiver at the same time.
It LISTENS on its own port, and SENDS to the other sketch's port.

Device One  listens on 12001  and sends to 12000
Device Two  listens on 12000  and sends to 12001

To use two computers, set otherDeviceIP to the IP address of the
other computer (both computers must be on the same network).
 
Tag  Type    
i    int    
f    float 
s    string
*/

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress otherDevice;   // where we send our messages

int    myPort          = 12000;        // the port THIS sketch listens on
String otherDeviceIP   = "127.0.0.1";  // "this computer", change it for two computers
int    otherDevicePort = 12001;        // the port the other device listens on

// The color of the circle in this sketch, changed every time a click arrives
color circleColor = color(255, 100, 100);

void setup() {
    size(400, 400);
    
    //Uncomment this to check your IP Address
    //println("My IP is: "+NetInfo.lan());

    // Start listening on our own port
    oscP5 = new OscP5(this, myPort);

    // The address of the other device, used when sending
    otherDevice = new NetAddress(otherDeviceIP, otherDevicePort);
}

void draw() {
    background(0);

    // this circle follows the mouse in this sketch
    fill(circleColor); //the instruction on chanigng color will ocme form the other device
    noStroke();
    ellipse(mouseX, mouseY, 40, 40);

    fill(180);
    text("DEVICE TWO", 10, 20);
    text("Listening on " + myPort + ", sending to " + otherDeviceIP + " : " + otherDevicePort, 10, 40);
    text("Move the mouse to move the circle in Device One", 10, height - 12);
}

void mouseMoved() {
    sendOSCMessage();
}

void sendOSCMessage() {
    OscMessage mouseMessage = new OscMessage("/mouse");
    mouseMessage.add(mouseX);
    mouseMessage.add(mouseY);
    oscP5.send(mouseMessage, otherDevice);
}

void oscEvent(OscMessage theOscMessage) {

    // "/click" has no values, so we only need to check the address
    if (theOscMessage.checkAddrPattern("/click")) {
        circleColor = color(random(255), random(255), random(255));
        println("Received /click, new color!");
    }
}
