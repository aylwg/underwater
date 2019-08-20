class MineSpawner {
  float mineTime;
  int level;
  ArrayList<Mine> mines;
  
  MineSpawner(ArrayList<Mine> mines) {
    this.mines = mines;
    mineTime = 0.0;
    level = 1;
  }
  
  void increaseLevel() {
    level++;
  }
  
  int getLevel() {
    return level;
  }
  
  void checkTimer() {
    if (millis() > mineTime) {
      setTimer();
      spawn();
    }
  }

  void setTimer() {
    mineTime = millis() + random(1000, 2000) - ((level * 0.1) * 1000);
  }

  void spawn() {
    float xpos = (view.x + width + 50) % xmax;
    float ypos = random(40, height - 40);
    int rand = (int) random(1, 3);
    if (rand == 1) {
      mines.add(new SmallMine(xpos, ypos));
    }
    if (rand == 2) {
      mines.add(new MediumMine(xpos, ypos));
    }
    if (rand == 3) {
      mines.add(new BigMine(xpos, ypos));
    }
  }
}
