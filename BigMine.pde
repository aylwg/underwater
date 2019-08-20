class BigMine extends Mine {
  
  BigMine(float xpos, float ypos) {
    super("/assets/mine-big.png", new Animation("/assets/explosion_big_", 11), xpos, ypos, 50);
  }
}
