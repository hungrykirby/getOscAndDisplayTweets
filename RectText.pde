class RectText {
  String t;
  String textModified;
  StringList sl;
  float xPos, yPos;
  
  color borderColor, backgroundColor, fontColor;
  
  float paddingLeft, paddingRight, paddingButtom, paddingTop;
  
  PFont pF;
  
  float th; //text height
  float le; //leading
  
  int numLines;
  float maxWidth; //max width of text
  float minWidth;
  
  boolean isDraw;
  
  int kaigyoCount;
  int sW = 2;
  
  int tS;
  
  RectText(){
    tS = 48;
    PFont font = createFont("Noto Sans CJK JP", 48);
    textFont(font);
    textAlign( LEFT, TOP );    
    th = textAscent() + textDescent();
    le = 0.5;
    textLeading(th+le);
    noStroke();
    fontColor = color(255, 0, 0);
    backgroundColor = color(0);
    borderColor = color(0, 255, 0);
    isDraw = false;
    t = "";
    kaigyoCount = 0;
    numLines = 0;
  }
  
  void setText(String _t){
    /*文章を挿入する関数*/
    t = _t;
  }
  
  void setTextSize(int _ts){
    //文字サイズを指定している。
    tS = _ts;
    textSize(tS);
    th = textAscent() + textDescent();
    le = 0.5;
    textLeading(th+le);
  }
  
  void setColor(color _fontColor, color _backgroundColor, color _borderColor){
    /*色を定義する
    第一引数が文字色
    第二引数が背景色
    第三引数が背景枠の色*/
    fontColor = _fontColor;
    backgroundColor = _backgroundColor;
    borderColor = _borderColor;
  }
  
  color getBGColor(){
    return backgroundColor;
  }
  
  String getText(){
    /*文章を返す関数*/
    return t;
  }
  
  int getStrokeWeight(){
    return sW; //適時追加しているが、これとかいらんだろ。
  }
  
  void setup(float pT, float pR, float pB, float pL){
    /*paddingを指定するsetup関数*/    
    paddingTop = pT; paddingRight = pR; paddingButtom = pB; paddingLeft = pL;
  }
  
  void update(float w){
    //文字列を成型している。
    //適切な位置に改行をはさんだりするのはこの関数の役目
    textSize(tS);
    maxWidth = calcMaxW(t, w);
    kaigyoCount = 1;
    sl = wordWrap(t, maxWidth);
    kaigyoCount = kaigyoCount + countStringInString(t, "\n"); //文章で新しく作った改行＋もとからある改行の数
    numLines = sl.size();
    textModified = "";
    for(int i = 0; i < numLines; i++){
      textModified += (sl.get(i) + "\n");
    }
  }
  void forceSetMaxW(float w){
    //昔バグがあったので使ったが、今は使っていない。
    maxWidth = w;
  }
  float draw(float x, float y){
    /*
    xとyを開始点として文字を書く
    返り値でテキスト枠下のy座標を返している。
    forループするの時に、次のループに前の返り値を渡せばきれいに並ぶ(はず)
    */
    xPos = x; yPos = y;
    stroke(borderColor);
    strokeWeight(sW);
    fill(backgroundColor);
    textSize(tS);
    th = textAscent() + textDescent();
    le = 0.5;
    textLeading(th+le);
    rect(xPos - paddingRight, yPos - paddingTop, maxWidth + paddingRight + paddingLeft, (th+le)*(kaigyoCount) + paddingTop + paddingButtom);
    noStroke();
    fill(fontColor);
    text(textModified, xPos, yPos);
    
    return (th+le)*(kaigyoCount) + paddingButtom + paddingTop + yPos; //Buttom
  }
  
  StringList wordWrap(String s, float mW) {
    /*
    * 一文字ずつ見て行って、テキスト枠を幅を超えるときそこに改行を入れて、枠からはみ出さないようにする
    * 戻り値はStringList型なので、update関数内で改行文字列に変更している。
    */
    textSize(tS);
    StringList a = new StringList();
    float w = 0;
    int i = 0;
    while (i < s.length()) {
      char c = s.charAt(i);
      //println(c);
      String cc = "" + c;
      w += textWidth(cc);
      if(c == '\n'){
        String sub = s.substring(0, i);
        a.append(sub);
        s = s.substring(i + 1, s.length());
        i = 1;
        w = 0;
        //kaigyoCount += 1;
      }else{
        if (w > mW) {
          String sub = s.substring(0, i);
          a.append(sub);
          s = s.substring(i ,s.length());
          i = 0;
          w = 0;
          kaigyoCount += 1;
        } else {
          i++;
        }
      }
    }
    a.append(s);
    return a; 
  }
  
  float calcMaxW(String _t, float mW){
    textSize(tS);
    float f = 0;
    if(textWidth(_t) > mW) f = mW;
    else f = textWidth(_t);
    return f;
  }
  int countStringInString(String target, String searchWord) {
    return (target.length() - target.replaceAll(searchWord, "").length()) / searchWord.length();
  }
}
