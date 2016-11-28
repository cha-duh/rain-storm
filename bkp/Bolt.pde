//class definition
class Bolt {

  //lifeSpan determines number of frames it will be visible before fading
  int lifeSpan;
  float x0, y0, x1, y1, weight;

  //Constructor initialized the instance variables
  //@Params x: initial x position, y: initial y position, w: strokeWeight
  Bolt(float x, float y, float w) {
    //initial x and y
    x0 = x;
    y0 = y;
    //target x and y
    x1 = x0 + random(-60, 60);
    y1 = y0 + random(40, 80);
    //strokeWeight
    weight = w;
    //initial lifespan : 1 is near immediate bolt, higher draws it out
    lifeSpan = 3;
  }

  void drawBolt() {
    //if it hasn't dissipated
    if (weight > 0) {
      
      //set stroke to white and strokeWeight to weight
      stroke(255);
      strokeWeight(weight);
      
      //draw a line from initial x,y to target x,y
      line(x0, y0, x1, y1);
      
      //shortly before disappearing, create new instances of bolt
      if (lifeSpan == 1) {
        
        //at least one must be drawn to continue
        Bolt b = new Bolt(x1, y1, weight-1);
        newBolts.add(b);
        
        //50-50 chance of creating a second branch
        if ((int)random(2) == 1) {
          Bolt b2 = new Bolt(x1, y1, weight-.8);
          newBolts.add(b2);
        }
      }
      
      //decrement lifeSpan
      lifeSpan--;
    }
    //if dead, remove
    if (lifeSpan <= 0) trashBolts.add(this);
  }
}

