class varBox{
  PImage BGnd;
  float value,barPos,maxL;
  PVector pos,dim;
  boolean hoover,focus;
  int varCase;
  String text;
  int index,lines;
  color selection;
  PApplet parent;
  
  varBox(float x,float y){  }
  
  varBox(PApplet par,float x,float y,int type){
    if(type==1){  BGnd = loadImage("/Images/text250.png");  }
    else if(type==2){  BGnd = loadImage("/Images/int5.png");  }
    else if(type==3){  BGnd = loadImage("/Images/yesNo.png");  }
    else if(type==4){  BGnd = loadImage("/Images/Phone.png");  }
    else if(type==5){  BGnd = loadImage("/Images/text400.png");  }
    else if(type==6){  BGnd = loadImage("/Images/2text400.png");  }
    else if(type==7){  BGnd = loadImage("/Images/4text400.png");  }
    else if(type==8){  BGnd = loadImage("/Images/4text800.png");  }
    else if(type==9){  BGnd = loadImage("/Images/date.png");  }
    else if(type==10){  BGnd = loadImage("/Images/color.png");  }
      dim = new PVector(BGnd.width,BGnd.height);
    value = 0;
    pos = new PVector(x,y);
    hoover = false;  focus = false;  varCase = type;
    text = "";  index = 0;  lines = 1;
    barPos = 0;  maxL = dim.x-10;
    parent = par;
  }
  
  void draw(){
    parent.image(BGnd,pos.x,pos.y);
    parent.text(text,pos.x + 5,pos.y + 23);
    if(focus&&parent.frameCount%30<20){  parent.line(pos.x+barPos+5,pos.y+7,pos.x+barPos+5,pos.y + 24);  }
  }
  
  void check(){ if(parent.mouseX>pos.x&&parent.mouseX<pos.x+dim.x&&parent.mouseY>pos.y&&parent.mouseY<pos.y+dim.y){  hoover = true;  }else{  hoover = false;  }  }
  void check(int offset){ if(parent.mouseX>pos.x&&parent.mouseX<pos.x+dim.x&&(parent.mouseY+offset)>pos.y&&(parent.mouseY+offset)<pos.y+dim.y){  hoover = true;  }else{  hoover = false;  }  }
  
  void set(){  if(hoover){  focus = true;  }else{  setValue();  focus = false;  }  }
  
  void write(){check();draw();}
  void write(int offset){check(offset);draw();}
  
  void read(KeyEvent e,boolean S,boolean C,boolean CL,boolean AC) {
      if (!focus) return;
      int a = e.getKeyCode();
      //println(a);
      switch (a) {
        case 8:  if (index > 0) del();  break;
        case 9:  break;  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Poner lógica para ciclar el focus
        case 10:  focus = false;  break;
        
        case 16:  break;
        case 17:  break;
        case 18:  break;
        case 20:  break;
        case 32: handleCase((char)32);  break;
        case 44: if(S){  handleCase((char)59);  }else{handleCase((char)a);}  break;
        case 45: if(S){  handleCase((char)95);  }else{handleCase((char)a);}  break;
        case 46: if(S){  handleCase((char)58);  }else{handleCase((char)a);}  break;
        case 153: if(S){  handleCase((char)62);  }else{handleCase((char)60);}  break;
        case 37:  if (index > 0) hidari();  break;
        case 39:  if (index < text.length()) tadashi();  break;
        case 106: handleCase((char)42);  break;
        case 107: handleCase((char)43);  break;
        case 109: handleCase((char)45);  break;
        case 111: handleCase((char)47);  break;
        case 127:  if (index < text.length()) sup();  break;
        case 222:  if(C){  handleCase((char)92);  }else if(S){  handleCase((char)63);  }else{  handleCase((char)39);  }  break;
        case 518: if(S){handleCase((char)191);}else{handleCase((char)161);}break;
        case 521: if(S){handleCase((char)42);}else{handleCase((char)43);}break;
        case 524:   break;
        default:
          if(AC){
            int aux=32*int(CL==true);
            if(a==65){handleCase((char)(225-aux));acento=false;return;}
            else if(a==69){handleCase((char)(233-aux));acento=false;return;}
            else if(a==73){handleCase((char)(237-aux));acento=false;return;}
            else if(a==79){handleCase((char)(243-aux));acento=false;return;}
            else if(a==85){handleCase((char)(250-aux));acento=false;return;}
            else if(a!=129){handleCase((char)180);acento=false;}
            
          }
          if(a==81&&C){  handleCase((char)64);  return;  }
          if(a<91&&a>64){  if(CL||S){  handleCase((char)a);  }  else{  handleCase((char)(a+32));  return;  }  }
          if(a<58&&a>47){  if(S){if(a==55){handleCase((char)(47));  }else if(a==48){handleCase((char)(61));}else{handleCase((char)(a-16));}}else{handleCase((char)a);  }  return;  }
          if(a>95&&a<106){  handleCase((char)(a-48));  return;  }
          
          break;
      }
  }
  
