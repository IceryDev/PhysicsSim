import java.util.ArrayList;
import java.util.HashMap;

ArrayList<Shape2D> objects = new ArrayList<>();
CollisionHandler ch;
static float MARGIN = 20;

void setup(){
  size(720, 720);
  noStroke();
  rectMode(CENTER);
  ch = new CollisionHandler();
  
}

void draw(){
  background(0);
  ShapeDrawer sd = new ShapeDrawer();
  
}
