/**
 * osc, processing and the wiimote, using darwiinremoteOSC
 * for comments or questions contact andreas schlegel, andi@sojamo.de
 */
 
import processing.opengl.*;
import javax.media.opengl.*; 
import javax.media.opengl.glu.*; 


WiiController wiiController;


GL gl; 
PGraphicsOpenGL pgl;

float w = 400;
float h = 400;
float wn = 400;
float hn = 400;
float newH = 100;
float newW = 100;
float newHn = 100;
float newWn = 100;


int ledCnt = 0;
  
void setup() {
  size(800,600,OPENGL);
  pgl = (PGraphicsOpenGL)g;
  gl = pgl.gl;
  frameRate(25);
  noStroke();
  //smooth();
  wiiController = new WiiController();
  rectMode(CENTER);
}

void mousePressed() {
  // check the battery level of the wii controller
  wiiController.requestBatterylevel();
  
  // turn force feedback of the wii controller off 
  //wiiController.forcefeedback(true);
  
}

void keyPressed() {
  // turn forc feedback of the wii controller on
  //wiiController.oscP5.send("/wii/forcefeedback",new Object[] {new Integer(1)},"127.0.0.1",5601);
  ledCnt++;
  ledCnt %=4;
  int[] t = new int[] {
    0,0,0,0  };
    t[ledCnt] = 1;    
    wiiController.led(t);

}


void draw() {
  pgl.beginGL();
  gl.glDisable(GL.GL_DEPTH_TEST);
  gl.glEnable (GL.GL_BLEND);
  gl.glBlendFunc (GL.GL_SRC_ALPHA , GL.GL_ONE);
  pgl.endGL(); 
  background(0);
  fill(255,32);
  if(wiiController.buttonB) {
    newW = 600;
    newH = 300;
  }  else {
    newW = 40;
    newH = 40;
  }
  
  if(wiiController.buttonZ) {
    newWn = 600;
    newHn = 300;
  } else {
    newWn = 40;
    newHn = 40;
  } 
 
  w += (newW-w)*0.04;
  h += (newH-h)*0.04;
  
  wn += (newWn-wn)*0.04;
  hn += (newHn-hn)*0.04;
  pushMatrix();
  translate(width/2,height/2,0);
  if(wiiController.isNunchuck) {
    translate( - width/4,0,0);
  }
  for(int i=0;i<10;i++) {
    pushMatrix();
    rotateY(wiiController.roll/(10.0+i*4));
    rotateX(wiiController.pitch/(10.0+i*4));
    rect(0,0,w+i*10,h+i*10);
    popMatrix();
  }
  popMatrix();
  
  if(wiiController.isNunchuck) {
  pushMatrix();
  translate(width/2 + width/4 + (wiiController.nX) * 50,height/2 - (wiiController.nY) * 50,0);
  for(int i=0;i<10;i++) {
    pushMatrix();
    rotateY(wiiController.nRoll/(10.0+i*4));
    rotateX(wiiController.nPitch/(10.0+i*4));
    rect(0,0,wn+i*10,hn+i*10);
    popMatrix();
  }
  popMatrix();
  }
}
