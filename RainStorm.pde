ArrayList<Bolt> bolts;
ArrayList<Bolt> trashBolts;
ArrayList<Bolt> newBolts;
int boltCount;
Rain storm;
Hero h;

void setup() {
  size(400,400);
  bolts = new ArrayList<Bolt>();
  trashBolts = new ArrayList<Bolt>();
  newBolts = new ArrayList<Bolt>();
  boltCount = (int)random(1,200);
  storm = new Rain();
  h = new Hero(new PVector(width/2,height-50));
}

void draw() {
  //fill background with translucent black
  rectMode(CORNER);
  fill(0,40);
  rect(0,0,width,height);
  
  //if our boltnumber is reached, send bolt
  if (frameCount%boltCount == 0) {
    //fill background with one frame of slightly translucent whitish
    fill(200,200);
    rect(0,0,width,height);
    
    //create and add ONE new bolt to the arraylist
    Bolt b = new Bolt(random(width),0,random(2,4));
    bolts.add(b);
    
    //reset the random magic bolt number
    boltCount = (int)random(1,200);
  }
  
  //This many arraylists is pretty dumb.
  //Only meant to show you that you can pass pointers
  //to objects between them easily.
  
  //Removes dead bolts
  //Enhanced for loop reads:
  // "for every Bolt "b" in the list trashBolts, remove b from bolts.
  for (Bolt b : trashBolts) {
    bolts.remove(b);
  }
  //empties the arraylist of trashbolts
  trashBolts = new ArrayList<Bolt>();
  
  //adds fresh bolts
  for (Bolt b : newBolts) {
    bolts.add(b);
  }
  //empties the arraylist of new bolts
  newBolts = new ArrayList<Bolt>();
  
  //draws the living bolts
  for (Bolt b : bolts) {
    b.drawBolt();
  }
  
  h.drawHero();
  
  //draw raindrops
  storm.drawRain();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      h.moveUp();
    } else if (keyCode == DOWN) {
      h.moveDown();
    } 
    if (keyCode == LEFT) {
      h.moveLeft();
    } else if (keyCode == RIGHT) {
      h.moveRight();
    }
  }
}
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

class Hero {
  
  PVector center;
  float depth;
  float size;
  
  Hero(PVector c) {
    center = c;
    depth = map(center.y,3*height/4,height,1,5);
  }
  
  //motion handlers
  void moveUp() {
    if (center.y > 3*height/4) {
      center.y -= 2;
    }
  }
  void moveDown() {
    if (center.y < height) {
      center.y += 2;
    }
  }
  void moveLeft() {
    if (center.x > 0) {
      center.x -= 2;
    }
  }
  void moveRight() {
    if (center.x < width) {
      center.x += 2;
    }
  }
  
  //draw method
  void drawHero() {
    //map depth to y location with output 1-5
    depth = map(center.y,3*height/4,height,1,5);
    //relate size to depth for impression of three dimensions
    size = depth*5 + 30;
    
    //if you don't change stroke or weight, it will
    //match that of the bolts
    fill(130);
    rectMode(CENTER);
    rect(center.x,center.y,size,size);
  }
}
      
    
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

