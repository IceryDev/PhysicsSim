class GameObject{
    // This exists just to be able to put all objects into the same list

    public void update(){
        
    }
}

class Player extends GameObject{

    int lives;
    Shape2D gameObject;
    Mathf mathf = new Mathf();

    public Player(Shape2D obj, int lives){
        this.gameObject = obj;
        this.lives = lives;
        this.gameObject.index = objects.size();
        gameObjects.add(this);
        objects.add(this.gameObject);
        this.gameObject.setColor(0, 255, 0);
        this.gameObject.transform.collider.isStatic = true;
        this.gameObject.wrapAround = false;
    }

    public void update(){
        this.gameObject.transform.pos = new Vector2D(mathf.clamp(
            mouseX, this.gameObject.transform.size.x / 2, width - (this.gameObject.transform.size.x / 2)),
                                                  height - (MARGIN + this.gameObject.transform.size.y / 2));
        this.gameObject.transform.translatePos();
        if (keyPressed) {
            if (key == 'd' || key == 'D') {
                this.gameObject.transform.setRotation(mathf.deg2Rad(20));
            }
            else if(key == 'a' || key == 'A') {
                this.gameObject.transform.setRotation(mathf.deg2Rad(-20));
            }
            
        }
        else {
            this.gameObject.transform.setRotation(mathf.deg2Rad(0));    
        }
    }

}

class Alien extends GameObject{

    final float GAP = 15;

    int health = 1;
    boolean movingOnAxis = false; //false/true -> x/y
    boolean isDead = false;
    float targetY;
    float speed = 2;
    int direction = 1; //-1/1 -> left/right

    PImage[] deathAnim;

    Shape2D gameObject;
    Mathf mathf = new Mathf();

    public Alien(Shape2D obj){
        this.gameObject = obj;
        this.targetY = obj.transform.pos.y + (obj.transform.size.y + GAP);
        System.out.println(this.targetY);
        this.gameObject.index = objects.size();
        gameObjects.add(this);
        objects.add(this.gameObject);
    }

    public void update(){
        this.move();
        Transform transform = this.gameObject.transform;
        if (!this.movingOnAxis && (transform.pos.x + transform.size.x/2 + GAP >= width || transform.pos.x - transform.size.x/2 - GAP <= 0)){
            this.movingOnAxis = !this.movingOnAxis;
            this.gameObject.transform.pos.x -= this.speed * this.direction;
            this.direction *= -1;
        }
        else if (this.movingOnAxis && (this.targetY - transform.pos.y) < 0.1){
            this.movingOnAxis = !this.movingOnAxis;
            this.targetY = transform.pos.y + (transform.size.y + GAP);
            System.out.println(this.targetY);
        }
    }

    public void move(){
        if (!movingOnAxis){
            this.gameObject.transform.pos.x += this.speed * this.direction;
        }
        else{
            this.gameObject.transform.pos.y += this.speed;
        }
    }

    public void destroy(){
        for (int i = 0; i < objects.size(); i++){
            if (i > this.gameObject.index){
                objects.get(i).index--;
            }
        }
        objects.remove(this.gameObject.index);
        gameObjects.remove(this.gameObject.index);

    }
}
