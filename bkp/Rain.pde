//This is probably how I would actually code out the rain.

//class definition
class Rain {
  
  //instance variables (variables belonging to each instance of a class)
  int numDrops;
  float[] x;
  float[] y;
  float[] speed;
  
  //constructor initializes the instance varibles
  Rain() {
    //number of raindrops on the screen
    numDrops = 500;
    x = new float[numDrops];
    y = new float[numDrops];
    speed = new float[numDrops];
    
    //fill arrays of x and y positions and speed with random values
    for (int i=0; i<numDrops; i++) {
      x[i] = random(width);
      y[i] = random(height);
      //minimum speed of one, max of five
      speed[i] = random(1,5);
    }
  }
  
  void drawRain() {
    //for every raindrop in the arrays:do this.
    for (int i=0; i<numDrops; i++) {
      
      //off-white stroke
      stroke(240);
      
      //strokeweight is dependent upon speed.
      //this gives the illusion of depth.
      //farther = smaller = slower
      strokeWeight(speed[i]/5);
      
      //draw a point at x and y
      point(x[i],y[i]);
      
      //update x with 2/5ths raindrop's vertical speed
      x[i]+=2*speed[i]/5;
      
      //update y with the raindrop's corresponding speed
      y[i]+=speed[i];
      
      //more depth:
      //speed can only be 1-5
      //if speed is 1, it's farther back. Will hit the ground
      //at approx 10/15ths the screen.  If speed is 5, it's close.
      //will hit the ground at 15/15ths the screen.
      //if it touches ground, set it back to zero.
      //(speed[i]*height/15) determines 1/15 to 5/15
      // + 10*height/15 is the offset.
      if (y[i] > (speed[i]*height/15)+10*height/15) {
        //make a ripple at x,y with intensity speed[i] before resetting y
        ripple(x[i],y[i],speed[i]);
        splash(x[i],y[i],speed[i]);
        y[i]=0;
      }
      
      //similarly, though much simpler.  If the point has reached
      //width, set it back to zero.
      if (x[i] > width) x[i]=0;
      
      //these last two lines give the impression that the rain is continuous
      //when in fact there are only numDrops distinct raindrops.
      
      //this should be making water hit the hero, but not working well.
      if (x[i] > h.center.x - h.size/2 && 
          x[i] < h.center.x + h.size/2 &&
          //y[i] > height/2 &&
          y[i] > h.center.y - h.size/2 - 10 &&
          speed[i] < h.depth) {
            ripple(x[i],y[i],speed[i]);
            splash(x[i],y[i],speed[i]);
            y[i] = 0;
          }
    }
  }
  
  //ripple effect
  void ripple(float x, float y, float s) {
    
    //hollow ellipse
    noFill();
    
    //off-white or greyish
    stroke(200);
    
    //maximum strokeweight of 1
    strokeWeight(s/5);
    
    //draw ellipse at x,y with size s*4 horizontally, s vertically
    ellipse(x,y,s*4,s);
  }
  
  //not sure if I like the splash, but it's an option.
  void splash(float x, float y, float s) {
    stroke(120);
    strokeWeight(s/5);
    line(x,y,x+random(10),y-random(10));
    line(x,y,x,y-random(10));
    line(x,y,x-random(10),y-random(10));
  }
}
