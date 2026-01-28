class Player{

    int lives;
    int index;
    Shape2D gameObject;
    Mathf mathf = new Mathf();

    public Player(Shape2D obj, int lives){
        this.gameObject = obj;
        this.lives = lives;
        this.index = objects.size();
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

class Opponent{

    float speed;
    int index;
    Shape2D gameObject;
    Shape2D ballGameObj;
    Mathf mathf = new Mathf();

    public Opponent(Shape2D obj, Shape2D ball, float speed){
        this.gameObject = obj;
        this.ballGameObj = ball;
        this.speed = speed;
        this.index = objects.size();
        objects.add(this.gameObject);
        this.gameObject.setColor(0, 0, 255);
        this.gameObject.transform.collider.isStatic = true;
        this.gameObject.wrapAround = false;
    }

    public void update(){
        this.gameObject.transform.pos.x += this.speed*
                this.gameObject.rb.checkSign(ballGameObj.transform.pos.x - this.gameObject.transform.pos.x);
        this.gameObject.transform.pos = new Vector2D(mathf.clamp(
            this.gameObject.transform.pos.x, 
            this.gameObject.transform.size.x / 2, width - (this.gameObject.transform.size.x / 2)),
            (MARGIN + this.gameObject.transform.size.y / 2));
        this.gameObject.transform.translatePos();
    }

}

class Ball{

    float speed;
    int index;
    Shape2D gameObject;
    Mathf mathf = new Mathf();

    public Ball(Shape2D obj, float speed){
        this.gameObject = obj;
        this.speed = speed;
        this.index = objects.size();
        objects.add(this.gameObject);
        this.gameObject.setColor(255, 255, 255);
        float tmpNum = random((float) Math.PI * 2);
        this.gameObject.rb.velocity = new Vector2D((float) Math.cos(tmpNum) * speed, (float) Math.sin(tmpNum) * speed);
        this.gameObject.transform.collider.isStatic = false;
        this.gameObject.wrapAround = false;
    }

    public void update(){
        
    }

    public void reset(){
        this.gameObject.transform.pos = new Vector2D(360, 360);
        float tmpNum = random((float) Math.PI * 2);
        this.gameObject.rb.velocity = new Vector2D((float) Math.cos(tmpNum) * speed, (float) Math.sin(tmpNum) * speed);
        this.gameObject.transform.translatePos();
    }

}