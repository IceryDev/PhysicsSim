class GameObject{
    // This exists just to be able to put all objects into the same list

    public void update(){
        
    }

    public void onTriggerEnter(){

    }
}

class Player extends GameObject{

    int lives;
    float speed = 3;
    Shape2D gameObject;
    Timer shootCooldown = new Timer(50);
    boolean isShooting = false;
    Mathf mathf = new Mathf();

    public Player(Shape2D obj, int lives){
        this.gameObject = obj;
        this.lives = lives;
        this.gameObject.index = objects.size();
        gameObjects.add(this);
        objects.add(this.gameObject);
    }

    public void update(){
        if (keys[0]) {
            this.gameObject.transform.pos.x += this.speed;
        }
        if (keys[1]) {
            this.gameObject.transform.pos.x -= this.speed;
        }
        boolean shootAvailable = this.shootCooldown.updateTime();
        if (keys[2] && shootAvailable) {
            this.shoot();
            this.shootCooldown.startTimer();
        }

        this.gameObject.transform.pos = new Vector2D(mathf.clamp(
            this.gameObject.transform.pos.x, this.gameObject.transform.size.x / 2, width - (this.gameObject.transform.size.x / 2)),
                                                  height - (MARGIN + this.gameObject.transform.size.y / 2));
        this.gameObject.transform.translatePos();
    }

    public void shoot(){
        PlayerBullet pb = new PlayerBullet(new Shape2D(
            this.gameObject.transform.pos.x, this.gameObject.transform.pos.y, 32, 32, Collider2D.Square, playerBullet, 128, 128));
        
    }

}

class PlayerBullet extends GameObject{
    int damage = 1;
    Shape2D gameObject;
    float speed = 6;

    public PlayerBullet(Shape2D obj){
        this.gameObject = obj;
        this.gameObject.index = objects.size();
        this.gameObject.transform.collider.isTrigger = true;
        this.gameObject.rb.velocity.y = -this.speed;
        gameObjects.add(this);
        objects.add(this.gameObject);
    }

    public void update(){
        if (this.gameObject.transform.pos.y < 0){
            this.destroy();
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

class Alien extends GameObject{

    final float GAP = 15;

    int health = 1;
    boolean movingOnAxis = false; //false/true -> x/y
    boolean isDead = false;
    float targetY;
    float speed = 2;
    int direction = 1; //-1/1 -> left/right

    PImage[] deathAnim = deathSprites;
    int deathAnimFrame = -1;
    Timer frameIncrement = new Timer(5);

    Shape2D gameObject;
    Mathf mathf = new Mathf();

    public Alien(Shape2D obj){
        this.gameObject = obj;
        this.targetY = obj.transform.pos.y + (obj.transform.size.y + GAP);
        this.gameObject.index = objects.size();
        gameObjects.add(this);
        objects.add(this.gameObject);
    }

    public void update(){
        if (this.isDead){
            if(this.deathAnimFrame != -1){
                this.playDeathAnim();
            }
            else{
                this.gameObject.transform.collider.isTrigger = true;
                this.deathAnimFrame++;
                this.playDeathAnim();
                this.frameIncrement.startTimer();
            }
            return;
        }
        if (this.health <= 0) { this.isDead = true; }

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
            //System.out.println(this.targetY);
        }

        if (transform.pos.y > height - 600){this.isDead = true;}
    }

    public void move(){
        if (this.isDead) {return;}
        if (!this.movingOnAxis){
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

    public void playDeathAnim(){
        boolean updateSprite = this.frameIncrement.updateTime();
        if (updateSprite){
            if (this.deathAnimFrame != this.deathAnim.length-1){
                this.deathAnimFrame++;
                this.gameObject.sr.img = this.deathAnim[this.deathAnimFrame];
                this.frameIncrement.startTimer();
            }
            else{
                this.destroy();
            }
            
        }

    }
}
