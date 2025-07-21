public class pantalla extends PApplet {
  ArrayList<varBox> datos,datosNE;
  ArrayList<checkBox> siNo;
  ArrayList<ddl> option;
  ArrayList<Button> box;
  ArrayList<pantalla> modulo;
  ArrayList<label> tag;
  ArrayList<optionBox> list;
  boolean[] modulos;
  String[] temp,user;
  userInput emergentActivity;
  public boolean activeEvent,control,shift,caps;
  SecretKey locksmith;
  PImage backGround;
  int fase;
  PImage fondo;
  
  public void settings(){  size(200, 200);  }
  
  public void setup(){
    this.datos = new ArrayList<varBox>();  this.datosNE = new ArrayList<varBox>();
    this.siNo = new ArrayList<checkBox>();  this.option = new ArrayList<ddl>();
    this.box = new ArrayList<Button>();  this.tag = new ArrayList<label>();
    this.modulo = new ArrayList<pantalla>();
    this.list=new ArrayList<optionBox>();
    textFont(main,20);
  }
  
  public void draw(){  background(255);  }
  
  public void mousePressed(){  }
  
  public void mouseReleased(){  }
  
  public void mouseWheel(MouseEvent e){  }
  
  public void keyPressed(KeyEvent e){    }
  
  public void keyReleased(KeyEvent e){    }
  
  public void focusGained(){    }
  public void focusLost(){    }
  public void exit() {  surface.setVisible(false);  }
}
//////////////////////////////////////////////////////////////////////////////
