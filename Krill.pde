class Krill {
  float xpos, ypos, pot, bubble_xpos, bubble_ypos;
  PImage[] images;
  PImage image;
  Boolean eaten;
  int index;
  float nextHealth;
  
  Krill(String filename, float xpos, float ypos, float pot, int index) {
    this.xpos = xpos;
    this.ypos = ypos;
    this.pot = pot;
    this.index = index;
    eaten = false;
    images = new PImage[4];
    images[index] = loadImage(filename);
    PImage current = images[index];
    images[index].resize(current.width*2, current.height*2);
    image = loadImage("/assets/bubble-tiny.png");
    image.resize(image.width/2, image.height/2);
  }
  
  Krill(String filename, float xpos, float ypos) {
    this.xpos = xpos;
    this.ypos = ypos;
    image = loadImage("/assets/bubble-tiny.png");
    image.resize(image.width/2, image.height/2);
  }
  
  void update() {
    float currentX = this.xpos - view.x;
    if (!eaten && player.checkCollision(currentX, this.ypos, this.images[index].width, this.images[index].height)) {
      eaten = true;
      health = min(health + pot, 100);
      krillCounter++;
      krillSpawner.incrementScore();
    } 
  }
  
  void display() {
    if (!eaten) {
      imageMode(CENTER);
      image(images[index], xpos, ypos);
    } 
  }
  
  void movingDisplay() {
    int deltaTime = 2000;
    int prevDisplayTime = 0;
    float prevBubbleHeight = 0;
    float deltaHeight = 100.0;
    
    if (prevBubbleHeight == 0) {
      prevBubbleHeight = ypos;
    }
    if (millis() > prevDisplayTime + deltaTime) {
      xpos--;
      if (xpos < -20) {
        xpos = 805;   
      }

      bubble_ypos--;
      if (bubble_ypos <= prevBubbleHeight - deltaHeight) {
        bubble_ypos = ypos;
        bubble_xpos = xpos;
      }
      
      prevBubbleHeight -= deltaHeight;
      prevDisplayTime = millis();
    }
    
    image(image, bubble_xpos, bubble_ypos);
    image(images[index], xpos, ypos);
  }
}
