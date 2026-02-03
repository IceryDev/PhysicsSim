class Player extends GameObject{

    int lives;
    float speed = 3;
    Timer shootCooldown = new Timer(50);
    boolean isShooting = false;
    Mathf mathf = new Mathf();

    public Player(Shape2D obj, int lives){
        super(obj);
        this.lives = lives;
        this.shape.index = objects.size();
        gameObjects.add(this);
        objects.add(this.shape);
    }

    public void update(){
        if (keys[0]) {
            this.shape.transform.pos.x += this.speed;
        }
        if (keys[1]) {
            this.shape.transform.pos.x -= this.speed;
        }
        boolean shootAvailable = this.shootCooldown.updateTime();
        if (keys[2] && shootAvailable) {
            this.shoot();
            this.shootCooldown.startTimer();
        }

        this.shape.transform.pos = new Vector2D(mathf.clamp(
            this.shape.transform.pos.x, this.shape.transform.size.x / 2, width - (this.shape.transform.size.x / 2)),
                                                  height - (MARGIN + this.shape.transform.size.y / 2));
        this.shape.transform.translatePos();
    }

    public void shoot(){
        PlayerBullet pb = new PlayerBullet(new Shape2D(
            this.shape.transform.pos.x, this.shape.transform.pos.y, 32, 32, ColliderType.Square, playerBullet, 128, 128));
        
    }

}

class PlayerBullet extends GameObject{
    int damage = 1;
    float speed = 15;

    public PlayerBullet(Shape2D obj){
        super(obj);
        this.shape.index = objects.size();
        this.tag = "Bullet";
        this.shape.transform.collider.isTrigger = true;
        this.shape.rb.velocity.y = -this.speed;
        gameObjects.add(this);
        objects.add(this.shape);
    }

    public void update(){
        if (this.shape.transform.pos.y < 0){
            this.destroy();
        }
    }

    public void destroy(){
        for (int i = 0; i < objects.size(); i++){
            if (i > this.shape.index){
                objects.get(i).index--;
            }
        }
        objects.remove(this.shape.index);
        gameObjects.remove(this.shape.index);
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

    Mathf mathf = new Mathf();

    public Alien(Shape2D obj){
        super(obj);
        this.targetY = obj.transform.pos.y + (obj.transform.size.y + GAP);
        this.shape.index = objects.size();
        gameObjects.add(this);
        objects.add(this.shape);
    }

    public void update(){
        if (this.isDead){
            if(this.deathAnimFrame != -1){
                this.playDeathAnim();
            }
            else{
                this.shape.transform.collider.isTrigger = true;
                this.deathAnimFrame++;
                this.playDeathAnim();
                this.frameIncrement.startTimer();
            }
            return;
        }
        if (this.health <= 0) { this.isDead = true; }

        this.move();
        Transform transform = this.shape.transform;
        if (!this.movingOnAxis && (transform.pos.x + transform.size.x/2 + GAP >= width || transform.pos.x - transform.size.x/2 - GAP <= 0)){
            this.movingOnAxis = !this.movingOnAxis;
            this.shape.transform.pos.x -= this.speed * this.direction;
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
            this.shape.transform.pos.x += this.speed * this.direction;
        }
        else{
            this.shape.transform.pos.y += this.speed;
        }
    }

    public void destroy(){
        for (int i = 0; i < objects.size(); i++){
            if (i > this.shape.index){
                objects.get(i).index--;
            }
        }
        objects.remove(this.shape.index);
        gameObjects.remove(this.shape.index);
    }

    public void playDeathAnim(){
        boolean updateSprite = this.frameIncrement.updateTime();
        if (updateSprite){
            if (this.deathAnimFrame != this.deathAnim.length-1){
                this.deathAnimFrame++;
                this.shape.sr.img = this.deathAnim[this.deathAnimFrame];
                this.frameIncrement.startTimer();
            }
            else{
                this.destroy();
            }
            
        }

    }

    @Override
    public void onTriggerEnter(GameObject collided){
        if (collided.tag.equals("Bullet")) {
            this.health -= 5;
            collided.destroy();
        }
    }
}
