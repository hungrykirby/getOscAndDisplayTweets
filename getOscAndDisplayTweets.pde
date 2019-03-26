/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int receivePort = 8002;
String sendIP = "127.0.0.1";
int sendPort = 8001;

void setup() {
  size(400,400);
  frameRate(25);
  oscP5 = new OscP5(this,receivePort);
  myRemoteLocation = new NetAddress(sendIP,sendPort);
}


void draw() {
  background(0);  
}


void oscEvent(OscMessage theOscMessage) {
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());

  theOscMessage.print();
}
