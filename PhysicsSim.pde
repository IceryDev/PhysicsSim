import java.util.ArrayList;
import java.util.HashMap;


ArrayList<GameObject> gameObjects = new ArrayList<>();
Timer gameTimer = new Timer(70);

static float MARGIN = 15;

int score = 0;
PImage[] deathSprites = new PImage[12];
PImage[] alienSprites = new PImage[3];
PImage playerSprite;;
boolean onMenu = true;
boolean gameOver = false;
boolean gamePaused = false;
Alien tempAlien;

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
  alienSprites[0] = loadImage("AlienShip2.png");
  alienSprites[1] = loadImage("AlienShip1.png");
  alienSprites[2] = loadImage("AlienShip3.png");
  playerSprite = loadImage("Player.png");
  ch = new CollisionHandler();
  sd = new ShapeDrawer();
  gameTimer.startTimer();

  tempAlien = new Alien(new Shape2D(50, 50, 64, 64, Collider2D.Square, alienSprites[1], 128, 128));
  //objects.add(new Shape2D(360, 360, 128, 128, Collider2D.Square, alienTexture, 128, 128));
  //objects.get(0).rb.angularVelocity = 0;

  //objects.add(new Shape2D(360, 500, 20, 20, Collider2D.Circle));
  //objects.get(1).rb.velocity.y = -5;
  
}

void draw(){
  background(0);
  boolean timerTriggered = gameTimer.updateTime();
  if (timerTriggered){
    tempAlien = new Alien(new Shape2D(50, 50, 64, 64, Collider2D.Square, alienSprites[Math.round(random(0, 2))], 128, 128));
    gameTimer.startTimer();
  }

  for (int i = 0; i < gameObjects.size(); i++){
    gameObjects.get(i).update();
  }
  
  sd.updateAll(objects);
  ch.handleCollisions(objects);
  sd.drawAll(objects);
}
