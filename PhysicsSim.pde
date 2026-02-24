import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Scanner;
import java.io.FileWriter;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.File;


boolean[] keys = new boolean[4];


void setup(){
  //Processing stuff
  size(720, 720, P3D);
  noStroke();
  noSmooth();
  rectMode(CENTER);
  imageMode(CENTER);

  UIElement temp = new UIElement().setPos(360, 360).setSize(200, 100);
  temp.setText("Test this text").setFill(100, 0, 255).setTextColor(255, 255, 255);
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

  
  
}

