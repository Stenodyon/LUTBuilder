class Textbox {
  /*
  The TextBox class creates a box for text to be entered, displayed, and modified my either the user or the program
  The user first selects the text box to activate it, when once it's active, any keystrokes the user makes is sent to the textbox
  The constructor requires an x,y position, and a defined width and height.
  The Draw() method draws the textbox, taking care of the stroke based on whether the mouse is over or not, fill is constant.
  The MouseOver() method returns a boolean, true if the mouse is over the text box, false if its not.
  The Value() method has two versions:
  one requires a string and sets the text in the box to that string,
  the other returns whatever text is in the text box as a string.
  The IsActive() method has two versions:
  one requires a boolean and sets the active variable to that boolean,
  the other returns the active variable as a boolean.
  The MousePressed(), MouseReleased(), and KeyPressed() methods are event handlers and should be called in the appropriate main event handlers.
  MousePressed() does not return a boolean indicating the user is interacting with this element.
  KeyPressed() is repsoncable for modifying the text in the textbox based on the keystrokes made by the user.
  */
  float x, y, w, h; //x,y position and width and height of the textbox
  boolean selected = false; //internal variable for determining if the user is selecting this button
  boolean active = false; //determines if the user is interacting with this element or not
  String value = ""; //the text found in the text box
  Textbox(float x, float y, float w, float h) { //requires an x,y position representing the top left corner, width is how far right it spans, height is how far down it spans
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
  }
  public void Draw() {
    pushStyle();
    strokeWeight(2);
    stroke(100);
    if (this.MouseOver()) {
      stroke(200);
    }
    if (this.active) {
      stroke(200, 200, 255);
    }
    fill(255);
    rect(x, y, w, h);
    fill(0);
    text(value, x+5, y, w, h);
    popStyle();
  }
  public String Value() {
    return value;
  }
  public void Value(String val) {
    this.value = val;
  }
  public boolean IsActive() {
    return this.active;
  }
  public void IsActive(boolean val) {
    this.active = val;
  }
  public boolean MouseOver() {
    return mouseX>this.x&&mouseX<this.x+this.w&&mouseY>this.y&&mouseY<this.y+this.h;
  }
  void MousePressed() {
    if (this.MouseOver()) {
      this.selected = true;
    }
  }
  void MouseReleased() {
    this.active = false;
    if (this.selected) {
      this.selected = false;
      this.active = true;
    }
  }
  void KeyPressed() {
    if (this.active) {
      if (key<128) {
        if (keyCode == BACKSPACE||key==8) {
          if (value.length() > 0) {
            value = value.substring(0, value.length()-1);
          }
        } else if (keyCode == DELETE) {
          value = "";
        } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
          value+=key;
        }
      }
    }
  }
}