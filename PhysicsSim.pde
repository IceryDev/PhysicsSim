import java.util.ArrayList;
import java.util.HashMap;

final int MARGIN = 20;
final int LIVES = 100;
final int WIN_SCORE = LIVES;

final float BALL_SPEED = 5;
final float OP_SPEED = 2;

ArrayList<Ball> circles = new ArrayList<>();
int previousLives = LIVES;
int score = 0;
int previousScore = 0;

boolean gameRunning = true;
boolean showPause = false;

Timer keyPressTimer = new Timer(48);
Timer difficultyTimer = new Timer(500);

CollisionHandler ch;
Player player;
Opponent op;

void setup(){
  size(720, 720);
  noStroke();
  rectMode(CENTER);
  ch = new CollisionHandler();
  difficultyTimer.startTimer();
  
  //                            posX, posY, sizeX, sizeY
  player = new Player(new Shape2D(230,  350,  100,    20, Collider2D.Rectangle), LIVES);
  
  objects.add(new Shape2D(-25, height/2, 50, height * 2, Collider2D.Rectangle));
  objects.get(1).transform.collider.isStatic = true;
  
  objects.add(new Shape2D(width + 25, height/2, 50, height * 2, Collider2D.Rectangle));
  objects.get(2).transform.collider.isStatic = true;
  
  op = new Opponent(new Shape2D(230,  15 + MARGIN,  100,    20, Collider2D.Rectangle), circles, 2);
  
  circles.add(new Ball(new Shape2D(360, 360, 25, 25, Collider2D.Circle), 5, objects));
  
}

void draw(){
  background(0);
  ShapeDrawer sd = new ShapeDrawer();
  boolean keyPressAvailable = keyPressTimer.updateTime();
  boolean difficultyChange = false;
  if(gameRunning){
       difficultyChange = difficultyTimer.updateTime();
  }

  if (keyPressed){
    if ((key == 'r' || key == 'R') && gameRunning == false){
        restart();
    }
    
    if ((key == 'p' || key == 'P') && keyPressAvailable){
        gameRunning = (!gameRunning);
        showPause = (!showPause);
        keyPressTimer.startTimer();
    }

    if ((key == 'n' || key == 'N') /*&& keyPressAvailable*/){
        circles.add(new Ball(new Shape2D(360, 360, 25, 25, Collider2D.Circle), 5, objects));
        //keyPressTimer.startTimer();
    }
  }
  
  if (difficultyChange){
      gameDifficulty();
      
      difficultyTimer.startTimer();
  }
  
  if(gameRunning) {
      player.update();
      op.update();
      ch.handleCollisions(objects);
      sd.updateAll(objects); 
  }
  sd.drawAll(objects);

  fill(255, 255, 255);
  textSize(20);
  text("Bot Score: " + (WIN_SCORE - player.lives), 20, 40);
  text("Score: " + score, 20, 60);
  text("Ball Speed: " + ((!circles.isEmpty()) ? circles.get(0).gameObject.rb.velocity.magnitude() : "None"), 20, 80);
  text("Opponent Speed: " + op.speed, 20, 100);
  for (int i = 0; i < circles.size(); i++){
      if (circles.get(i).gameObject.transform.pos.y >= 750){
          player.lives--;
          circles.get(i).destroy();
      }
      else if(circles.get(i).gameObject.transform.pos.y <= -15){
          score++;
          circles.get(i).destroy();
      }
  }
  
  if (score >= WIN_SCORE){
      gameRunning = false;
      textSize(55);
      textAlign(CENTER);
      text("You Win!", 360, 360);
      textSize(25);
      text("Press R to restart.", 360, 400);
      textAlign(LEFT);
  }
  else if (player.lives <= 0){
      gameRunning = false;
      textSize(55);
      textAlign(CENTER);
      text("Game Over!", 360, 360);
      textSize(25);
      text("Press R to restart.", 360, 400);
      textAlign(LEFT);
  }
  
  if (showPause){
     textSize(55);
     textAlign(CENTER);
     text("PAUSED", 360, 360);
     textSize(25);
     text("Press P to continue.", 360, 400);
     textAlign(LEFT);
  }

  System.out.println(objects.get(1).transform.pos.x);
  System.out.println("-------------");
}

void gameDifficulty(){
    for (Ball b : circles){
        b.increaseSpeed();
    }
    op.speed += 0.3;
    circles.add(new Ball(new Shape2D(360, 360, 25, 25, Collider2D.Circle), 5, objects));
}

void mousePressed(){
    for(int i = circles.size() - 1; i >= 0; i--){
        circles.get(i).destroy();
    }
    circles.add(new Ball(new Shape2D(360, 360, 25, 25, Collider2D.Circle), 5, objects));
    previousLives = player.lives;
    previousScore = score;
}

void restart(){
    for(int i = circles.size() - 1; i >= 0; i--){
        circles.get(i).destroy();
    }
    player.lives = LIVES;
    previousLives = player.lives;
    score = 0;
    previousScore = 0;
    op.speed = OP_SPEED;
    circles.add(new Ball(new Shape2D(360, 360, 25, 25, Collider2D.Circle), 5, objects));
    gameRunning = true;
    showPause = false;
}
