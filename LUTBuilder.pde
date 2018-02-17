/*
Title:    LUT Builder 
Version:  1.0.0

Revision Notes:

Revision 2018/02/17
-------------------
At some point I wanna think of a catchier name than LUT Builder, and of course a nice little logo to go with it, but that's low priority

This tab hosts the primary functions for the program - such as setup, draw, and event handlers (oxford commas ftw)
These functions primarily take care of the GUI
Information for the actual functional side of the program can be found in the 'BuildThread' tab
In summary - setup sets up the window and GUI, draw updates each element, and the event handlers update each elements event method
Most elements just store a value, but if we need a specific function to run when an element is clicked, that callback is made in the event handlers
At this point there are only two events - one for selecting the source file and one for calling the build thread
If we ever intend on adding more functions though, it'll be nice to know how to integrate them.
More information on how GUI elements interact with everything can be found with the GUI elements tabs - Button, Dropdown, ProgressBar, Radio, and TextBox
Lastly I've given the algorithms for generating encoders and decoders their own tabs, which should make things cleaner and easier to navigate.
Those tabs are the GenDecoder and GenEncoder tabs of course. I suppose you're job is to just make sure the build algorithms play nice with everything else
The typeString function is also stored here all the way at the bottom. I really wasn't sure where else to put it.
*/

//List of GUI elements - may as well make them global
//---------------------
Dropdown playerFacing;
Radio IOSide;
Radio playerReference;
Textbox sourcePath;
Button browse;
Radio circuitType;
Button generate;
Progressbar progBar;
//---------------------

//These are variables that allow the build thread to communicate with the draw function
//------------------------------------------------------------
float progress = 0;
String splash = "Please Select a Source File Before Building";
//------------------------------------------------------------

//images for the fancy visualiser thing
//-------------
PImage encoder;
PImage decoder;
//-------------

//Robot stuff
//-----------------------------
import java.awt.*;
import java.awt.event.*;
import java.awt.datatransfer.*;
import javax.swing.*;
import java.io.*;
Robot robot; 
//-----------------------------

/*
this keeps the program from creating a new thread when one is already running
if it's true, a build thread is running and the program is not allowed to make a new thread
if it's false, a build thread isn't running and the program is allowed to make a new thread
*/
boolean buildingCircuit = false; 


