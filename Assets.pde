class Player extends GameObject{

    int lives;
    float speed = 3;
    Timer shootCooldown = new Timer(50);
    boolean isShooting = false;
    boolean isAlive = true;
    Mathf mathf = new Mathf();

    public Player(Shape2D obj, int lives){
        super(obj);
        this.lives = lives;
        this.tag = "Player";
        this.shape.index = objects.size();
        gameObjects.add(this);
        objects.add(this.shape);
    }

    public void update(){
        if (!isAlive){return;}

        if (this.lives <= 0) {
            isAlive = false;
            gameOver = true;
        }

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

    @Override
    public void onTriggerEnter(GameObject other){
        if (other.tag.equals("AlienBullet")){
            AlienBullet bullet = (AlienBullet) other;
            this.lives -= bullet.damage;
            other.destroy();
        }
    }

}

class AlienBullet extends GameObject {
    public int damage = 1;
    float speed = 15;

    public AlienBullet(Shape2D obj){
        super(obj);
        this.shape.index = objects.size();
        this.tag = "AlienBullet";
        this.shape.transform.collider.isTrigger = true;
        this.shape.rb.velocity.y = this.speed;
        gameObjects.add(this);
        objects.add(this.shape);
    }

    public void update(){
        if (this.shape.transform.pos.y > height){
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
    int alienType = 0;
    boolean movingOnAxis = false; //false/true -> x/y
    boolean isDead = false;
    boolean isThrown = false;
    float targetY;
    float speed = 2;
    int direction = 1; //-1/1 -> left/right
    float dirXThrow = 1;
    float dirYThrow = 1;
    float speedY = 2;
    boolean isBaby = false;

    PImage[] deathAnim = deathSprites;
    int deathAnimFrame = -1;
    Timer frameIncrement = new Timer(5);

    Timer shootTimer = new Timer(50);

    Mathf mathf = new Mathf();

    public Alien(Shape2D obj, int type){
        super(obj);
        this.alienType = type;
        this.tag = "Alien";
        this.shape.transform.collider.isStatic = true;
        this.shootTimer.startTimer();
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

        boolean canShoot = this.shootTimer.updateTime();

        if (canShoot && this.alienType == 0){
            this.shoot();
            this.shootTimer.totalTime = (int)(Math.random() * 25) + 50;
            this.shootTimer.startTimer();
        }

        this.move();
        Transform transform = this.shape.transform;
        if (phase != 4 && phase != 3 && phase != 6){
            if (!this.movingOnAxis && (transform.pos.x + transform.size.x/2 + GAP >= width || transform.pos.x - transform.size.x/2 - GAP <= 0)){
                this.movingOnAxis = !this.movingOnAxis;
                this.shape.transform.pos.x -= this.speed * this.direction;
                this.direction *= -1;
            }
            else if (this.movingOnAxis && (this.targetY - transform.pos.y) < 0.1){
                this.movingOnAxis = !this.movingOnAxis;
                this.targetY = transform.pos.y + (transform.size.y * 2 + GAP);
                //System.out.println(this.targetY);
            }
        }

        if (transform.pos.y > height - 100 && phase != 3){this.speed = 0;}
    }

    public void shoot(){
        AlienBullet pb = new AlienBullet(new Shape2D(
            this.shape.transform.pos.x, this.shape.transform.pos.y, 32, 32, ColliderType.Square, alienBullet, 128, 128));
    }

    public void move(){
        if (this.isDead) {return;}
        switch (phase){
            case 2:
                if (!this.movingOnAxis){
                    this.shape.transform.pos.x += this.speed * this.direction;
                }
                else{
                    this.shape.transform.pos.y += this.speed;
                }
                break;
            case 3:
                return;
                /*this.shape.transform.collider.isStatic = false;
                if (!this.isThrown){
                    this.shape.transform.pos.y += this.speed;
                    for (GravityWell g : gravityWells){
                        float difX = -(this.shape.transform.pos.x - g.shape.transform.pos.x);
                        float difY = -(this.shape.transform.pos.y - g.shape.transform.pos.y);
                        Vector2D pull = new Vector2D((1/(difX * difX)) * mathf.checkSign(difX), (1/(difY*difY))*mathf.checkSign(difY));
                        this.shape.rb.force = pull.scalarMul(8);

                        Vector2D dif = new Vector2D(difX, difY);
                        if (dif.magnitude() < 5){
                            
                            this.speed = random(1, 3) * this.speed;
                            this.speedY = random(1, 3) * this.speedY;
                            this.dirXThrow = (((int)Math.round(random(0, 2)) == 1) ? 1 : -1);
                            this.dirYThrow = (((int)Math.round(random(0, 2)) == 1) ? 1 : -1);
                            this.isThrown = true;
                        }
                    }
                }
                else{
                    this.shape.rb.velocity.x = this.speed * this.dirXThrow;
                    this.shape.rb.velocity.y = this.speedY * this.dirYThrow;
                }
                break;*/

            case 4:
                this.speed = 2;
                this.shape.transform.pos.x += this.speed * this.direction;
                this.shape.transform.pos.y += this.speed;
                if (Math.abs(this.shape.transform.pos.y - height/2) < 0.5){
                    this.shape.sr.img = (this.direction == 1) ? alienSprites[2] : alienSprites[1];
                }
                break;
            case 5:
                this.isThrown = false;
                if (!this.movingOnAxis){
                    this.shape.transform.pos.x += this.speed * this.direction;
                    this.shape.sr.img = (this.direction == 1) ? alienSprites[1] : alienSprites[2];
                }
                else{
                    this.shape.transform.pos.y += this.speed;
                }
                break;
            case 6:
                
                if(!this.isBaby){
                    this.shape.transform.collider.isStatic = true;
                    this.shape.transform.pos.x += this.speed * this.direction;
                    this.shape.transform.pos.y += this.speed / 2;
                }
                else {
                    this.shape.transform.pos.x -= this.speed;
                    this.shape.transform.pos.y += this.speed * this.direction;
                }
            default:
        }
        
        this.shape.transform.translatePos();
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
            PlayerBullet bullet = (PlayerBullet) collided;
            this.health -= bullet.damage;
            score++;
            bullet.destroy();
        }
        else if(collided.tag.equals("Border")){
            this.isThrown = true;
            tempAlien = new Alien(new Shape2D(this.shape.transform.pos.x, this.shape.transform.pos.y, 32, 32, ColliderType.Square, alienSprites[2], 64, 64), 2);
            tempAlien.direction = -1;
            tempAlien.isBaby = true;
            tempAlien = new Alien(new Shape2D(this.shape.transform.pos.x, this.shape.transform.pos.y, 32, 32, ColliderType.Square, alienSprites[2], 64, 64), 2);
            tempAlien.isBaby = true;
            tempAlien.direction = 1;
            this.destroy();
        }
    }

    @Override
    public void onCollisionEnter(GameObject other){
        if (other.tag.equals("Player")){
            player.lives -= 2;
            this.isDead = true;
        }
    }
}

class PlayButton extends UIElement{
    float width;
    float height;

    Vector2D pos;

    public PlayButton(float posX, float posY, float width, float height){
        this.height = height;
        this.width = width;
        this.pos = new Vector2D(posX, posY);
    }

    public boolean isClickedOn(){
        if (mouseX > this.pos.x - this.width/2 && 
            mouseX < this.pos.x + this.width/2 &&
            mouseY > this.pos.y - this.height/2 &&
            mouseY < this.pos.y + this.height/2){
            
            return true;
        }
        return false;
    }
}

class GravityWell extends GameObject{
    
    public GravityWell(Shape2D obj){
        super(obj);
        this.tag = "Well";
        this.shape.transform.collider.isTrigger = true;
        this.shape.index = objects.size();
        gameObjects.add(this);
        objects.add(this.shape);
    }
}

class Border extends GameObject{

    public Border(Shape2D obj){
        super(obj);
        this.tag = "Border";
        this.shape.transform.collider.isTrigger = true;
        this.shape.transform.collider.isStatic = false;
        this.shape.index = objects.size();
        gameObjects.add(this);
        objects.add(this.shape);
    }
}
