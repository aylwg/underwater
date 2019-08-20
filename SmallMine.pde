class SmallMine extends Mine {
  
  SmallMine(float xpos, float ypos) {
    super("/assets/mine-small.png", new Animation("/assets/explosion_small_", 11), xpos, ypos, 10);
  }
}