  void handleCase(char e) {
    char m = e;
    float currentTextWidth = textWidth(text + str(m)) + 5;
  
    switch (varCase) {
      case 1: // Letras, acentos, apóstrofes, máximo 250 píxeles
          if (currentTextWidth <= maxL) {
              insert(str(m));
          }
          break;
      case 2: // Solo números, máximo 5 dígitos
          if (text.length() < 5 && isDigit(m)) {
              insert(str(m));
          }
          break;
      case 3: // Letras o números, máximo 3 caracteres
          if (text.length() < 3 && (isLetter(m) || isDigit(m))) {
              insert(str(m));
          }
          break;
      case 4: // Solo números, '+', '(', ')', para números de teléfono
          //if (isDigit(m) || m == '+' || m == '(' || m == ')') {
          if (currentTextWidth <= maxL) {
              insert(str(m));
          }
          break;
      case 5: // Todos los caracteres, máximo 400 píxeles
          if (currentTextWidth <= maxL) {  insert(str(m));  }
          break;
      case 6: // Todos los caracteres, máximo 2 líneas
          if((currentTextWidth-textWidth(str(m)))<maxL&&currentTextWidth>maxL){  insert("\n");  lines++;  }
          if(lines<3&&(currentTextWidth <= maxL)){  insert(str(m));  } 
          break;
      case 7: // Todos los caracteres, máximo 4 líneas
          if((currentTextWidth-textWidth(str(m)))<maxL&&currentTextWidth>maxL){  insert("\n");  lines++;  }
          if(lines<5&&(currentTextWidth <= maxL)){  insert(str(m));  }
          break;
      case 8: // 
          if((currentTextWidth-textWidth(str(m)))<maxL&&currentTextWidth>maxL){  insert("\n");  lines++;  }
          if(lines<5&&(currentTextWidth <= maxL)){  insert(str(m));  }
          break;
      case 9:
          insert(str(m));
          break;
      case 10:
          
          break;
    }
  }
  
  boolean isLetterOrAccent(int x) {
    return (x >= 'A' && x <= 'Z') || (x >= 'a' && x <= 'z') || x == '\''; // Asumiendo '\'' como apóstrofe
  }

  boolean isDigit(int x) {  return (x>='0'&&x<= '9')||(x>=96&&x<=105);  }

  boolean isLetter(int x) {  return (x >= 'A' && x <= 'Z') || (x >= 'a' && x <= 'z');  }
  
  void insertIfNumber(int x) {  if (isNumber(x)) {   insert(str((char)keyCode));   }  }
  
  boolean isNumber(int x) {  return (x > 47 && x < 58) || x == 110 || x == 46 || (x > 95 && x < 106);  }

  void setText(String a){  text = a;  }
  
  void hidari(){  index--;  barPos = textWidth(text.substring(0,index));  }
  
