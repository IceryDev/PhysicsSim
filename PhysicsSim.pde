import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Scanner;
import java.io.FileWriter;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.File;
import processing.sound.*;

//Constants
final float MARGIN = 40;
final int PLAYER_LIVES = 20;
final float LIVES_MARGIN = 20;
final int SPAWN_INTERVAL = 150;
final int DIFFICULTY_INTERVAL = 1400;
final int KEY_PRESS_INTERVAL = 20;
final int MAX_SHIELD_SPAWN = 700;
final String SAVE_FILE_PATH = "data.txt";
final int[][] ALIEN_SPAWN_CHANCE = {{20, 75, 5}, {30, 65, 5}, {45, 20, 35}, {30, 15, 55}};
final int ROLL_CEIL = 200;
final int[][] POWERUP_WEIGHT = {{1, 2, 20, 100}, {5, 10, 30, 25}, {15, 15, 30, 30}, {15, 20, 35, 35}};
final int SHIELD_COUNT = 2;
final int SHIELD_MARGIN = 100;
final int DIFFICULTY_ROLL_CONTRIBUTION = 2;

//Deco
Vector2D[] decoPos = new Vector2D[15];

//Timers
Timer gameTimer = new Timer(SPAWN_INTERVAL);
Timer difficultyTimer = new Timer(DIFFICULTY_INTERVAL);
Timer keyPressTimer = new Timer(KEY_PRESS_INTERVAL);
//Timer shieldSpawnTimer = new Timer(MAX_SHIELD_SPAWN);

//Score
int score = 0;
int bestScore  = 0;

//Difficulty
float alienSpeed = 2;
float alienSpeedIncrement = 0.2;
float alienMaxSpeed = 5;
float alienSpawnMin = 30;
float alienSpawnDecrement = 5;
int[] usedAlienRoll = ALIEN_SPAWN_CHANCE[0];
int[] usedPwrupWeight = POWERUP_WEIGHT[0];
int difficulty = 0;

//Sprites
PImage[] deathSprites = new PImage[12];
PImage[] alienSprites = new PImage[3];
PImage[] powerupSprites = new PImage[4];
PImage[] shieldSprites = new PImage[3];
PImage playerSprite;
PImage playerBullet;
PImage alienBullet;
PImage alienBullet2;
PImage livesIcon;
PImage starDeco;
PImage[] bossSprites = new PImage[2];

//Sounds
SoundFile explodeSFX;
SoundFile shootSFX;
SoundFile damageSFX;
SoundFile pwrupSFX;

//Font
PFont pixel;

//Flags
boolean onMenu = true;
boolean gameOver = false;
boolean gamePaused = false;
boolean[] keys = new boolean[4];
boolean playerHasPowerup1 = false;
boolean[] shieldIsUp = new boolean[SHIELD_COUNT];
boolean bossInGame = false;
boolean bossCreated = false;
boolean victory = false;

//GameObjects
Alien tempAlien;
Alien bossAlien;
Player player;
PlayButton pb;
Shield[] shields = new Shield[SHIELD_COUNT];

//Utility
ShapeDrawer sd;

void setup(){
  //Processing stuff
  size(720, 720, P3D);
  noStroke();
  noSmooth();
  rectMode(CENTER);
  loadGame();

  //Sprites and handler initialisation
  for (int i = 0; i < deathSprites.length; i++){
    deathSprites[i] = loadImage("Explosion/Explosion" + String.format("%02d", i) + ".png");
  }

  for (int i = 0; i < shieldSprites.length; i++){
    shieldSprites[i] = loadImage("Assets/Shield" + i + ".png");
  }

  for (int i = 0; i < 15; i++){
    decoPos[i] = new Vector2D(random(0, 720), random(0, 720));
  }

  for (int i = 0; i < keys.length; i++){
    keys[i] = false;
  }

  powerupSprites[0] = loadImage("Assets/MultiShot.png");
  powerupSprites[1] = loadImage("Assets/PenetratingBullet.png");
  powerupSprites[2] = loadImage("Assets/FasterReload.png");
  powerupSprites[3] = loadImage("Assets/ShieldPowerup.png");
  alienSprites[0] = loadImage("Assets/AlienShip1.png");
  alienSprites[1] = loadImage("Assets/AlienShip3.png");
  alienSprites[2] = loadImage("Assets/AlienShip2.png");
  playerSprite = loadImage("Assets/Player.png");
  playerBullet = loadImage("Assets/BulletPlayer.png");
  alienBullet = loadImage("Assets/Bullet1.png");
  alienBullet2 = loadImage("Assets/Bullet2.png");
  livesIcon = loadImage("Assets/PlayerLives.png");
  starDeco = loadImage("Assets/Stars1.png");
  bossSprites[0] = loadImage("Assets/Boss/boss0.png");
  bossSprites[1] = loadImage("Assets/Boss/boss1.png");

  explodeSFX = new SoundFile(this, "Assets/Sound/explosion.wav");
  damageSFX = new SoundFile(this, "Assets/Sound/hitHurt.wav");
  shootSFX = new SoundFile(this, "Assets/Sound/laserShoot.wav");
  pwrupSFX = new SoundFile(this, "Assets/Sound/powerUp.wav");
  
  pixel = createFont("Fonts/PIXSPACE-DEMO.ttf", 128);
  textFont(pixel);
  sd = new ShapeDrawer();
  defaultScene.removeHandler(UtilityType.Shapes);
  gameTimer.startTimer();
  difficultyTimer.startTimer();
  keyPressTimer.startTimer();
  //shieldSpawnTimer.startTimer();

  //Object Instantiation
  pb = new PlayButton(360, 450, 140, 50);
  player = new Player(new Shape2D(50, 50, 48, 48, ColliderType.Square, playerSprite, 96, 96), PLAYER_LIVES);
  
}

