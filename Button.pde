class Button {
  /*
  Button class creates a clickable button for the user to interact with
  Constructor requires an x,y position, as well as a defined width and height
  Optionally can be given a name and/or be made toggleable
  The Button Class has 9 methods, 2 are event handlers
  SetName() and GetName() sets and gets the name of the button respectivly, SetName() requires a string, GetName() returns a string
  IsToggle() requires a boolean and will make the button toggleable if true, or a standard push button if false.
  When toggle is true, the button will hold it's state until clicked on, at which point it will switch states.
  When toggle is false, the button will only be active when the user clicks on it.
  IsActive() has two versions - one version returns a boolean determining if the button is active (true) or not (false).
  The other version requires a boolean and will make the button active (true) or inactive (false)
  MouseOver() returns a boolean and will return true if the mouse is currently over the button
  Draw() draws the button - draw will change fill based on the buttons activity and stroke based on the result of MouseOver(),
  but the change of activity is done by the event handlers and the IsActive(boolean) function
  MousePressed() is the first event handler and is called by the main mousePressed() event handler.
  This method will update active depending on the mouses position and weather the buttons togglable.
  This method also returns a boolean, true if the mouse is over the button at the time of clicking, this can be used to initiate a callback when clicked
  MouseReleased() is the second event handler and is used in conjunction with MousePressed to finalize the active variable.
  This method should be called in the mouseReleased() main event handler
  */
  
  float x, y, w, h;
  boolean active = false; //determines if the button is pressed or not.
  boolean toggle = false; //determines if the button holds it's state
  boolean selected = false; //internal variable for determining if the user is selecting this button
  String name = ""; //name of the button

  Button(float x, float y, float w, float h) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
  }

  public void SetName(String name) {
    this.name=name;
  }
  public String GetName() {
    return this.name;
  }
  public void IsToggle(boolean val) {
    this.toggle = val;
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

  public void Draw() { //draws the button with x,y representing the top left corner, width is how far right it spans, height is how far down it spans
    pushStyle();
    strokeWeight(2);
    stroke(100);
    if (this.MouseOver()) {
      stroke(200);
    }
    if (this.active) {
      fill(127, 127, 255);
    } else {
      fill(200,200,255);
    }
    rect(this.x, this.y, this.w, this.h);
    fill(0);
    text(this.name, this.x, this.y, this.w, this.h);
    popStyle();
  }

  public boolean MousePressed() {
    if (this.MouseOver()) {
      this.selected = true;
      if (!this.toggle) {
        this.active = true;
      }
    }
    return this.active;
  }

  public void MouseReleased() {
    if (this.selected) {
      this.selected=false;
      if (this.toggle) {
        this.active = !this.active;
      } else {
        this.active = false;
      }
    }
  }
}