  void tadashi(){  index++;  barPos = textWidth(text.substring(0,index));  }
  
  void del(){  hidari();  text = text.substring(0,index) + text.substring(index+1);  }
  
  void sup(){  text = text.substring(0,index) + text.substring(index+1);  }
  
  void insert(String x){  text = text.substring(0,index) + x + text.substring(index);  tadashi();  }
  
  void setValue(){  value = float(text);  }
  
  void resetValue(){  text = "";  index = 0;  setValue();  }
  
  void resetImage(String name){  BGnd = loadImage("/Images/" + name + ".png");  dim = new PVector(BGnd.width,BGnd.height);  maxL = dim.x-10;  }
}

//*************************************************************************************************
class checkBox{
  PVector pos,dim;
  PImage on,off;
  boolean state,hoover;
  String name;
  PApplet parent;
  
  checkBox(PApplet par,float x,float y){
    pos = new PVector(x,y);  dim = new PVector(40,40);
    on = loadImage("/Images/check_on.png");  off = loadImage("/Images/check.png");
    state = false;  parent = par;
  }
  
  checkBox(float x,float y,String namae){
    name = namae;
    pos = new PVector(x,y);  dim = new PVector(40,40);
    on = loadImage("/Images/checkOn.png");  off = loadImage("/Images/checkOff.png");
    state = false;
  }
  
  void draw(){  
    if(parent.mouseX>pos.x&&parent.mouseX<pos.x+dim.x&&parent.mouseY>pos.y&&parent.mouseY<pos.y+dim.y){  hoover = true;  }else{  hoover = false;  }
    if(state){  parent.image(on,pos.x,pos.y);  }else{  parent.image(off,pos.x,pos.y);  }
  }
  
  void set(){  if(hoover){  state = !state;  }  }
  
  float getX() {
    return pos.x;
  }
  
  float getY() {
    return pos.y;
  }
}
//********************************************************************************
abstract class Button{
  float w,h,time,time_e,dist;      //ancho y alto del botón. Temporizador
  PVector pos,pgf,center;  //pos->posición general del botón,pgf->posición global final
  final float PHI = 1.61803398875;
  boolean hoover,hooverAux,pressed,label,type,continuous,timer,onUse;
  color nor,hoo,pre,txt;
  String function,name;
  PImage btn;
  PFont main;
  int delay=1,temp;
  String[] list;
  PApplet parent;
  
  Button(){  
    hoover = false;  hooverAux = false;  onUse = false;  pressed = false;  label = true;  type = false;  timer = false;  continuous = false;
    name = "";  time = 1;
    nor = #FFFFFF;  hoo = #9999AA;  pre = #88FFBB;  txt = 0;  main = loadFont("CambriaMath-48.vlw");
  }
  
  public void draw(){  }
  
  void MReal(){  }
  
  public void check(){  
    if(type){
      dist = PVector.dist(center,new PVector(parent.mouseX,parent.mouseY));
      if(dist<h/2){  
        hoover = true;  
        if(parent.mousePressed){  pressed = true;  }else{  pressed = false;  } 
      }else{  hoover = false;  pressed = false;  }
    }else{
      if(parent.mouseX>pos.x&&parent.mouseX<pgf.x&&parent.mouseY>pos.y&&parent.mouseY<pgf.y){  
        hoover = true;  
        if(parent.mousePressed){  pressed = true;  }else{  pressed = false;  } 
      }else{  hoover = false;  pressed = false;  }
    }
    
    draw(); 
  }
  
    public void check(int offset){  
    if(type){
      dist = PVector.dist(center,new PVector(parent.mouseX,parent.mouseY+offset));
      if(dist<h/2){  
        hoover = true;  
        if(parent.mousePressed){  pressed = true;  }else{  pressed = false;  } 
      }else{  hoover = false;  pressed = false;  }
    }else{
      if(parent.mouseX>pos.x&&parent.mouseX<pgf.x&&(parent.mouseY+offset)>pos.y&&(parent.mouseY+offset)<pgf.y){  
        hoover = true;  
        if(parent.mousePressed){  pressed = true;  }else{  pressed = false;  } 
      }else{  hoover = false;  pressed = false;  }
    }
    
    draw(); 
  }
  
