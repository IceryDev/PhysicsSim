import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Scanner;
import java.io.FileWriter;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.File;

//Constants
final float MARGIN = 40;
final int PLAYER_LIVES = 10;
final float LIVES_MARGIN = 20;
final int SPAWN_INTERVAL = 150;
final int DIFFICULTY_INTERVAL = 1000;
final int KEY_PRESS_INTERVAL = 20;
final String SAVE_FILE_PATH = "data.txt";

//Deco
Vector2D[] decoPos = new Vector2D[15];

//Timers
Timer gameTimer = new Timer(SPAWN_INTERVAL);
Timer difficultyTimer = new Timer(DIFFICULTY_INTERVAL);
Timer keyPressTimer = new Timer(KEY_PRESS_INTERVAL);

//Score
int score = 0;
int bestScore  = 0;

//Difficulty
float alienSpeed = 2;
float alienSpeedIncrement = 0.2;
float alienMaxSpeed = 5;
float alienSpawnMin = 30;
float alienSpawnDecrement = 5;
int difficulty = 0;

//Sprites
PImage[] deathSprites = new PImage[12];
PImage[] alienSprites = new PImage[3];
PImage playerSprite;
PImage playerBullet;
PImage alienBullet;
PImage livesIcon;
PImage starDeco;

//Font
PFont pixel;

//Flags
boolean onMenu = true;
boolean gameOver = false;
boolean gamePaused = false;
boolean[] keys = new boolean[4];

//GameObjects
Alien tempAlien;
Player player;
PlayButton pb;

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

  for (int i = 0; i < 15; i++){
    decoPos[i] = new Vector2D(random(0, 720), random(0, 720));
  }

  for (int i = 0; i < keys.length; i++){
    keys[i] = false;
  }
  alienSprites[0] = loadImage("AlienShip1.png");
  alienSprites[1] = loadImage("AlienShip3.png");
  alienSprites[2] = loadImage("AlienShip2.png");
  playerSprite = loadImage("Player.png");
  playerBullet = loadImage("BulletPlayer.png");
  alienBullet = loadImage("Bullet1.png");
  livesIcon = loadImage("PlayerLives.png");
  starDeco = loadImage("Stars1.png");
  pixel = createFont("Fonts/PIXSPACE-DEMO.ttf", 128);
  textFont(pixel);
  sd = new ShapeDrawer();
  defaultScene.removeHandler(UtilityType.Shapes);
  gameTimer.startTimer();
  difficultyTimer.startTimer();
  keyPressTimer.startTimer();

  //Object Instantiation
  pb = new PlayButton(360, 450, 140, 50);
  player = new Player(new Shape2D(50, 50, 64, 64, ColliderType.Square, playerSprite, 128, 128), PLAYER_LIVES);
  
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

    if (!gamePaused && !gameOver){
      boolean timerTriggered = gameTimer.updateTime();
      if (timerTriggered){
        int alienType = Math.round(random(0, 2));
        tempAlien = new Alien(new Shape2D(50, 50, 64, 64, ColliderType.Square, alienSprites[alienType], 128, 128), alienType);
        tempAlien.speed = alienSpeed;
        gameTimer.startTimer();
      }

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

    fill(255, 255, 255);
    textSize(20);
    textAlign(LEFT);
    text("SCORE: " + score, LIVES_MARGIN - 7.5, 665);
    text("DIFFICULTY: " + difficulty, LIVES_MARGIN - 7.5, 685);

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
    if (!gameOver) {return;}
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
  player.isAlive = true;

  difficultyTimer.startTimer();
  gameTimer.startTimer();

  player.lives = PLAYER_LIVES;
}

void saveGame(){
  try (FileWriter fw = new FileWriter(SAVE_FILE_PATH)){
    fw.write(score);
    System.out.println("Game Saved!");
  }
  catch (IOException e){
    System.err.println("An error occurred while writing to file.");
    e.printStackTrace();
  }
}

void loadGame(){
  File saveFile = new File(SAVE_FILE_PATH);
  if (!saveFile.exists()) { return; }

  try (Scanner reader = new Scanner(saveFile)){
    if (reader.hasNextInt()){
      bestScore = reader.nextInt();
      System.out.println("Game Loaded!");
      System.out.println(bestScore);
    }
  }
  catch (FileNotFoundException e){
    System.out.println("An error occurred while loading game.");
    e.printStackTrace();
  }
}
