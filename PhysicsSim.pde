import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;



Timer gameTimer = new Timer(70);

static float MARGIN = 15;

int score = 0;
PImage[] deathSprites = new PImage[12];
PImage[] alienSprites = new PImage[3];
PImage playerSprite;
PImage playerBullet;
PImage alienBullet;
boolean onMenu = true;
boolean gameOver = false;
boolean gamePaused = false;
boolean[] keys = new boolean[3];
Alien tempAlien;
Player player;

void setup(){
  //Processing stuff
  size(720, 720, P3D);
  noStroke();
  noSmooth();
  rectMode(CENTER);

  //Sprites and handler initialisation
  for (int i = 0; i < deathSprites.length; i++){
    deathSprites[i] = loadImage("Explosion/Explosion" + String.format("%02d", i) + ".png");
  }

  for (int i = 0; i < keys.length; i++){
    keys[i] = false;
  }
  alienSprites[0] = loadImage("AlienShip2.png");
  alienSprites[1] = loadImage("AlienShip1.png");
  alienSprites[2] = loadImage("AlienShip3.png");
  playerSprite = loadImage("Player.png");
  playerBullet = loadImage("BulletPlayer.png");
  alienBullet = loadImage("Bullet1.png");
  ch = new CollisionHandler();
  sd = new ShapeDrawer();
  gameTimer.startTimer();

  player = new Player(new Shape2D(50, 50, 64, 64, ColliderType.Square, playerSprite, 128, 128), 1);
  tempAlien = new Alien(new Shape2D(50, 50, 64, 64, ColliderType.Square, alienSprites[1], 128, 128), 1);
  //objects.add(new Shape2D(360, 360, 128, 128, Collider2D.Square, alienTexture, 128, 128));
  //objects.get(0).rb.angularVelocity = 0;

  //objects.add(new Shape2D(360, 500, 20, 20, Collider2D.Circle));
  //objects.get(1).rb.velocity.y = -5;
  
}

void draw(){
  background(0);
  boolean timerTriggered = gameTimer.updateTime();
  if (timerTriggered){
    int alienType = Math.round(random(0, 2));
    tempAlien = new Alien(new Shape2D(50, 50, 64, 64, ColliderType.Square, alienSprites[alienType], 128, 128), alienType);
    gameTimer.startTimer();
  }

  for (int i = 0; i < gameObjects.size(); i++){
    gameObjects.get(i).update();
  }
  player.update();
  sd.updateAll(objects);
  ch.handleCollisions(objects);
  sd.drawAll(objects);
}

void keyPressed(){
  if (key == 'd' || key == 'D') {keys[0] = true;}
  if (key == 'a' || key == 'A') {keys[1] = true;}
  if (key == ' ') { keys[2] = true;}
}

void keyReleased(){
  if (key == 'd' || key == 'D') {keys[0] = false;}
  if (key == 'a' || key == 'A') {keys[1] = false;}
  if (key == ' ') {keys[2] = false;}
}