void draw(){
  background(0);

  //Draw Deco
  imageMode(CENTER);
  for (int i = 0; i < 15; i++){
    image(starDeco, decoPos[i].x, decoPos[i].y, 32, 32);
  }

  if (!onMenu){
    boolean keyPressAvailable = keyPressTimer.updateTime();
    if (keyPressAvailable && keys[3]){
      gamePaused = !gamePaused;
      keyPressTimer.startTimer();
    }

    if (!gamePaused && !gameOver && !victory){
      if (!bossInGame){
        boolean timerTriggered = gameTimer.updateTime();
        if (timerTriggered){
          int alienRoll = mathf.randInt(100);
          int alienType = 0;
          for (int i = 0, cumulative = 0; i < usedAlienRoll.length; i++){
            cumulative += usedAlienRoll[i];
            if (alienRoll < cumulative){
              alienType = i;
              break;
            }
          }
          tempAlien = new Alien(new Shape2D(50, 50, 48, 48, ColliderType.Square, alienSprites[alienType], 96, 96), alienType);
          tempAlien.speed = (alienType == 1) ? alienSpeed + 1 : alienSpeed;
          tempAlien.shape.transform.collider.isTrigger = true;
          gameTimer.startTimer();
        }

        if (score > 30) {
          bossInGame = true;
        }
      }
      else if(!bossCreated){
          bossAlien = new Alien(new Shape2D(50, 50, 64, 64, ColliderType.Square, bossSprites[0], 128, 128), true);
          bossAlien.shape.transform.collider.isTrigger = true;
          gameTimer.startTimer();
          bossCreated = true;
      }
      else {
        fill(255);
        text("Big Bob", width/2, 20);
        fill(150);
        rect(width/2, 50, 200, 50);
        fill(255, 0, 0);
        int rectWidth = 18 * bossAlien.health;
        rect(width/2 - (180-(rectWidth))/2, 50, rectWidth, 40);
      }

      // if(shieldSpawnTimer.updateTime()){
      //   new Shield(shapeBuilder.setPos(mathf.randInt(width-64) + 32, 600)
      //                          .setSize(64, 16)
      //                          .setCollider(ColliderType.Rectangle)
      //                          .addImage(shieldSprites[0], 96, 96)
      //                          .build());
      //   shieldSpawnTimer.totalTime = mathf.randInt(MAX_SHIELD_SPAWN) + 300;
      //   shieldSpawnTimer.startTimer();
      // }

      boolean difficultyIncease = difficultyTimer.updateTime();
      if (difficultyIncease){
        increaseDifficulty();
        difficultyTimer.startTimer();
      }

      SceneManager.updateActive();
    }
    sd.update(SceneManager.activeScene);

    if (gameOver){
      fill(255, 50, 50);
      textSize(55);
      textAlign(CENTER);
      text("GAME OVER", 360, 360);
      textSize(25);
      fill(255, 255, 255);
      if (bestScore < score) {bestScore = score;}
      text("Score: " + score + "    Best: " + bestScore, 360, 390);
      text("Click anywhere to return to main menu.", 360, 420);
      textAlign(LEFT);
    } 
    else if (gamePaused){
      fill(150, 90, 50);
      textSize(55);
      textAlign(CENTER);
      text("PAUSED", 360, 360);
      textSize(25);
      text("Press P to continue.", 360, 400);
      textAlign(LEFT);
    }
    else if (victory){
      fill(50, 255, 255);
      textSize(55);
      textAlign(CENTER);
      text("VICTORY", 360, 360);
      textSize(25);
      text("Press any key to return to menu.", 360, 400);
      textAlign(LEFT);
    }

    fill(255, 255, 255);
    textSize(20);
    textAlign(LEFT);
    text("SCORE: " + score, LIVES_MARGIN - 7.5, 665);
    text("DIFFICULTY: " + difficulty, LIVES_MARGIN - 7.5, 685);

    for (int i = 0; i < shields.length; i++){
      if (shields[i] != null){
        fill(255);
        textSize(20);
        textAlign(LEFT);
        text("Shield " + i + " health: " + shields[i].shieldHealth, LIVES_MARGIN - 7.5, 640 - i * 20);
      }
    }

    for (int i = 0; i < player.lives; i++){
      imageMode(CENTER);
      image(livesIcon, LIVES_MARGIN + (i * (20)), 700, 15, 15);
    }
  }
  else {
    fill(255, 255, 255);
    textSize(55);
    textAlign(CENTER);
    text("Invaded Space", 360, 100);
    textSize(25);
    text("Best Score: " + bestScore, 360, 140);
    

    fill(0);
    stroke(255);
    strokeWeight(4);
    rect(pb.pos.x, pb.pos.y, pb.width, pb.height);
    noStroke();

    fill(255);
    text("Play", pb.pos.x, pb.pos.y + 10);
  }
  
}

