import oscP5.*;
import netP5.*;
import java.io.UnsupportedEncodingException;

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
  byte[] bytes = theOscMessage.getBytes();
  try {
      String str = new String(bytes, "UTF-8");
      String typeTagStr = theOscMessage.typetag();
      str = str.substring(str.indexOf(typeTagStr) + typeTagStr.length());
 
      //コンソールにMax6から送った日本語のメッセージが表示される
      print("### received an osc message.");
      print(" addrpattern: "+theOscMessage.addrPattern());
      println(" typetag: "+ str);
 
    }
    catch(UnsupportedEncodingException e) {
        e.printStackTrace();   
    };

  //theOscMessage.print();
}
