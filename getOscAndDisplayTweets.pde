import oscP5.*;
import netP5.*;
import java.io.UnsupportedEncodingException; //エラーを出すために必要なやつ

OscP5 oscP5;
NetAddress myRemoteLocation;

int receivePort = 8002;
String sendIP = "127.0.0.1";
int sendPort = 8001;

int startIndex = 0;
RectText[] tweets;
final int tweetsNum = 30;

void setup() {
  //size(400,400);
  fullScreen();
  frameRate(25);
  oscP5 = new OscP5(this,receivePort);
  myRemoteLocation = new NetAddress(sendIP,sendPort);
  
  tweets = new RectText[tweetsNum];
  
  for(int i = 0; i < tweetsNum; i++){
    tweets[i] = new RectText();
    tweets[i].setColor(color(30), color(random(230, 255), random(230, 255), random(230, 255), 160), color(10));
    tweets[i].setup(30, 50, 30, 30);/*float pT, float pR, float pB, float pL*/
  }
}


void draw() {
  background(255);
  float y = 30;
  int wTextArea = 1706-900-50-30+200;
  int xPos = 1050 + 50 + 500;
  for(int i = 0; i < tweetsNum; i++){
    tweets[i].update(wTextArea);
    tweets[i].forceSetMaxW(wTextArea);
    y = tweets[i].draw(xPos, y);
  }
}


void oscEvent(OscMessage theOscMessage) {
  print("### received an osc message.");
  println(" addrpattern: "+theOscMessage.addrPattern());
  if(theOscMessage.checkAddrPattern("/text")==true) {
    byte[] bytes = theOscMessage.getBytes();
    try {
      String t = new String(bytes, "UTF-8");
      String typeTagStr = theOscMessage.typetag();
      t = t.substring(t.indexOf(typeTagStr) + typeTagStr.length());
      println("Tweet:"+t);
      if(startIndex == 0){
        for(int i = tweets.length - 1; i > 0; i--){
          tweets[i].setText(tweets[i - 1].getText());
          tweets[i].setColor(tweets[i - 1].fontColor, tweets[i - 1].backgroundColor, tweets[i - 1].borderColor);
        }
        tweets[0].setText(t);
        tweets[0].setColor(color(30), color(random(230, 255), random(230, 255), random(230, 255), 160), color(10));
      }
      //allTexts = append(allTexts, t);
    }
    catch(UnsupportedEncodingException e) {
        e.printStackTrace();  
    }
  }
}
