class MediumMine extends Mine {
  
  MediumMine(float xpos, float ypos) {
    super("/assets/mine.png", new Animation("/assets/explosion_", 11), xpos, ypos, 25);
  }
}
