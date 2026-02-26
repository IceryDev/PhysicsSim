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
UIElement[] counter = new UIElement[2];
int[] currentVal = {0, 0};
int sliderVal = 0;
UIElement valueDisplay;
Ball c;

void setup(){
  //Processing stuff
  size(720, 720, P3D);
  noStroke();
  noSmooth();
  rectMode(CENTER);
  imageMode(CENTER);

  UIBuilder tmp = new UIBuilder().setPos(200, 360)
                                 .setSize(100, 50)
                                 .setFill(255, 255, 255)
                                 .setText("Button1")
                                 .setType("Button")
                                 .setBorder(true);

  TestButton temp = new TestButton(tmp.build());
  temp.setColor(255, 0, 0);
  temp = new TestButton(tmp.setPos(360, 360)
                           .setText("Button2")
                           .build());
  temp.setColor(0, 255, 0);
  temp = new TestButton(tmp.setPos(520, 360)
                           .setText("Button3")
                           .build());
  temp.setColor(0, 0, 255);

  ToggleSwitch temp3 = new ToggleSwitch(tmp.setPos(200, 100)
                                           .setText("Toggle")
                                           .build());
  temp3.changeColor(120, 200, 120);

  temp3 = new ToggleSwitch(tmp.setPos(200, 150)
                              .setText("Toggle")
                              .build());
  temp3.changeColor(120, 200, 120);

  temp3 = new ToggleSwitch(tmp.setPos(200, 200)
                              .setText("Toggle")
                              .build());
  temp3.changeColor(120, 200, 120);

  SceneSwitchButton temp2 = new SceneSwitchButton(tmp.setPos(360, 100).setSize(150, 50)
                                  .setText("Change Scene")
                                  .build());
  temp2.sceneToSwitch = "1";
  SceneManager.activeScene.changeBackground(200);

  SceneManager.addScene(new Scene(true));
  SceneManager.changeScene("1");
  SceneManager.activeScene.changeBackground(120);

  temp2 = new SceneSwitchButton(tmp.setPos(360, 100)
                                  .setText("Change Back")
                                  .build());
  temp2.sceneToSwitch = "0";

  temp2 = new SceneSwitchButton(tmp.setPos(560, 100)
                                  .setText("Proceed")
                                  .setSize(100, 50)
                                  .build());
  temp2.sceneToSwitch = "3";

  counter[0] = new UIElement(tmp.setPos(180, 500)
                                       .setText("Count " + currentVal[0])
                                       .setSize(200, 100)
                                       .build());

  counter[1] = new UIElement(tmp.setPos(540, 500)
                                       .setText("Count " + currentVal[1])
                                       .setSize(200, 100)
                                       .build());

  IncrementButton a = new IncrementButton(tmp.setPos(130, 575)
                                             .setSize(100, 25)
                                             .setText("Increment")
                                             .build());
  a.textSize = 20;
  a.state = true;
  a.changeColor(0, 255, 0);

  a = new IncrementButton(tmp.setPos(230, 575)
                                             .setSize(100, 25)
                                             .setText("Decrement")
                                             .build());
  a.textSize = 20;
  a.state = false;
  a.changeColor(255, 0, 0);

  a = new IncrementButton(tmp.setPos(490, 575)
                                             .setSize(100, 25)
                                             .setText("Increment")
                                             .build());
  a.textSize = 20;
  a.state = true;
  a.effectedCounter = 1;
  a.changeColor(0, 255, 0);

  a = new IncrementButton(tmp.setPos(590, 575)
                                             .setSize(100, 25)
                                             .setText("Decrement")
                                             .build());
  a.textSize = 20;
  a.state = false;
  a.effectedCounter = 1;
  a.changeColor(255, 0, 0);

  temp = new TestButton(tmp.setPos(120, 120)
                           .setSize(200, 50)
                           .setText("TestButton")
                           .build());

  SceneManager.addScene(new Scene(true));
  SceneManager.changeScene("3");
  SceneManager.activeScene.changeBackground(100, 90, 110);

  temp2 = new SceneSwitchButton(tmp.setPos(560, 100)
                                  .setText("Revert")
                                  .setSize(100, 50)
                                  .build());
  temp2.sceneToSwitch = "1";

  UIElement line = new UIElement(tmp.setBorder(false)
                                    .setFill(255, 255, 255)
                                    .setPos(360, 680)
                                    .setSize(280, 10)
                                    .removeText()
                                    .setSmooth(20)
                                    .build());
  
  valueDisplay = new UIElement(tmp.setPos(360, 650)
                                            .setSmooth(0)
                                            .setSize(100, 20)
                                            .setText("" + sliderVal)
                                            .build());

  Handle handle = new Handle(tmp.setPos(220, 680)
                                .setSize(20, 20)
                                .removeText()
                                .setFill(200, 200, 200)
                                .build());
  handle.shape = UIShape.Ellipse;

  Border b = new Border(shapeBuilder.setCollider(ColliderType.Rectangle)
                         .setSize(width*2, 100)
                         .setPos(width/2, -50)
                         .build());
  b.shape.transform.collider.isStatic = true;

  b = new Border(shapeBuilder.setCollider(ColliderType.Rectangle)
                         .setSize(width*2, 100)
                         .setPos(width/2, height + 50)
                         .build());
  b.shape.transform.collider.isStatic = true;

  b = new Border(shapeBuilder.setCollider(ColliderType.Rectangle)
                         .setSize(100, height*2)
                         .setPos(-50, height/2)
                         .build());
  b.shape.transform.collider.isStatic = true;

  b = new Border(shapeBuilder.setCollider(ColliderType.Rectangle)
                         .setSize(100, height*2)
                         .setPos(width+50, height/2)
                         .build());
  b.shape.transform.collider.isStatic = true;

  c = new Ball(shapeBuilder.setCollider(ColliderType.Circle)
                                .setPos(360, 360)
                                .setSize(50, 50)
                                .build());

  ApplyForceButton d = new ApplyForceButton(tmp.setPos(360, 100)
                                               .setSize(200, 100)
                                               .setText("Apply Force")
                                               .build());

  SceneManager.changeScene("0");

  box = new Box(shapeBuilder.setCollider(ColliderType.Square)
                                .setPos(360, 600)
                                .setSize(100, 100)
                                .build());
  //temp.strokeThickness = 10;
  
}

void draw(){
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

void mouseReleased(){
  EventListener.checkEvents(EventSource.MouseRelease);
}

