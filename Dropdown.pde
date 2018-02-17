class Dropdown {
  /*
  Dropdown class creates a dropdown menu for the user to interact with
  Constructor requires an x,y position, as well as a defined width, height is fixed at 30 pixels
  The dropdown consists of two elements, a button and a textbox. The textbox contains one string from an array of options strings.
  The button creates a dropdown listing all options in the array. Clicking one of these options changes the textbox to that option.
  Options can be added using the AddOptions() method, which requires a string.
  The selected option can be queried using the Value() method, which returns the currently selected option in the form of a string.
  The Draw() function places the dropdown on the canvas, and will take care of the textbox, button, and dropdown window.
  The MousePressed(), MouseReleased(), and KeyPressed() methods are event handlers and should be called in the appropriate main event handlers.
  MousePressed() does not return a boolean indicating the user is interacting with this element.
  Instead, functions can be selected by calling the Value() method and calling different functions based on the result.
  */
  Button button; //the button for toggling the dropdown
  Textbox textbox; //the textbox for displaying the option, options can be edited, but only if allowEdit is true
  int k = 30; //a constant for the dropdown height
  boolean showDropDown = false; //detemines whether the Draw() method draws the dropdown and its options 
  boolean allowEdit = false; //disables the textbox editablity
  String value = ""; //the currently selected option
  String[] options = new String[0]; //an array to store all options
  Float x, y, w;
  Dropdown(float x, float y, float w) {
    this.x=x;
    this.y=y;
    this.w=w;
    textbox = new Textbox(x, y, w-k, k);
    button = new Button(x+w-k, y, k, k);
    button.SetName("\u25BC");
  }
  public void Draw() { //draws the dropdown with x,y representing the top left corner, width is how far right it spans, height is a constand 30 pixels. The textbox will be 30 pixels short of the target width to make room for the button
    pushStyle();
    fill(255);
    if (showDropDown) { //this is what draws the dropdown options
      stroke(100);
      strokeWeight(2);
      rect(x, y+k, w, k*options.length);
      noStroke();
      textAlign(LEFT, CENTER);
      for (int i=0; i<options.length; i++) {
        fill(200);
        if (mouseX>x&&mouseX<x+w&&mouseY>y+k*(i+1)&&mouseY<y+k*(i+2)) {
          rect(x, y+k*(i+1), w, k);
        }
        fill(0);
        text(options[i], x+5, y+k*(i+1), w, k);
      }
    }
    textAlign(CENTER, CENTER);
    textSize(18);
    button.Draw();
    textAlign(LEFT, CENTER);
    textbox.Value(value);
    textbox.Draw();
    popStyle();
  }
  public void AddOption(String option) {
    options = append(options, option);
    if(options.length==1){
      value = option;
    }
  }
  public String Value() {
    return this.value;
  }
  public void MousePressed() {
    if (showDropDown) {
      for (int i=0; i<options.length; i++) {
        if (mouseX>x&&mouseX<x+w&&mouseY>y+k*(i+1)&&mouseY<y+k*(i+2)) {
          value = options[i];
        }
      }
      showDropDown=false;
      button.MousePressed();
    } else if (button.MousePressed()) {
      showDropDown=!showDropDown;
    }
    if(allowEdit){
      textbox.MousePressed();
    }
  }
  public void MouseReleased() {
    if(allowEdit){
      textbox.MouseReleased();
    }
    button.MouseReleased();
  }
  public void KeyPressed() {
    if(allowEdit){
      textbox.KeyPressed();
    }
  }
}