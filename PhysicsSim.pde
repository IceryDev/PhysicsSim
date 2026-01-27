import java.util.ArrayList;
import java.util.HashMap;

float[] initialY = {230, 350};

int[] colorIncrementVal = {1, 3, 2};

ArrayList<Shape2D> objects = new ArrayList<>();

void setup(){
  size(720, 720);
  noStroke();
  rectMode(CENTER);
  
  //                      posX, posY, sizeX, sizeY
  objects.add(new Shape2D(240,  240,  50,    50, Collider2D.Square));
  objects.get(0).setColor(255, 0, 0);
  objects.add(new Shape2D(230,  350,  50,    50, Collider2D.Square));
  objects.get(1).setColor(0, 255, 0);
  objects.get(0).wrapAround = true;
  objects.get(1).wrapAround = true;
  
  objects.add(new Shape2D(350, 350, 50, 50, Collider2D.Circle));
  objects.get(2).setColor(255, 255, 255);
  //objects.get(0).rb.velocity = new Vector2D(2, 1.5);
  //objects.get(1).rb.velocity = new Vector2D(3, -1.5);
  
  
  
}

void draw(){
  background(0);
  ShapeDrawer sd = new ShapeDrawer();
  CollisionHandler ch = new CollisionHandler();
  
  
  /*for (int sqrNo = 0; sqrNo < 2; sqrNo++){
    Shape2D tempObj = objects.get(sqrNo);
    tempObj.changeColor(colorIncrementVal[0], colorIncrementVal[1], colorIncrementVal[2]);
    
    fill(tempObj.colr[0], tempObj.colr[1], tempObj.colr[2]);
    
    tempObj.rb.velocity.y += (initialY[sqrNo] - tempObj.transform.pos.y)/100;
    tempObj.update();
    Vector2D toroidalPos = tempObj.rb.getToroidalPos();
    
    sd.drawQuad(tempObj.transform.vertexTransform, tempObj.transform.translatePos(toroidalPos));
    
  }*/
  
  objects.get(1).transform.pos = new Vector2D(mouseX, mouseY);
  sd.updateAll(objects);
  ch.handleCollisions(objects);
  sd.drawQuad(objects.get(0));
  sd.drawQuad(objects.get(1));
  sd.drawCircle(objects.get(2));
}

void mousePressed(){
    if(objects.get(0).rb.angularVelocity == 0.2){
        objects.get(0).rb.angularVelocity = 0;
    }
    else {
        objects.get(0).rb.angularVelocity = 0.2;
    }
}
