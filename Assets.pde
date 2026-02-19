class Player extends GameObject{

    int lives;
    float speed = 6;
    Timer shootCooldown = new Timer(40);
    Timer powerupTimer = new Timer(150);
    boolean isShooting = false;
    boolean isAlive = true;
    int activePowerup = -1;
    Mathf mathf = new Mathf();

    public Player(Shape2D obj, int lives){
        super(obj);
        this.lives = lives;
        this.tag = "Player";
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
            this.shoot(this.activePowerup);
            this.shootCooldown.startTimer();
        }

        if (this.powerupTimer.updateTime()){ 
            this.activePowerup = -1; 
            playerHasPowerup1 = false;
            this.shootCooldown.totalTime = 40;
        }

        this.shape.transform.pos = new Vector2D(mathf.clamp(
            this.shape.transform.pos.x, this.shape.transform.size.x / 2, width - (this.shape.transform.size.x / 2)),
                                                  height - (MARGIN + this.shape.transform.size.y / 2));
        this.shape.transform.translatePos();
    }

    public void shoot(int type){
        
        shootSFX.play();
        shapeBuilder.setPos(this.shape.transform.pos.x, this.shape.transform.pos.y)
                    .setSize(32, 32)
                    .setCollider(ColliderType.Square)
                    .addImage(playerBullet, 96, 96);
        
                    
        PlayerBullet p = new PlayerBullet(shapeBuilder.build());
        switch (type){
            case 0:
                p = new PlayerBullet(shapeBuilder.build());
                Matrix tmp = new Matrix(2, 1);
                tmp.setVec(p.shape.rb.velocity, 0);
                p.shape.rb.velocity = mathf.createRotMatrix(mathf.deg2Rad(5)).matMul(tmp).getVec(0);
                p.shape.transform.rotateVertices(mathf.deg2Rad(5));
                p = new PlayerBullet(shapeBuilder.build());
                tmp.setVec(p.shape.rb.velocity, 0);
                p.shape.rb.velocity = mathf.createRotMatrix(mathf.deg2Rad(-5)).matMul(tmp).getVec(0);
                p.shape.transform.rotateVertices(mathf.deg2Rad(-5));
                break;
            default:
        }

        
    }

    @Override
    @SuppressWarnings("unused")
    public void onTriggerEnter(GameObject other){
        if (other.tag.equals("AlienBullet")){
            AlienBullet bullet = (AlienBullet) other;
            this.lives -= bullet.damage;
            damageSFX.play();
            other.destroy();
        }
        else if (other.tag.equals("Powerup")){
            pwrupSFX.play();
            Powerup powerup = (Powerup) other;
            if (powerup.type == 3){
                //int coordinateStep = (width-2*SHIELD_MARGIN)/(SHIELD_COUNT-1);
                for (int i = 0; i < SHIELD_COUNT; i++){
                    if (shieldIsUp[i]) {
                        shields[i].shieldHealth = (shields[i].shieldHealth > 90) ? 100 : shields[i].shieldHealth + 10;
                        shields[i].checkSpriteChange();
                        continue;
                    }
                    shieldIsUp[i] = true;
                    new Shield(shapeBuilder.setPos(width/2 + mathf.randInt(100) - 50, 500 + (i*100))
                                           .setSize(64, 16)
                                           .setCollider(ColliderType.Rectangle)
                                           .addImage(shieldSprites[0], 96, 96)
                                           .build(), i);
                }
            }
            else{
                this.activePowerup = powerup.type;
                if (this.activePowerup == 1){ playerHasPowerup1 = true; }
                else if(this.activePowerup == 2) { this.shootCooldown.totalTime = 20; }
                this.powerupTimer.startTimer();
            }
            other.destroy();
        }
        else if (other.tag.equals("AlienLaser")){
            AlienLaser laser = (AlienLaser) other;
            damageSFX.play();
            this.lives -= laser.damage;
        }
    }

}

class Shield extends GameObject{

    Timer shieldTimer = new Timer(500);
    int shieldHealth = 100;
    int shieldId = 0;
    float speed = 2;

    public Shield(Shape2D obj, int id){
        super(obj);
        this.shieldId = id;
        shields[id] = this;
        this.shieldTimer.startTimer();
    }

