import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.HashSet;
import java.util.Scanner;
import java.io.FileWriter;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.File;


boolean[] keys = new boolean[4];
Box box;

void setup(){
  //Processing stuff
  size(720, 720, P3D);
  noStroke();
  noSmooth();
  rectMode(CENTER);
  imageMode(CENTER);

  TestButton temp = new TestButton(new UIBuilder().setPos(200, 360)
                                                  .setSize(100, 50)
                                                  .setFill(255, 255, 255)
                                                  .setText("Button1")
                                                  .setType("Button")
                                                  .build());
  temp.setColor(255, 0, 0);
  temp.hasBorder = true;
  temp.borderSmooth = 10;
  temp = new TestButton(new UIBuilder().setPos(360, 360)
                                       .setSize(100, 50)
                                       .setFill(255, 255, 255)
                                       .setTextColor(0, 0, 0)
                                       .setText("Button2")
                                       .setType("Button")
                                       .build());
  temp.setColor(0, 255, 0);
  temp.hasBorder = true;
  temp.borderSmooth = 10;
  temp = new TestButton(new UIBuilder().setPos(520, 360)
                                       .setSize(100, 50)
                                       .setFill(255, 255, 255)
                                       .setText("Button3")
                                       .setType("Button")
                                       .build());
  temp.setColor(0, 0, 255);
  temp.hasBorder = true;
  temp.borderSmooth = 10;

  box = new Box(shapeBuilder.setCollider(ColliderType.Square)
                                .setPos(360, 600)
                                .setSize(100, 100)
                                .build());
  //temp.strokeThickness = 10;
  
}

void draw(){
  background(120);
  SceneManager.updateActive();
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
  EventListener.checkEvents(EventSource.MouseClick);
}

void mouseMoved(){
  EventListener.checkEvents(EventSource.MouseMove);
}

