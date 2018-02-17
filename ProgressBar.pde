class Progressbar{
  /*
  The ProgressBar class creates a progress bar to indicate the progress of a tast for the user
  The constructor requires an x,y position, as well as a defined width and height.
  The ProgressBar only has one method, the Draw() method, which takes a float between 0 and 1 inclusive.
  The Draw() method will draw a rectangle at x,y as big as w and h will allow, and fills it from left to right with a green fill proportional to the float given
  */
  float x,y,w,h;
  Progressbar(float x,float y,float w,float h){
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
  }
  void Draw(float ratio){ //x,y is the top left corner, w is how far right, h is how far down
    pushStyle();
    noStroke();
    fill(100,255,100);
    rect(x,y,w*ratio,h);
    stroke(0);
    noFill();
    rect(x,y,w,h);
    popStyle();
  }
}