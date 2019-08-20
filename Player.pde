class Player{
  Animation animation1, animation2;
  Boolean swimming, jumping;
  float direction, xspeed, yspeed;
  float gravity = 0.5;
  float ground = 0;
  float left, right, up, down;
  float size;
  float x, y; 
  PVector position, velocity;
  Mine _mine;
  
  Player(Animation animation1, Animation animation2, PVector position, float direction, PVector velocity, float xspeed, float yspeed) {
    this.animation1 = animation1;
    this.animation2 = animation2;
    this.position = position;
    this.direction = direction;
    this.velocity = velocity;
    this.xspeed = xspeed;
    this.yspeed = yspeed;
  }
  
  void direction(float x, float y) {
    xspeed = x;
    yspeed = y;
  }
  
  void update() {
    if (player.position.y < ground) {
      player.swimming = false;
      player.jumping = true;
    }
    else {
      player.velocity.y = 0;
      player.jumping = false;
      player.swimming = true;
    }
    
    if (player.position.y >= ground && up !=0) {
      player.velocity.y = -player.yspeed;
    }
    if (player.position.y <= height && down != 0) {
      player.velocity.y = player.yspeed;
    }
    
    player.velocity.x = player.xspeed * (left + right);
    
    PVector nextPosition = new PVector(player.position.x, player.position.y);
    nextPosition.add(player.velocity);
    
    size = animation1.getWidth()/2;
    float imgHeight = animation2.images[0].height/2;    
    if (nextPosition.x > size && nextPosition.x < (width - size)) {
      player.position.x = nextPosition.x;
    } 
    if (nextPosition.y > imgHeight && nextPosition.y < (height - imgHeight)) {
      player.position.y = nextPosition.y;
    } 

    
    imageMode(CORNER);
    image(background, 0, 0);
    
    pushMatrix();
    
    translate(player.position.x, player.position.y);
    
    scale(player.direction, 1);
    imageMode(CENTER);
    player.display();
    popMatrix();
  }
  
  void display() {
    if (player.jumping) {
      animation2.display(x, y);
    } else {
      animation1.display(x, y);
    }
  }

  Boolean checkCollision(float currentX, float currentY, float mineWidth, float mineHeight) {
    PVector forwardPosition = new PVector(player.position.x + animation1.getWidth()/2, player.position.y);
    PVector backwardPosition = new PVector(player.position.x - animation1.getWidth()/2, player.position.y);
    if (forwardPosition.x > (currentX - mineWidth/2) && forwardPosition.x < (currentX + mineWidth/2) &&
        forwardPosition.y > (currentY - mineHeight/2) && forwardPosition.y < (currentY + mineHeight/2)) {
      return true;
    } else if (backwardPosition.x > (currentX - mineWidth/2) && backwardPosition.x < (currentX + mineWidth/2) &&
        backwardPosition.y > (currentY - mineHeight/2) && backwardPosition.y < (currentY + mineHeight/2)) {
      return true;
        }
    return false;
  }
}
