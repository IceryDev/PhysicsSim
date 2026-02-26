import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.HashSet;
import java.util.Scanner;
import java.io.FileWriter;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.File;

void setup(){
  //Processing setup
  size(720, 720, P3D); //P3D is required for image rendering
  noStroke(); 
  noSmooth();
  rectMode(CENTER); //Preferred coordinate alignment
  
  
}

void draw(){
  //Code here
  SceneManager.updateActive();
}
