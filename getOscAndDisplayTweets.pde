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
RectText title;
final int tweetsNum = 30;

final color baseColor = color(0, 172, 237);

final int pT = 30;
final int pR = 80;
final int pB = 30;
final int pL = 30;
PImage twitterIcon;

void setup() {
  //size(400,400);
  fullScreen();
  frameRate(25);
  oscP5 = new OscP5(this,receivePort);
  myRemoteLocation = new NetAddress(sendIP,sendPort);
  twitterIcon = loadImage("Twitter_Social_Icon_Circle_Color.png");
  imageMode(CENTER);
  
  tweets = new RectText[tweetsNum];
  
  for(int i = 0; i < tweetsNum; i++){
    tweets[i] = new RectText();
    tweets[i].setColor(color(30), color(random(230, 255), random(230, 255), random(230, 255), 160), baseColor);
    tweets[i].setup(pT, pR, pB, pL);/*float pT, float pR, float pB, float pL*/
    tweets[i].setTextSize(48);
  }
  
  title = new RectText();
  title.setColor(color(255), baseColor, baseColor);
  title.setup(30, 30, 30, 30);
  title.setTextSize(120); 
  title.setText("#ほしまるまつ");
  //title.setText("プレミアムフライデー");
}


void draw() {
  background(255);
  float y = 400;
  int wTextArea = width - 750;
  int xPos = 500;
  int winOfRect = 30;
  int intervalOfRectAndRect = 20;
  int dCircleLeft = 120;
  
  int xLine = 150;
  int wLine = 10;
  
  title.setTextSize(120);
  title.update(1600);
  float titleY = title.draw(80, 80);
  
  fill(baseColor);
  rect(xLine, titleY - 30, wLine, height - titleY + 30);
  
  
  for(int i = 0; i < tweetsNum; i++){
    float tmpY = y;
    tweets[i].update(wTextArea);
    tweets[i].forceSetMaxW(wTextArea);
    fill(baseColor);
    ellipse(xLine + wLine/2, tmpY + 20, dCircleLeft, dCircleLeft);
    image(twitterIcon, xLine + wLine/2, tmpY + 20, dCircleLeft, dCircleLeft);  
    
    tweets[i].setTextSize(48);
    y = tweets[i].draw(xPos, y);
    int sW = tweets[i].getStrokeWeight();
    color bgc = tweets[i].getBGColor();
    float _hue = hue(bgc);
    float _s = saturation(bgc);
    float _b = brightness(bgc);
    colorMode(HSB);
    fill(color(_hue, _s + 50.0, _b));
    colorMode(RGB);
    //ellipse(xPos - pR, tmpY - pB, 10, 10);
    rect(xPos - winOfRect - pR, tmpY - pB - sW, winOfRect, y - tmpY + sW*2);
    
    triangle(xPos - winOfRect - pR, tmpY - pB + 20, xPos - winOfRect - pR, y - pB - 20, xLine + 80, tmpY + pB);
    
    y += intervalOfRectAndRect;
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
        tweets[0].setTextSize(48);
        tweets[0].setText(t);
        color textBoxColor = color(random(230, 255), random(230, 255), random(230, 255), 160);
        tweets[0].setColor(color(30), textBoxColor, textBoxColor);
      }
      //allTexts = append(allTexts, t);
    }
    catch(UnsupportedEncodingException e) {
        e.printStackTrace();  
    }
  }
  if(theOscMessage.checkAddrPattern("/created_at")){
   String ca = theOscMessage.get(0).stringValue();
    println(ca);
  }
}