  void setSize(float x,float y){  w = x;  h = y;  pgf = new PVector(pos.x + w,pos.y + h);  btn.resize(int(w),int(h));  }
  void addElement(String el){  }
  void setImage(PImage t){  btn = t;  w = btn.width;  h = btn.height;  }
  void setPosition(float x,float y){  pos.set(x,y);  pgf.set(pos.x + w,pos.y + h);  }
  void setColor(color col){  nor = col;  }
  void setColor(color cnor,color choo,color cpre){  nor = cnor;  hoo = choo;  pre = cpre;  }
  void setColor(color cnor,color choo,color cpre,color t){  nor = cnor;  hoo = choo;  pre = cpre;  txt = t;  }
  void set(){  if(hoover&&parent.mouseButton==LEFT){  onUse = !onUse;  }  }  //esta función debe ir en mouseReleased o en donde sea que active al botón
  void real(){  }
  void setFunction(String x){  function = x;  }
  void setDelay(int x){  delay = x;  }
  void setName(String x){  name = x;  }
  void labelOff(){  label = false;  }
  void makeChip(){  type = true;  btn = loadImage("/Images/chip.png");  setSize(h,h);  center = new PVector(pos.x+h/2,pos.y+h/2);  }
  void setTimer(float x){  time = x;  }
  void setTimerE(float x){  time_e = x + time;  }
  void makeContinuous(){  continuous = true;  }
  void updateList(String[] x){  list = x;  }
  String getName(){  return name;  }
  String getMethod(){  return function;  }
  void reset(){  onUse = false;  hoover = false;  }
  String getSelected(){  return "";  }
  void readScroll(float c){}
  void draw(float x,float y){}
  void enable(){}
  void disable(){}
}


//**************************************************************************************************************************************************************************
class singleAction extends Button{      //Botón que ejecuta una acción a la vez
  
  singleAction(){  super();  h = 200;  w = h*PHI;  pos = new PVector(5,5);  pgf = new PVector(pos.x + w,pos.y + h);  btn = loadImage("/Button/Img/long.png");  btn.resize(int(w),int(h));  }
  singleAction(float x,float y,int a){  super();  h = a;  w = h*PHI;  pos = new PVector(x,y);  pgf = new PVector(pos.x + w,pos.y + h);  btn = loadImage("/Button/Img/long.png");  btn.resize(int(w),int(h));  }
  singleAction(float x,float y,int t,int a){  super();  h = a;  w = t;  pos = new PVector(x,y);  pgf = new PVector(pos.x + w,pos.y + h);  btn = loadImage("/Button/Img/long.png");  btn.resize(int(w),int(h));  }
  singleAction(PApplet par,float x,float y,int t,int a,String funct){  super();  
    h = a;  w = t;  pos = new PVector(x,y);  pgf = new PVector(pos.x + w,pos.y + h);  
    //btn = loadImage("/Images/Boton muestra.png");  btn.resize(int(w),int(h));  
    function = funct;  parent = par;
  }
  
  public void draw(){
    parent.push();
    if(pressed||onUse){  parent.tint(pre);  }else if(hoover){  parent.tint(hoo);  }else{  parent.tint(nor);  }  
    parent.image(btn,pos.x,pos.y);
    parent.pop();
  }
  
  void draw(float x,float y){  
    setPosition(x,y);
    parent.push();  
    if(pressed||onUse){  tint(pre);  }else if(hoover){  tint(hoo);  }else{  tint(nor);  }  
    if(type){  image(btn,pos.x,pos.y);  fill(txt);  if(label){  textAlign(LEFT,CENTER);  text(name,pos.x + 10,pos.y + h/2);  }  }
    else{  image(btn,pos.x,pos.y);  fill(txt);  if(label){  textAlign(CENTER,CENTER);  text(name,pos.x + w/2,pos.y + h/2);  }  }
    parent.pop();  
  }
  
