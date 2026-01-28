import java.util.ArrayList;
import java.util.HashMap;

float[] initialY = {230, 350};

int[] colorIncrementVal = {1, 3, 2};

ArrayList<Shape2D> objects = new ArrayList<>();
CollisionHandler ch;

final int MARGIN = 20;

void setup(){
  size(720, 720);
  noStroke();
  rectMode(CENTER);
  ch = new CollisionHandler();
  
  //                      posX, posY, sizeX, sizeY
  objects.add(new Shape2D(240,  240,  50,    50, Collider2D.Square));
  objects.get(0).setColor(255, 0, 0);
  objects.get(0).rb.mass = 2;
  objects.add(new Shape2D(230,  350,  100,    30, Collider2D.Rectangle));
  objects.get(1).setColor(0, 255, 0);
  objects.get(1).transform.collider.isStatic = true;
  
  objects.get(0).wrapAround = false;
  objects.get(1).wrapAround = false;
  
  objects.add(new Shape2D(470, 470, 25, 25, Collider2D.Circle));
  objects.get(2).setColor(255, 255, 255);
  objects.get(2).rb.velocity = new Vector2D(-4, -5);
  
  objects.add(new Shape2D(-25, height/2, 50, height * 2, Collider2D.Rectangle));
  objects.get(3).transform.collider.isStatic = true;
  
  objects.add(new Shape2D(width + 25, height/2, 50, height * 2, Collider2D.Rectangle));
  objects.get(4).transform.collider.isStatic = true;
  
  objects.add(new Shape2D(width/2, -25, width, 50, Collider2D.Rectangle));
  objects.get(5).transform.collider.isStatic = true;
  
  
  
}

void draw(){
  background(0);
  ShapeDrawer sd = new ShapeDrawer();
  
  
  /*for (int sqrNo = 0; sqrNo < 2; sqrNo++){
    Shape2D tempObj = objects.get(sqrNo);
    tempObj.changeColor(colorIncrementVal[0], colorIncrementVal[1], colorIncrementVal[2]);
    
    fill(tempObj.colr[0], tempObj.colr[1], tempObj.colr[2]);
    
    tempObj.rb.velocity.y += (initialY[sqrNo] - tempObj.transform.pos.y)/100;
    tempObj.update();
    Vector2D toroidalPos = tempObj.rb.getToroidalPos();
    
    sd.drawQuad(tempObj.transform.vertexTransform, tempObj.transform.translatePos(toroidalPos));
    
  }*/
  
  objects.get(1).transform.pos = new Vector2D(mouseX, height - (MARGIN + objects.get(1).transform.size.y / 2));
  objects.get(1).transform.translatePos();
  ch.handleCollisions(objects);
  sd.updateAll(objects); 
  sd.drawQuad(objects.get(0));
  sd.drawQuad(objects.get(1));
  sd.drawCircle(objects.get(2));
  sd.drawQuad(objects.get(3));
  sd.drawQuad(objects.get(4));
  sd.drawQuad(objects.get(5));
}

void mousePressed(){
    if(objects.get(0).rb.angularVelocity == 0.2){
        objects.get(0).rb.angularVelocity = 0;
    }
    else {
        objects.get(0).rb.angularVelocity = 0.2;
    }
}
