import java.util.ArrayList;
import java.util.HashMap;

ArrayList<Shape2D> objects = new ArrayList<>();
CollisionHandler ch;
ShapeDrawer sd;
static float MARGIN = 20;

void setup(){
  size(720, 720, P3D);
  noSmooth();
  rectMode(CENTER);
  ch = new CollisionHandler();
  sd = new ShapeDrawer();
  PImage alienTexture = loadImage("AlienShip1.png");
  objects.add(new Shape2D(360, 360, 256, 256, Collider2D.Square, alienTexture, 256, 256));
  objects.get(0).rb.angularVelocity = 0.2;
  
}

void draw(){
  background(0);
  
  sd.updateAll(objects);
  sd.drawAll(objects);
}