    public void update(){
        if ((this.shape.transform.pos.x > width - this.shape.transform.size.x/2 && mathf.checkSign(this.speed) == 1) ||
            (this.shape.transform.pos.x < this.shape.transform.size.x/2 && mathf.checkSign(this.speed) == -1)){
                this.speed *= -1;
            }
        this.shape.rb.velocity.x = this.speed;
        if(this.shieldTimer.updateTime()){
            this.shieldHealth -= 10;
            System.out.println("Shield no " + this.shieldId + ": " + this.shieldHealth);
            this.checkSpriteChange();
            this.shieldTimer.startTimer();
        }

        if(this.shieldHealth <= 0){
            this.destroy();
        }
    }

    private void checkSpriteChange(){
        if (this.shieldHealth <= 70 && this.shieldHealth > 40){
            this.shape.sr.img = shieldSprites[1];
        }
        else if(this.shieldHealth <= 40){
            this.shape.sr.img = shieldSprites[2];
        }
        else {
            this.shape.sr.img = shieldSprites[0];
        }
    }

    @Override
    public void onTriggerEnter(GameObject other){
        if (other.tag.equals("AlienBullet")){
            this.shieldHealth -= 5;
            this.checkSpriteChange();
            AlienBullet o = (AlienBullet) other;
            if (this.shieldHealth > 40){
                other.destroy();
            } 
            else {
                o.damage = 1;
            }
        }
        else if(other.tag.equals("AlienLaser")){
            this.destroy();
        }
        else if(other.tag.equals("Bullet")){
            this.shieldHealth -= 5;
            this.checkSpriteChange();
            PlayerBullet o = (PlayerBullet) other;
            o.reduceSpeed(5);
        }
    }

    @Override
    public void onCollisionEnter(GameObject other){
        if(other.tag.equals("Alien")){
            this.destroy();
            Alien o = (Alien) other;
            o.isDead = true;
        }
    }

    @Override
    public void destroy(){
        shieldIsUp[this.shieldId] = false;
        shields[this.shieldId] = null;
        super.destroy();
    }
}

class AlienBullet extends GameObject {
    public int damage = 2;
    float speed = 15;

    public AlienBullet(Shape2D obj){
        super(obj);
        
        this.tag = "AlienBullet";
        this.shape.transform.collider.isTrigger = true;
        this.shape.rb.velocity.y = this.speed;
        
    }

    public void update(){
        if (this.shape.transform.pos.y > height){
            this.destroy();
        }
    }
}

class AlienLaser extends GameObject {
    public int damage = 1;
    float speed = 10;
    GameObject parent;
    Timer lifeCycle = new Timer(40);

    public AlienLaser(Shape2D obj, GameObject parent){
        super(obj);
        
        this.parent = parent;
        this.setLayer(-1);
        this.lifeCycle.startTimer();
        this.tag = "AlienLaser";
        this.shape.transform.collider.isTrigger = true;
        
    }

    public void update(){
        this.shape.transform.pos = new Vector2D(this.parent.shape.transform.pos.x, height/2);
        if (this.lifeCycle.updateTime()){
            this.destroy();
        }
    }
}

class PlayerBullet extends GameObject{
    int damage = 1;
    float speed = 15;

    public PlayerBullet(Shape2D obj){
        super(obj);
        
        this.tag = "Bullet";
        this.shape.transform.collider.isTrigger = true;
        this.shape.rb.velocity.y = -this.speed;
        
    }

    public void update(){
        if (this.shape.transform.pos.y < -10){
            this.destroy();
        }
    }

    public void reduceSpeed(float val){
        this.shape.rb.velocity.y += val;
    }
}

class Powerup extends GameObject{
    public int type;
    public Powerup (Shape2D obj, int type){
        super(obj);
        this.type = type;
        this.shape.transform.collider.isTrigger = true;
        this.tag = "Powerup";
        this.shape.rb.velocity.y = 10;
    }

    public void update(){
        if (this.shape.transform.pos.y > height) { this.destroy(); }
    }
}

class Alien extends GameObject{

    final float GAP = 15;