  void set(){  try{  if(hoover&&parent.mouseButton==LEFT){  parent.method(function);  }  }catch(NullPointerException e){  }  }  //Colocar en mouseReleased
  
  void makeDull(){  btn = loadImage("/Images/dull.png");  btn.resize(int(w),int(h));  nor = color(255);  }
}

class sustainedAction extends Button{      //Botón que ejecuta una acción a la vez
  boolean selected;
  
  sustainedAction(){  super();  h = 200;  w = h*PHI;  pos = new PVector(5,5);  pgf = new PVector(pos.x + w,pos.y + h);  btn = loadImage("/Button/Img/long.png");  btn.resize(int(w),int(h));  }
  sustainedAction(float x,float y,int a){  super();  h = a;  w = h*PHI;  pos = new PVector(x,y);  pgf = new PVector(pos.x + w,pos.y + h);  btn = loadImage("/Button/Img/long.png");  btn.resize(int(w),int(h));  }
  sustainedAction(float x,float y,int t,int a){  super();  h = a;  w = t;  pos = new PVector(x,y);  pgf = new PVector(pos.x + w,pos.y + h);  btn = loadImage("/Button/Img/long.png");  btn.resize(int(w),int(h));  }
  sustainedAction(PApplet par,float x,float y,int t,int a,String funct){  super();  
    h = a;  w = t;  pos = new PVector(x,y);  pgf = new PVector(pos.x + w,pos.y + h);  
    //btn = loadImage("/Images/Boton muestra.png");  btn.resize(int(w),int(h));  
    function = funct;  parent = par;
    selected = false;
  }
  
  public void draw(){
    parent.push();
    if(pressed||onUse){  parent.tint(pre);  }else if(hoover||selected){  parent.tint(hoo);  }else{  parent.tint(nor);  }  
    parent.image(btn,pos.x,pos.y);
    parent.pop();
  }
  
  void draw(float x,float y){  
    setPosition(x,y);
    parent.push();  
    if(pressed||onUse){  tint(pre);  }else if(hoover||selected){  tint(hoo);  }else{  tint(nor);  }  
    if(type){  image(btn,pos.x,pos.y);  fill(txt);  if(label){  textAlign(LEFT,CENTER);  text(name,pos.x + 10,pos.y + h/2);  }  }
    else{  image(btn,pos.x,pos.y);  fill(txt);  if(label){  textAlign(CENTER,CENTER);  text(name,pos.x + w/2,pos.y + h/2);  }  }
    parent.pop();  
  }
  
  void set(){  try{  if(hoover&&parent.mouseButton==LEFT){  parent.method(function); selected=true;  }  }catch(NullPointerException e){  }  }  //Colocar en mouseReleased
  
  void makeDull(){  btn = loadImage("/Images/dull.png");  btn.resize(int(w),int(h));  nor = color(255);  }
  void enable(){  selected = true;  }
  void disable(){  selected = false;  }
}
//**************************************************************************************************
class ddl {
  String[] options;
  PImage BGnd, btnImage;
  color file = color(65, 90, 100), bg = color(101, 136, 164);
  float x, y, w, h,bw;
  boolean isOpen, hoover,boton, isActive;
  int selectedIndex, scrollIndex;
  String currentText = "",displayText = "";
  ArrayList<String> filteredOptions;
  PApplet parent;

  ddl(PApplet par,String[] options, float x, float y) {
    BGnd = loadImage("/Images/text250.png");
    btnImage = loadImage("/Images/down.png");
    
    this.options = options;
    filteredOptions = new ArrayList<String>(Arrays.asList(options));
    this.x = x;
    this.y = y;
    this.w = BGnd.width;
    this.h = BGnd.height;
    this.bw = btnImage.width;
    this.isOpen = false;
    this.boton = false;
    this.selectedIndex = -1;
    this.scrollIndex = 0;
    parent = par;
  }

