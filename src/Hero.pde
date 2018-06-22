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
      center.x -= depth*2;
    }
  }
  void moveRight() {
    if (center.x < width) {
      center.x += depth*2;
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
      
    
