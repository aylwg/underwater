class Mine {
  float xpos, ypos;
  PImage image;
  Animation animation;
  float currentMineX;
  float damage;
  Boolean detonated = false;
  Boolean damaged;


  Mine(String filename, Animation animation, float mineX, float mineY, float damage) {
    this.animation = animation;
    this.xpos = mineX;
    this.ypos = mineY;
    this.damage = damage;
    image = loadImage(filename);
    image.resize(image.width*2, image.height*2);
    damaged = false;
  }

  void update() {
    float currentX = this.xpos - view.x;
    if (player.checkCollision(currentX, this.ypos, this.image.width, this.image.height)) {
      detonated = true;
      
      if (damaged && health > 0) {
        health -= damage;
        damaged = false;
      }
    } else {
      damaged = true;
    }
  }

  void display() {
    if (!detonated) {
      image(image, xpos, ypos);
    } 
    if (detonated) {
      animation.disappearDisplay(xpos, ypos);
      damage = 0;
    }
  }

  float currentPos(PVector view) {
    currentMineX = this.xpos - view.x;
    return currentMineX;
  }
}
