## Physics Sim
- A physics simulator/game engine to facilitate my work in my Programming Project module. It uses Processing hence Java and the naming conventions and object hierarchies are highly inspired from the Unity game engine.
### Functions:
- Rigidbodies that support linear and angular motion (although torque has not been implemented yet)
- Separating Axis Theorem (SAT) collision detection and calculations for elastic/inelastic (or in between) collision results (collisions for now apply to rectangles and circles)
- Sprite rendering
- Built-in assets (Timer & GameObject) that allow scriptable game mechanics and collision response

### How to Use:
- The PhysicsSim.pde file is the main file where the standard Processing functions (setup and draw) reside
- Use the Assets.pde file to declare custom game objects to be instantiated

#### Initialise Environment
- To draw and update each object, we need a ShapeDrawer and if we need to handle collisions, we need a CollisionHandler
- Both are declared as sd and ch in the BuiltIns.pde file, initialise both in the main (PhysicsSim.pde) file
```java
void setup(){
  ch = new CollisionHandler();
  sd = new ShapeDrawer();
}
```
- Append the following lines to (preferably) the end of the Processing draw() method
```java
void draw(){
  ...

  for (int i = 0; i < gameObjects.size(); i++){
      gameObjects.get(i).update();
  }
  ch.handleCollisions(objects);
  sd.drawAll(objects);
}
```
- Where objects, gameObjects are lists of all the Shape2D's and GameObjects, respectively. (The for loop will also be automated in the future)
#### Create a GameObject
- Create a class that inherits from GameObject
```java
class Player extends GameObject {

}
```
- Each GameObject must call the parent class' constructor in its own constructor
```java
class Player extends GameObject {

  public Player(Shape2D obj){
      super(obj);
      //Your code here
  }
}
```
- (Optional) You can also change the tag of the GameObject or add new attributes
```java
class Player extends GameObject {

  public Player(Shape2D obj){
      super(obj);
      this.lives = lives;
      this.tag = "Player";
      //Your code here
  }
}
```
- Now you can switch to the main file (PhysicsSim.pde) and create the object by using standard Java object creation methods within the setup() method
- Each GameObject has to take at least one parameter of type Shape2D, which itself takes the parameters below (This will later be updated to a factory design for ease of use)
```java
void setup(){
  //The last three parameters are optional, if not provided, the engine will draw the shape of the collider type specified.
  //Possible collider types: ColliderType.Square, ColliderType.Rectangle, ColliderType.Circle
  Player player = new Player(new Shape2D(float posX, float posY, float sizeX, float sizeY,
                              ColliderType ct, PImage img, float imgSizeX, float imgSizeY));
}
```
#### GameObject methods
- update(): Runs every frame, include it in your class to change behaviour
```java
class Player extends GameObject {
  ...
  @Override
  public void update(){
    //This part runs every frame
  }
}
```
- destroy(): Removes the object from both the *objects* and *gameObjects* list, and hence destroys the object. Run:
```java
class Player extends GameObject {
  ...
  public void gameOver(int lives){
    if (lives <= 0) { this.destroy(); }
  }
}
```
- onCollisionEnter(GameObject other): Triggers when the current object collides with a non-trigger collider, you can compare the tag of the other object to run on specific collisions
```java
class Player extends GameObject {
  ...
  @Override
  public void onCollisionEnter(GameObject other){
    if (other.tag.equals("Bullet")){
      this.lives--;
    }
  }
}
```
- onTriggerEnter(GameObject other): Triggers when the current object collides with a trigger collider (Does not trigger if both objects are triggers)
```java
class Player extends GameObject {
  ...
  @Override
  public void onTriggerEnter(GameObject other){
    //Code here
  }
}
```
- onCollisionExit(GameObject other): Triggers when the current object stops colliding with a non-trigger collider
```java
class Player extends GameObject {
  ...
  @Override
  public void onCollisionExit(GameObject other){
    //Code here
  }
}
```
- onTriggerExit(GameObject other): Triggers when the current object stops colliding with a trigger collider (Does not trigger if both objects are triggers)
```java
class Player extends GameObject {
  ...
  @Override
  public void onTriggerExit(GameObject other){
    //Code here
  }
}
```

**Note: This documentation is still work in progress.**
