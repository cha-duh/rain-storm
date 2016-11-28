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