  void draw() {
    parent.image(BGnd, x, y);
    parent.image(btnImage,x+w,y);

    parent.fill(0);
    parent.text(currentText.isEmpty() && selectedIndex >= 0 ? options[selectedIndex] : displayText, x + 10, y + 25);
  }
  
  void drawOptions(){
    if (isOpen) {
      int displayCount = min(filteredOptions.size() - scrollIndex, 4);
      for (int i = 0; i < displayCount; i++) {
        parent.fill(255);
        parent.rect(x, y + (i + 1) * h, w, h);
        parent.fill(0);
        currentText = filteredOptions.get(scrollIndex + i);
        while(textWidth(currentText)>240){  currentText = currentText.substring(0,currentText.length()-1);  }
        parent.text(currentText, x + 10, y + (i + 1) * h + 25);
      }
    }
  }
  

  void set() {
    if(hoover){
      isActive = true;
      if(isOpen){  selectOption();  isActive = false;  }
    }else if(boton){
      isOpen = !isOpen;
      isActive = false;
    }else{
      isOpen = false;
      isActive = false;
    }
  }
  
  void set(int offset) {
    if(hoover){
      isActive = true;
      if(isOpen){  selectOption(offset);  isActive = false;  }
    }else if(boton){
      isOpen = !isOpen;
      isActive = false;
    }else{
      isOpen = false;
      isActive = false;
    }
  }

  void mouseScrolled(float count) {
    if (isOpen) {
      scrollIndex = constrain(scrollIndex + int(count), 0, max(0, filteredOptions.size() - 4));
    }
  }

  void check() {
    hoover = parent.mouseX > x && parent.mouseX < x + w && parent.mouseY > y && parent.mouseY < y + h * min(filteredOptions.size()+1, 5);
    boton = parent.mouseX>(x+w)&&parent.mouseX<(x+w+bw)&&parent.mouseY>y&&parent.mouseY<(y+h);
    draw();
  }
  
  void check(int offset) {
    hoover = parent.mouseX > x && parent.mouseX < x + w && (parent.mouseY+offset) > y && (parent.mouseY+offset) < y + h * min(filteredOptions.size()+1, 5);
    boton = parent.mouseX>(x+w)&&parent.mouseX<(x+w+bw)&&(parent.mouseY+offset)>y&&(parent.mouseY+offset)<(y+h);
    draw();
  }

  void selectOption() {
    if (hoover) {
      int clickedIndex = int((parent.mouseY - y) / h) - 1;
      selectedIndex = scrollIndex + clickedIndex;
      currentText = filteredOptions.get(selectedIndex);
      displayText = filteredOptions.get(selectedIndex);
      while(textWidth(displayText)>240){  displayText = displayText.substring(0,displayText.length()-1);  }
      filterOptions("");
      isOpen = false;
    }
  }
  
    void selectOption(int offset) {
    if (hoover) {
      int clickedIndex = int((parent.mouseY - y+offset) / h) - 1;
      selectedIndex = scrollIndex + clickedIndex;
      currentText = filteredOptions.get(selectedIndex);
      displayText = filteredOptions.get(selectedIndex);
      while(textWidth(displayText)>240){  displayText = displayText.substring(0,displayText.length()-1);  }
      filterOptions("");
      isOpen = false;
    }
  }
  
  public void setOption(String a){
    currentText = a;  displayText = a;
    while(textWidth(displayText)>240){  displayText = displayText.substring(0,displayText.length()-1);  }
  }

  void read() {
    //if(isActive){
    //  if (key == BACKSPACE && currentText.length() > 0) {
    //    currentText = currentText.substring(0, currentText.length() - 1);
    //  } else if (key != BACKSPACE && key != ENTER) {
    //    currentText += key;
    //  }
    //  filterOptions(currentText);
    //}
  }