void keyPressed(){
  if (key == 'd' || key == 'D') {keys[0] = true;}
  if (key == 'a' || key == 'A') {keys[1] = true;}
  if (key == ' ') { keys[2] = true;}
  if (key == 'p' || key == 'P') {keys[3] = true;}
}

void keyReleased(){
  if (key == 'd' || key == 'D') {keys[0] = false;}
  if (key == 'a' || key == 'A') {keys[1] = false;}
  if (key == ' ') {keys[2] = false;}
  if (key == 'p' || key == 'P') {keys[3] = false;}
}

void mousePressed(){

  if (onMenu){
    if (pb.isClickedOn()) {
      onMenu = false;
      resetGame();
    }
  }
  else{
    if (!gameOver && !victory) {return;}
    onMenu = true;
    saveGame();
  }
  
}

void increaseDifficulty(){
  if (alienSpeed < alienMaxSpeed) { 
    alienSpeed += alienSpeedIncrement;
    for (GameObject o : defaultScene.gameObjects){
      if (o.tag.equals("Alien")){
        Alien alien = (Alien) o;
        alien.speed += alienSpeedIncrement;
      }
    }
  }

  if (gameTimer.totalTime > alienSpawnMin){
    gameTimer.totalTime -= alienSpawnDecrement;
    difficulty++;
  }

  switch(difficulty){
    case 2:
      usedAlienRoll = ALIEN_SPAWN_CHANCE[1];
      usedPwrupWeight = POWERUP_WEIGHT[1];
      break;
    case 4:
      usedAlienRoll = ALIEN_SPAWN_CHANCE[2];
      usedPwrupWeight = POWERUP_WEIGHT[2];
      break;
    case 7:
      usedAlienRoll = ALIEN_SPAWN_CHANCE[3];
      usedPwrupWeight = POWERUP_WEIGHT[3];
      break;
    default:
  }
  
  
}

void resetGame(){
  for (int i = defaultScene.gameObjects.size() - 1; i >= 0; i--){
    GameObject o = defaultScene.gameObjects.get(i);
    if (!o.tag.equals("Player")){
      o.destroy();
    }
  }
  score = 0;
  difficulty = 0;
  alienSpeed = 2;
  gameTimer.totalTime = 70;
  onMenu = false;
  gameOver = false;
  gamePaused = false;
  victory = false;
  bossInGame = false;
  bossCreated = false;
  player.isAlive = true;

  difficultyTimer.startTimer();
  gameTimer.startTimer();

  player.lives = PLAYER_LIVES;
}

void saveGame(){
  saveStrings(SAVE_FILE_PATH, new String[]{ str(score) });
}

void loadGame(){
  File saveFile = new File(sketchPath(SAVE_FILE_PATH));
  if (!saveFile.exists()) { 
    println("File does not exist at: " + saveFile.getAbsolutePath());
    return; 
  }

  String[] data = loadStrings(SAVE_FILE_PATH);
  if (data != null && data.length == 1){
    bestScore = Integer.parseInt(data[0]);
  }
}