void setup() {  
  
  //setup the window size and GUI element positions
  size(700, 450);
  encoder = loadImage("data/Encoder.png");
  decoder = loadImage("data/Decoder.png");
  playerFacing = new Dropdown(90, 10, 150);
  playerFacing.AddOption("North (-Z)");
  playerFacing.AddOption("West (-X)");
  playerFacing.AddOption("South (+Z)");
  playerFacing.AddOption("East (+X)");
  IOSide = new Radio();
  IOSide.AddButton(50, 90, 70, 30, "LEFT");
  IOSide.AddButton(130, 90, 70, 30, "RIGHT");
  playerReference = new Radio();
  playerReference.AddButton(50, 400, 70, 30, "LEFT");
  playerReference.AddButton(130, 400, 70, 30, "RIGHT");
  sourcePath = new Textbox(250,175,425,30);
  browse = new Button(460,140,70,30);
  browse.SetName("Browse");
  circuitType = new Radio();
  circuitType.AddButton(350,225,100,30,"Decoder");
  circuitType.AddButton(460,225,100,30,"Encoder");
  generate = new Button(250,275,425,50);
  generate.SetName("Build Circuit");
  progBar = new Progressbar(250,380,425,50);
  
  //setup the robot
  try { 
    robot = new Robot();
    robot.setAutoDelay(40);
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}

void draw() {
  /*
  draw only takes care of the GUI, 
  the build algorithms are taken care of in a seperate thread
  the thread call is down in the events section
  */
  background(175);
  fill(0);
  textSize(18);
  {  //logo - I suppose we need to design one at some point
    noFill();
    stroke(0);
    rect(250,10,425,120);
  }
  { //buttons for choosing to place the inputs/outputs on the left or the right
    String s;
    if (circuitType.Value()=="Encoder") {
      s = "-Inputs-";
    } else {
      s = "-Outputs-";
    }
    textAlign(CENTER,CENTER);
    text(s, 130, 70);
    IOSide.Draw();
  }
  { //visual feedback window - helps the user see how the circuit will be built out infront of them
    PGraphics visualizer = createGraphics(200,200);
    visualizer.beginDraw();
    visualizer.background(0);
    visualizer.pushMatrix();
    visualizer.scale(1.7);
    visualizer.translate(-1,0);
    if(IOSide.Value()=="RIGHT"){
      visualizer.translate(120,0);
      visualizer.scale(-1,1);
    }
    if(circuitType.Value()=="Encoder"){
      visualizer.image(encoder,0,0);
    } else {
      visualizer.image(decoder,0,0);
    }
    visualizer.popMatrix();
    visualizer.noStroke();
    visualizer.fill(255,0,0);
    if(playerReference.Value()=="LEFT"){
      visualizer.ellipse(20,180,10,10);
    } else {
      visualizer.ellipse(180,180,10,10);
    }
    visualizer.stroke(0);
    visualizer.strokeWeight(3);
    visualizer.noFill();
    visualizer.rect(0,0,199,199);
    visualizer.endDraw();
    image(visualizer, 25, 150);
  }
  { //dropdown to indicate which direction is the player facing
    textAlign(LEFT);
    text("Facing:", 20, 32);
    playerFacing.Draw();
  }
  { //buttons to choose where the circuit is built with reference to the player - i.e. is it built to the left of the player or the right
    fill(0);
    textAlign(CENTER,CENTER);
    text("-Reference-", 130, 380);
    playerReference.Draw();
  }
  { //button to select file source and text box to display it/enter it manually (like anyone's going to do that)
    pushStyle();
    textAlign(LEFT,CENTER);
    textSize(12);
    sourcePath.Draw();
    popStyle();
    textAlign(RIGHT,CENTER);
    text("Source:",450,155);
    textAlign(CENTER,CENTER);
    browse.Draw();
  }
  { //buttons to choose between an encoder and a decoder
    textAlign(CENTER,CENTER);
    circuitType.Draw();
  }
  { //nice big button to generate the LUT
    textAlign(CENTER,CENTER);
    pushStyle();
    textSize(30);
    generate.Draw();
    popStyle();
  }
  { //splash and progress bar - mainly to give visial feedback on the build process for the user - this is used by the build thread, not the draw function, it's only here cuz you can't draw in a thread
    textAlign(CENTER,CENTER);
    text(splash,465,350);
    progBar.Draw(progress);
  }
}

//THESE EVENT FUNCTIONS ARE FOR UPDATING THE EVENT METHODS FOR EACH GUI ELEMENT - each function should be fairly self-evident

void mousePressed() {
  playerFacing.MousePressed();
  IOSide.MousePressed();
  playerReference.MousePressed();
  sourcePath.MousePressed();
  if(browse.MousePressed()){
    selectInput("Select a file:", "fileSelected");
  }
  circuitType.MousePressed();
  if(generate.MousePressed()){
    if(!buildingCircuit&&sourcePath.Value()!=""){ //we don't want multiple build threads running
      buildingCircuit = true;
      thread("buildThread"); //this is what actually starts the build process
    }
  }
}

void mouseReleased() {
  playerFacing.MouseReleased();
  IOSide.MouseReleased();
  playerReference.MouseReleased();
  sourcePath.MouseReleased();
  browse.MouseReleased();
  circuitType.MouseReleased();
  generate.MouseReleased();
}

void keyPressed() {
  playerFacing.KeyPressed();
  sourcePath.KeyPressed();
}

void fileSelected(File selection) {
  browse.MouseReleased();
  if (selection != null) {
    sourcePath.Value(selection.getAbsolutePath());
  }
}

//THE TYPESTRING FUNCTION WHICH IS RESPONCABLE FOR TYPING THE STRING GIVEN TO IT INTO MINECRAFT

void typeString(String text) { //I'm using the copy-paste version of it, feel free to change it if you want, I'm not too attached. 
  StringSelection stringSelection = new StringSelection(text);
  Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
  clipboard.setContents(stringSelection, stringSelection);
  robot.keyPress('\n');
  robot.keyRelease('\n');
  robot.keyPress(CONTROL);
  robot.keyPress('V');
  robot.keyRelease('V');
  robot.keyRelease(CONTROL);
  robot.keyPress('\n');
  robot.keyRelease('\n');
}