    int health = 1;
    int alienType = 0;
    boolean movingOnAxis = false; //false/true -> x/y
    boolean isDead = false;
    boolean dropRoll = false;
    float targetY;
    float speed = 2;
    int direction = 1; //-1/1 -> left/right
    boolean isBoss = false;
    int shots = 0;

    PImage[] deathAnim = deathSprites;
    int deathAnimFrame = -1;
    Timer frameIncrement = new Timer(5);

    Timer shootTimer = new Timer(50);
    Timer rapidTimer = new Timer(2);

    Mathf mathf = new Mathf();

    public Alien(Shape2D obj, int type){
        super(obj);
        this.alienType = type;
        this.tag = "Alien";
        this.shootTimer.startTimer();
        this.targetY = obj.transform.pos.y + (obj.transform.size.y + GAP);
        switch (this.alienType){
            case 2:
                this.health = 2;
                break;
            default:
        }
        
    }

    @SuppressWarnings("unused")
    public Alien(Shape2D obj, boolean isBoss){
        super(obj);
        this.alienType = -1;
        this.tag = "Alien";
        this.shootTimer.startTimer();
        this.rapidTimer.startTimer();
        this.isBoss = true;
        this.targetY = obj.transform.pos.y + (obj.transform.size.y + GAP);
        this.health = 10;
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
                explodeSFX.play();
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
        else if (canShoot && this.alienType == 2){
            this.shootLaser();
            this.shootTimer.totalTime = mathf.randInt(300) + 150;
            this.shootTimer.startTimer();
        }
        else if (canShoot && this.isBoss){
            boolean rapidShoot = this.rapidTimer.updateTime();
            if (rapidShoot){
                this.shoot();
                this.shots++;
                this.rapidTimer.startTimer();
            }

            if (shots > 5){
                this.shootTimer.totalTime = 20;
                this.shootTimer.startTimer();
                this.shots = 0;
            }
        }

        this.move();
        Transform transform = this.shape.transform;
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

        if (transform.pos.y > height){this.isDead = true;}
    }

    @SuppressWarnings("unused")
    public void shoot(){
        shapeBuilder.setPos(this.shape.transform.pos.x, this.shape.transform.pos.y)
                    .setSize(32, 32)
                    .setCollider(ColliderType.Square)
                    .addImage(alienBullet, 96, 96);
        new AlienBullet(shapeBuilder.build());
    }

    @SuppressWarnings("unused")
    public void shootLaser(){
        shapeBuilder.setPos(this.shape.transform.pos.x, this.shape.transform.pos.y + 32)
                    .setSize(32, 1024)
                    .setCollider(ColliderType.Rectangle)
                    .addImage(alienBullet2, 96, 1024);
        new AlienLaser(shapeBuilder.build(), this);
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

    @SuppressWarnings("unused")
    public void playDeathAnim(){
        boolean updateSprite = this.frameIncrement.updateTime();
        if (!this.dropRoll){
            int aggregate = mathf.randInt(ROLL_CEIL - 16) + (difficulty * DIFFICULTY_ROLL_CONTRIBUTION);
            int pwrType = -1;
            for (int i = 0, remaining = ROLL_CEIL; i < usedPwrupWeight.length; i++){
              remaining -= usedPwrupWeight[i];
              if (aggregate > remaining){
                pwrType = i;
                break;
              }
            }
            if (pwrType != -1) {
                new Powerup(shapeBuilder.setPos(this.shape.transform.pos.x, this.shape.transform.pos.y)
                                        .setSize(32, 32)
                                        .setCollider(ColliderType.Square)
                                        .addImage(powerupSprites[pwrType], 64, 64)
                                        .build(), pwrType);
            }
            System.out.println(aggregate + "/" + ROLL_CEIL + ": " + pwrType);
            
            this.dropRoll = true;
        }
        if (updateSprite){
            if (this.deathAnimFrame != this.deathAnim.length-1){
                this.deathAnimFrame++;
                this.shape.sr.img = this.deathAnim[this.deathAnimFrame];
                this.frameIncrement.startTimer();
            }
            else{
                if (this.isBoss) {victory = true;}
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
            if(!playerHasPowerup1 && !this.isDead) {bullet.destroy();}
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