  void filterOptions(String text) {
    filteredOptions.clear();
    for (String option : options) {
      if (option.toLowerCase().startsWith(text.toLowerCase())) {
        filteredOptions.add(option);
      }
    }
    scrollIndex = 0;
  }
  
  void updateOptions(String[] newOptions) {
    this.options = newOptions;
    filterOptions(currentText);  // Actualiza la lista filtrada basada en el texto actual
    selectedIndex = -1;          // Resetea el índice de selección
  }
  // Métodos adicionales serán implementados aquí
  
  void resetImage(String a){
    BGnd = loadImage("/Images/"+a+".png");
    this.w = BGnd.width;
    this.h = BGnd.height;
  }
}
//***********************************************************************
class label{
  String text;
  float x,y,size;
  PFont fon;
  int align;
  PApplet parent;
  
  label(PApplet par,PFont wt,float posX,float posY,String tx){
    text = tx;
    size = 20;
    fon = wt;
    x = posX;  y = posY - int(2*size/10);
    align = 1;  //1 right, 2 left, 3 center
    parent = par;
  }
  
  label(PApplet par,PFont wt,float posX,float posY,String tx,int type){
    text = tx;
    size = 20;
    fon = wt;
    x = posX;  y = posY - int(2*size/10);
    align = type;  //1 right, 2 left, 3 center
    parent = par;
  }
  
  void draw(){
    parent.push();
    if(align==1){  parent.textAlign(LEFT);  }else if(align==2){  parent.textAlign(RIGHT);  }else if(align==3){  parent.textAlign(CENTER);  }
    parent.textSize(size);
    parent.text(text,x,y);
    parent.pop();
  }
}
//**********************************************************************
class optionBox {
  PApplet parent;
  float posX, posY,width;
  int show, cat,size;
  String[] datos;
  boolean[] hoover;
  int selectedIndex;
  int scrollIndex;

  optionBox(PApplet parent, float posX, float posY, int show, int cat, String[] datos, float x) {
    this.parent = parent;
    this.posX = posX;
    this.posY = posY;
    this.show = show;
    this.cat = cat;
    this.datos = datos;
    this.width = x;
    this.hoover = new boolean[datos.length];
    this.selectedIndex = -1;
    this.scrollIndex = 0;
    this.size=24;
  }

    void draw() {
    parent.push();
    int displayCount = min(datos.length - scrollIndex, show); // Número de opciones a mostrar
    for (int i = 0; i < show; i++) {
      if (i < displayCount) {
        int dataIndex = i + scrollIndex; // Índice ajustado por el scroll
        if (hoover[dataIndex]) {
          parent.fill(200); // Color de resaltado
        } else {
          parent.fill(255); // Color de fondo normal
        }
        parent.rect(posX, posY + i * this.size, width, this.size); // Dibujar opción

        String[] data = datos[dataIndex].split(",");
        for (int j = 0; j < cat; j++) {
          parent.fill(0); // Color del texto
          parent.text(data.length > j ? data[j] : "", posX + j * (width / cat), posY + i * this.size + (this.size-4));
        }
      } else {
        parent.fill(255);
        parent.rect(posX, posY + i * this.size, width, this.size);
      }
    }
    parent.pop();
  }

  void mouseScrolled(float count) {
    scrollIndex = constrain(scrollIndex + int(count), 0, max(0, datos.length - show));
  }

  void checkHover() {
    for (int i = 0; i < datos.length; i++) {
      hoover[i] = parent.mouseX > posX && parent.mouseX < posX + width && parent.mouseY > posY + i * this.size && parent.mouseY < posY + i * this.size + this.size;
    }
  }

  void mousePressed() {
    for (int i = 0; i < datos.length; i++) {
      if (hoover[i]) {
        selectedIndex = i;
        break;
      }
    }
  }

}
