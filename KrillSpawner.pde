class KrillSpawner {
  ArrayList<Krill> krills;
  float krillTime;
  
  KrillSpawner(ArrayList<Krill> krills) {
    this.krills = krills;  
    score = 0;
  }

  void incrementScore() {
    score += mineSpawner.getLevel();
  }

  int getScore() {
    return score;
  }

  void checkTimer() {
    if (millis() > krillTime) {
      setTimer();
      if (krills.size() < 20) {
      spawn();
      }
    }
  }

  void setTimer() {
    krillTime = millis() + random(1000, 2000) - ((level * 0.1) * 10);
  }

  void spawn() {
    float xpos = (view.x + width + 50) % xmax;
    float ypos = random(100, height - 50);
    
    int rand = (int) random(1, 4);
    if (rand == 1) {
      krills.add(new Krill("/assets/krill_0.png", xpos, ypos, 5, 0));
    }
    if (rand == 2) {
      krills.add(new Krill("/assets/krill_1.png", xpos, ypos, 5, 1));
    }
    if (rand == 3) {
      krills.add(new Krill("/assets/krill_2.png", xpos, ypos, 10, 2));
    }
    if (rand == 4) {
      krills.add(new Krill("/assets/krill_3.png", xpos, ypos, 10, 3));
    }
  }
}
