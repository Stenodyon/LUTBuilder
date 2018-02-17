class Radio {
  /*
  The Radio class creates an array of Buttons that are all tied together so only one button can be active at any time.
  This can be used when selecting one of multiple options, similar to a dropdown menu, but giving the developer the option to choose the location of each option
  The constructor requires no arguments, and adding a button can be done with the AddButton() method.
  The AddButton() method is similar to creating a stand alone button, but a name is required. so and x,y position is needed, a defined width and height, and a name in the form of a string.
  The Value() method returns the name of the currently activated button in the form of a string.
  The Draw() method draws all buttons tied to the radio object.
  The MousePressed() and MouseReleased() methods are event handlers and should be called in the appropriate main event handlers.
  Both of these methods work together to detemine if the user is selecting one of the buttons tied to the radio object, and then changes which button is active based on the users selection.
  */
  Button[] buttons = new Button[0]; //an array of buttons
  boolean selected = false; //this tells the object if the user is selecting one if its buttons, true if they are, false if they arent
  public void AddButton(float x, float y, float w, float h, String name) { //the button require an x,y position representing the top left corner, width is how far right it spans, height is how far down it spans
    buttons = (Button[]) append(buttons, new Button(x, y, w, h));
    buttons[buttons.length-1].IsToggle(true);
    buttons[buttons.length-1].SetName(name);
    if (buttons.length==1) {
      buttons[buttons.length-1].IsActive(true);
    }
  }
  public void Draw() {
    for (int i=0; i<buttons.length; i++) {
      buttons[i].Draw();
    }
  }
  public void MousePressed() {
    for (int i=0; i<buttons.length; i++) {
      if (buttons[i].MouseOver()) {
        selected = true;
      }
    }
  }
  public void MouseReleased() {
    if (selected) {
      selected = false;
      for (int i=0; i<buttons.length; i++) {
        buttons[i].IsActive(false);
        if (buttons[i].MouseOver()) {
          buttons[i].IsActive(true);;
        }
      }
    }
  }
  public String Value() {
    for (int i=0; i<buttons.length; i++) {
      if (buttons[i].IsActive()) {
        return buttons[i].GetName();
      }
    }
    return null;
  }
}