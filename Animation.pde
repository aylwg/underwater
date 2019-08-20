// code adapted from https://processing.org/examples/animatedsprite.html
// code adapted from @jb4x on https://discourse.processing.org/t/slow-down-an-animation/10381/14

class Animation {
  int frame;
  int imageCount;
  int deltaTime = 150;
  int prevDisplayTime = 0;
  PImage[] images;
  Boolean end = false;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];
    
    for (int i = 0; i < imageCount; i++) {
      String filename = imagePrefix + i + ".png";
      images[i] = loadImage(filename);
      PImage current = images[i];
      images[i].resize(current.width*2, current.height*2);
    }
  }

  void display(float xpos, float ypos) {
    if (millis() > prevDisplayTime + deltaTime) {
      frame++;
      if (frame >= imageCount){
        frame = 0;
      }
      prevDisplayTime = millis();
    }
    image(images[frame], xpos, ypos);
  }
  
  void disappearDisplay(float xpos, float ypos) {
    if (millis() > prevDisplayTime + deltaTime) {
      frame++;
      if (frame >= imageCount){
        end = true;
      }
      prevDisplayTime = millis();
    }
    if (!end) {
      image(images[frame], xpos, ypos);
    } 
  }
  
  int getWidth() {
    return images[0].width;
  }
}
