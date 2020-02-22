/**
 * osc, processing and the wiimote, using darwiinremoteOSC
 * for comments or questions contact andreas schlegel, andi@sojamo.de
 */

import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress myRemoteLocation;
float[] ir;
boolean DEBUG;

void setup() {
  size(400,400);
  frameRate(25);

  // open an udp port for listening to incoming osc messages from darwiinremoteOSC
  osc = new OscP5(this,5600);

  osc.plug(this,"ir","/wii/irdata");
  osc.plug(this,"connected","/wii/connected");

  ir = new float[12];

}

void connected(int theFlag) {
  if(theFlag==1) {
    println("wii connected");
  } 
  else {
    println("wii DISCONNECTED");
  }
}

// darwiinremoteOSC sends 12 floats containing the x,y and size values for 
// 4 IR spots the wiimote can sense. values are between 0 and 1 for x and y
// values for size are 0 and bigger. if the size is 15 or 0, the IR point is not 
// recognized by the wiimote.
void ir(
float f10, float f11,float f12, 
float f20,float f21, float f22,
float f30, float f31, float f32,
float f40, float f41, float f42
) {
  ir[0] = f10;
  ir[1] = f11;
  ir[2] = f12;
  ir[3] = f20;
  ir[4] = f21;
  ir[5] = f22;
  ir[6] = f30;
  ir[7] = f31;
  ir[8] = f32;
  ir[9] = f40;
  ir[10] = f41;
  ir[11] = f42;
}



void draw() {
  background(0);
  int[] c = new int[] {
    color(255,0,0), color(0,255,0), color(0,0,255), color(255)    };
  for(int i=0;i<12;i+=3) {
    if(DEBUG) {
      println(ir[i]+" / "+ir[i+1]+" / "+ir[i+2]);
    }
    if(ir[i+2]<15) { // a size >=15 indicates: IR point not available
      fill(c[i/3]);
      ellipse(ir[i] * width,ir[i+1] * height,(1 + ir[i+2])*10,(1+ir[i+2])*10);
    }
  }
}
