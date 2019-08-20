// sprite sheet decomposer used https://github.com/ForkandBeard/Alferd-Spritesheet-Unpacker/releases 
// scrolling code adapted from https://discourse.processing.org/t/processing-3-moving-through-a-map-bigger-than-the-screen/10393/4
// health bar code adapted from https://www.openprocessing.org/sketch/120612/

import java.util.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer openingMusic, gameplayMusic;

Animation whale, whale_swim, jellyfish;
Animation Amine, Asmall_mine, Abig_mine;
boolean open, hiscore, settings, credits, play, first, lose, saved, pause, quit;
Button startButton, scoreButton, settingsButton, backButton, creditButton;
Button playButton, saveButton, pauseButton, resumeButton, quitButton, muteButton, unmuteButton;
float health = 100;
float MAX_HEALTH = 100;
float rectWidth = 100;
int xmax = 1600;
JSONObject scores;
JSONArray scoresArray;
ArrayList<Krill> krills;
ArrayList<Krill> openkrills;
ArrayList<Mine> mines;
PFont font;
PImage background, pauseBackground, mute, unmute;
Player player;
PVector view, scroll, speed, slow;
int level;
int krillCounter;
int score;
KrillSpawner krillSpawner;
KrillSpawner openkrillSpawner;
MineSpawner mineSpawner;

void setup() {
  
  // BASIC SETUP
  
  size(800, 600);
  open = true;
  first = true;
  font = createFont("/assets/04B_30__.TTF", 32);
  textFont(font);
  view = new PVector(0, 0);
  scroll = new PVector(4, 0);
  speed = new PVector(5, 0);
  slow = new PVector(-1, 0);
  
  // LOAD BACKGROUND IMAGES
  
  background = loadImage("/assets/background.png");
  background.resize(width, height);
  pauseBackground = loadImage("/assets/pause_background.png");
  pauseBackground.resize(width, height);
  
  // CREATE PLAYER AND LOAD SPRITES
  
  PVector position = new PVector(width/2-15, 320);
  PVector velocity = new PVector(0, 0);
  whale = new Animation("/assets/whale_", 14);
  whale_swim = new Animation("/assets/whale_jump_", 9);
  jellyfish = new Animation("/assets/jellyfish-tiny", 2);
  player = new Player(whale, whale_swim, position, 1, velocity, 4, 6);

  krills = new ArrayList<Krill>();
  krillSpawner = new KrillSpawner(krills);
  openkrills = new ArrayList<Krill>();
  openkrillSpawner = new KrillSpawner(openkrills);
  krillCounter = 0;
  mines = new ArrayList<Mine>();
  mineSpawner = new MineSpawner(mines);
  
  // BUTTONS

  int startWidth = 150;
  int startHeight = 50;
  int startX = width/2 - 75;
  int startY = height * 2/5;

  int scoreWidth = 300;
  int scoreHeight = 50;
  int scoreX = width/2 - 150;
  int scoreY = height/2;

  int backWidth = 200;
  int backHeight = 50;
  int backX = width/2 - 100;
  int backY = height * 4/5;

  int settingsWidth = 220;
  int settingsHeight = 50;
  int settingsX = width/2 - 110;
  int settingsY = height * 3/5;

  int creditWidth = 200;
  int creditHeight = 50;
  int creditX = width/2 - 100;
  int creditY = height * 3/5;

  int playWidth = 120;
  int playHeight = 50;
  int playX = width/2 - 60;
  int playY = height * 4/5;
  
  int saveWidth = 160;
  int saveHeight = 50;
  int saveX = width/2 - 80;
  int saveY = height / 2;
  
  int pauseWidth = 95;
  int pauseHeight = 30;
  int pauseX = 5;
  int pauseY = height - 35;
  
  int resumeWidth = 175;
  int resumeHeight = 50;
  int resumeX = width/2 - resumeWidth/2;
  int resumeY = height/2 - 15;
  
  int quitWidth = 175;
  int quitHeight = 50;
  int quitX = width/2 - quitWidth/2;
  int quitY = height/2 - 95;
  
  int muteWidth = 30;
  int muteHeight = 30;
  int muteX = 765;
  int muteY = height - 35;
  
  startButton = new Button("Start", startX, startY, startWidth, startHeight);
  scoreButton = new Button("High Scores", scoreX, scoreY, scoreWidth, scoreHeight);
  settingsButton = new Button("Settings", settingsX, settingsY, settingsWidth, settingsHeight);
  backButton = new Button("Go Back", backX, backY, backWidth, backHeight);
  creditButton = new Button("Credits", creditX, creditY, creditWidth, creditHeight);
  playButton = new Button("Okay", playX, playY, playWidth, playHeight);
  saveButton = new Button("Save?", saveX, saveY, saveWidth, saveHeight);
  pauseButton = new Button("Pause", 20, pauseX, pauseY, pauseWidth, pauseHeight);
  resumeButton = new Button("Resume", resumeX, resumeY, resumeWidth, resumeHeight);
  quitButton = new Button("Quit", quitX, quitY, quitWidth, quitHeight);
  mute = loadImage("/assets/mute_blue.png");
  unmute = loadImage("/assets/unmute_blue.png");
  muteButton = new Button(mute, true, muteX, muteY, muteWidth, muteHeight);
  unmuteButton = new Button(unmute, true, muteX, muteY, muteWidth, muteHeight);
  
  // LOAD SCORES FILE 

  scores = loadJSONObject("score.json");
  scoresArray = scores.getJSONArray("scores");
  
  // MINIM SETUP AND LOAD MUSIC FILES
  
  minim = new Minim(this);
  openingMusic = minim.loadFile("/sound/arcade-machine-4.wav");
  gameplayMusic = minim.loadFile("/sound/arcade-machine-5.wav");
  openingMusic.loop();
  openingMusic.play();
}

void draw() {
  background(#A1C3D1);
  
  // krill garbage collection
  
  if (!open && openkrills.size() > 0) {
    openkrills.clear();
  }
  
  // UPON OPENING, START, HIGH SCORE, SETTINGS, AND CREDIT BUTTONS APPEAR AND SOME KRILL
  
  if (open) {
    openkrillSpawner.checkTimer();
    for (Krill krill : openkrills) {
      krill.movingDisplay();
    }
    
    //fill(#F0EBF4);
    fill(#004080);
    String title = "Underwater";
    //String start = "Press Enter to Start";
    textSize(50);
    text(title, width/2 - textWidth(title)/2, height/3);
    textSize(30);
    startButton.display();
    scoreButton.display();
    //settingsButton.display();
    creditButton.display();

    if (!openingMusic.isMuted()) {
      muteButton.display();
    } else {
      unmuteButton.display();
    }
  }
  
  // UPON PRESSING HIGH SCORES BUTTON, SCORES APPEAR - create scores handler?
  
  if (hiscore) {
    textSize(50);
    String hiscores = "High Scores";
    text(hiscores, width/2 - textWidth(hiscores)/2, height/5); 
    textSize(30);
    text("Rank", width/3 - textWidth("Rank")/2, height/3);
    //text("Name", width/2 - textWidth("Name")/2, height/3);
    //println(width/2-textWidth("Name")/2);
    text("Score", width*2/3 - textWidth("Score")/2, height/3);
    for (int i = 0; i < getHighScore().size(); i++) {
      JSONObject score = scoresArray.getJSONObject(i);
      int id = score.getInt("id") + 1;
      ArrayList<String> highscores = getHighScore();
      String filescore = highscores.get(i);
      textSize(20);
      text(id, width/3 - textWidth(str(id))/2, height/3+((i+1)*30));
      text(filescore, width*2/3 - textWidth(filescore)/2, height/3+((i+1)*30));
    }
    textSize(30);
    backButton.display();
  }
  
  // UPON PRESSING SETTINGS BUTTON, SETTINGS APPEAR
  // removed because sound is frustrating 
  
  // are there settings? ... sound settings, changing hot keys
  if (settings) {
    String settings = "Settings";
    textSize(50);
    text(settings, width/2 - textWidth(settings)/2, height/5);
    textSize(20);
    String volume = "Volume";
    text(volume, width/2 - textWidth(volume)/2, height/3);
    //println(openingMusic.getGain());
    //openingMusic.shiftGain(0.0,-10.0,300);
    textSize(30);
    backButton.display();
  }
  
  // UPON PRESSING CREDITS BUTTON, CREDITS APPEAR
  
  // credits... 
  if (credits) {
    String credit = "Credits";
    textSize(50);
    text(credit, width/2 - textWidth(credit)/2, height/5); 
    textSize(25);
    String art = "Ocean Sprites by RAPIDPUNCHES";
    text(art, width/2 - textWidth(art)/2, height/3.5);
    String mine = "Mine Sprites by anismuz";
    text(mine, width/2 - textWidth(mine)/2, height/3);
    String music = "Music by RAPIDPUNCHES";
    text(music, width/2 - textWidth(music)/2, height/2.6);
    String background = "Background Art by Teriyaki_Beach";
    text(background, width/2 - textWidth(background)/2, height/2.3);
    String UI = "UI Buttons from Kicked-in-Teeth";
    text(UI, width/2 - textWidth(UI)/2, height/2.05);
    String itch = "Above items were found on itch.io";
    text(itch, width/2 - textWidth(itch)/2, height/1.5);
    textSize(30);
    backButton.display();
  }
  
  // UPON PRESSING PLAY, GAME AND PAUSE BUTTON APPEAR
  
  if (play) {
    if (!openingMusic.isMuted()) {
      openingMusic.mute();
      gameplayMusic.play();
    } else if (gameplayMusic.isMuted()) {
      gameplayMusic.mute();
    }
    if (first) {
      fill(#E6AECF);
      rect(140, 40, 520, 520, 15);
      textSize(50);
      
      fill(#F0EBF4);
      text("How To Play", width/2 - textWidth("How to Play")/2, height/5); 
      textSize(28);
      String[] instructions = {"UP/SPACE to Swim Up", "DOWN to Swim Down", "LEFT/RIGHT to Move", "P for Pause Menu", "M to Mute", "", //
                               "Eat Krill to Survive", "Avoid Bombs", "Just Stay Alive"};
      for (int i = 0; i < instructions.length; i++) {
        String current = instructions[i];
        text(current, width/2 - textWidth(current)/2, height/4+((i+1)*34));
      }
      playButton.display();
    } else {

      player.update();
      translate(-view.x, view.y);
      
      view.add(scroll);      

      if (view.x > xmax) {
        view.x = -width;
        mineSpawner.increaseLevel();
        mines.clear();
        krills.clear();
      }

      krillSpawner.checkTimer();
      for (Krill krill : krills) {
        krill.update();
        krill.display();
      }
      mineSpawner.checkTimer();
      for (Mine mine : mines) {
        mine.update();
        mine.display();
      }
      jellyfish.display(500, 300);
      
      translate(view.x, view.y);
      
      pauseButton.display();
      
      // health bar at top left
      
      fill(255);
      textSize(20);
      text("Health", 5, 20); 
      
      if (health < 25) {
        fill(255, 0, 0);
      } else if (health < 50) {
        fill(255, 200, 0);
      } else {
        fill(0, 255, 0);
      }
      
      noStroke();
      float drawWidth = (health / MAX_HEALTH) * rectWidth;
      rect(5, 25, drawWidth, 20);
      stroke(255);
      noFill();
      rect(5, 25, rectWidth, 20);
      
      // level at top right
      
      noStroke();
      fill(255);
      text("Level", width - textWidth("Level") - 5, 20);
      String level = str(mineSpawner.getLevel());
      text(level, width-textWidth("Level")/2-textWidth(level), 40);
      
      // score at bottom left
      
      text("Score", width - textWidth("Score") - 5, 570);
      text(str(krillSpawner.getScore()), width - textWidth("Score")/2-textWidth(str(krillSpawner.getScore())), 590);
    }
    if (health <= 0) {
      lose = true;
      play = false;
    }
    
  }
  
  if (lose) {
      String loser = "You lose!";
      text(loser, width/2 - textWidth(loser)/2, height/5);
      String level = "Died at level "+str(mineSpawner.getLevel())+".";
      text(level, width/2 - textWidth(level)/2, height/4);
      String krill = "Ate " +str(krillCounter)+" krill.";
      text(krill, width/2 - textWidth(krill)/2, height/3.3);
      int score = krillSpawner.getScore();
      String scoreStr = "Your score is " + score + ".";
      text(scoreStr, width/2 - textWidth(scoreStr)/2, height/2.8);

      saveButton.display();
      backButton.display();
  }
  
  // UPON PRESSING PAUSE, GAME IS PAUSED AND RESUME + QUIT BUTTONS APPEAR
  
  if (pause) {
    imageMode(CORNER);
    image(pauseBackground, 0, 0);
    String paused = "Game Paused";
    text(paused, width/2 - textWidth(paused)/2, height/4);
    resumeButton.display();
    quitButton.display();
  }
}

void restartGame() {
  PVector position = new PVector(width/2-15, 320);
  player.position = position;
  mines.clear();
  krills.clear();
  mineSpawner.level = 1;
  health = 100;
  score = 0;
  saved = false;
  if (!openingMusic.isMuted() && gameplayMusic.isMuted()){
    gameplayMusic.play();
  }
}
  
ArrayList getHighScore() {
  
  int max = 8;
  ArrayList filescores = new ArrayList();
  for (int i = 0; i < scoresArray.size(); i++) {
    JSONObject score = scoresArray.getJSONObject(i);
    String filescore = score.getString("score");
    int intscore = int(filescore);
    filescore = String.format("%03d", intscore);
    filescores.add(filescore);
  }
  //println(filescores);
  Collections.sort(filescores, Collections.reverseOrder());
  //println(filescores);
  if (filescores.size() > max) {
    ArrayList<String> topscores = new ArrayList<String>(filescores.subList(0, max));
    return topscores;
  }
  return filescores;
}

void saveScore() {
  JSONObject newScore = new JSONObject();
  newScore.setString("score", str(krillSpawner.getScore()));
  newScore.setInt("id", scoresArray.size());
  scoresArray.append(newScore);
  saveJSONObject(scores, "score.json");
}

// BUTTON CONTROLS

void mousePressed() {
  if (muteButton.hover) {
    openingMusic.mute();
    muteButton.hover = false;
  }
  if (unmuteButton.hover) {
    openingMusic.unmute();
    unmuteButton.hover = false;
  }
  if (open){
    if (startButton.hover) {
      open = false;
      play = true;
    }
    if (scoreButton.hover) {
      open = false;
      hiscore = true;
    }
    if (settingsButton.hover) {
      open = false;
      settings = true;
    }
    if (creditButton.hover) {
      open = false;
      credits = true;
    }
  } else if (backButton.hover) {
    if (hiscore) {
      hiscore = false;
      open = true;
    } if (settings) {
      settings = false;
      open = true;
    } if (credits) {
      credits = false;
      open = true;
    } if (lose) {
      lose = false;
      open = true;
    }
  }
  if (play) {
    if (playButton.hover) {
      first = false;
      if (!openingMusic.isMuted()) {
        openingMusic.mute();
        gameplayMusic.unmute();
      }
    }
    if (pauseButton.hover) {
      play = false;
      pause = true;
    } 
  } else if (lose) {
    if (saveButton.hover) {
      if (!saved) {
        saved = true;
        saveScore();
        restartGame();
        lose = false;
        hiscore = true;
      } 
    }
    if (backButton.hover) {
      saved = false;
      lose = false;
      open = true;
    }
  } else if (pause) {
    if (resumeButton.hover) {
      pause = false;
      play = true;
    }
    if (quitButton.hover){
      pause = false;
      view.x = 0;
      restartGame();
      open = true;

      pauseButton.hover = false; // what's going on here
      first = false;
      if (!gameplayMusic.isMuted()) {
        gameplayMusic.mute();
        openingMusic.unmute();
      }
    }
  }
}

// CHARACTER CONTROLS

void keyPressed() {
  if (key == 'm') {
    if (!play&&!pause&!lose) {
      if (!openingMusic.isMuted()) {
        openingMusic.mute();
      } else if (openingMusic.isMuted()) {
        openingMusic.unmute();
      } 
    }
    if (play||pause||lose) {
      if (openingMusic.isMuted() && !gameplayMusic.isMuted()) {
        gameplayMusic.mute();
      } else if (gameplayMusic.isMuted()){
        gameplayMusic.unmute();
      }
      if (!openingMusic.isMuted()) {
        gameplayMusic.play();
        gameplayMusic.loop();
      }
    }
  }
  if (open && key == ENTER) {
    open = false;
    play = true;
  }
  if (play) {
    if (key == 'p') {
      play = false;
      pause = true;
    }
    if (key == 'r') {
      play = false;
      open = true;
    }
  } else if (pause) {
    if (key == 'p') {
      pause = false;
      play = true;
    }
    if (key == 'q') {
      pause = false;
      view.x = 0;
      PVector position = new PVector(width/2-15, 320);
      player.position = position;
      mines.clear();
      krills.clear();
      mineSpawner.level = 1;
      health = 100;
      open = true;

      if (!gameplayMusic.isMuted()) {
        gameplayMusic.mute();
        openingMusic.unmute();
      }
    }
  }
  if (key == ' ') {
      player.up = -1;
  }
  if (key == CODED) {
    if (keyCode == UP) {
      player.up = -1;
    }
    if (keyCode == DOWN) {
      player.down = -1;
    }
    if (keyCode == LEFT){
      view.add(slow);
      player.left = -1;
      player.direction = -1;
    }
    if (keyCode == RIGHT){
      view.add(speed);
      player.right = 1;
      player.direction = 1;
    }
  }
}

void keyReleased() {
  if (key == ' ') {
      player.up = 0;
  }
  if (key == CODED) {
    if (keyCode == UP) {
      player.up = 0;
    }
    if (keyCode == DOWN) {
      player.down = 0;
    }
    if (keyCode == LEFT) {
      player.left = 0;
    }
    if (keyCode == RIGHT) {
      player.right = 0;
    }
  }
}

// CLOSE OUT MINIM STUFF

void stop() {
  openingMusic.close();
  gameplayMusic.close();
  minim.stop();
  super.stop();
}
