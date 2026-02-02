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
    ArrayList<Ball> circles;
    Mathf mathf = new Mathf();

    public Opponent(Shape2D obj, ArrayList<Ball> circles, float speed){
        this.gameObject = obj;
        this.circles = circles;
        this.speed = speed;
        this.index = objects.size();
        objects.add(this.gameObject);
        this.gameObject.setColor(0, 0, 255);
        this.gameObject.transform.collider.isStatic = true;
        this.gameObject.wrapAround = false;
    }

    public void update(){
        
        this.gameObject.transform.pos.x += this.speed*
                this.gameObject.rb.checkSign(this.findClosest() - this.gameObject.transform.pos.x);
        this.gameObject.transform.pos = new Vector2D(mathf.clamp(
            this.gameObject.transform.pos.x, 
            this.gameObject.transform.size.x / 2, width - (this.gameObject.transform.size.x / 2)),
            (MARGIN + this.gameObject.transform.size.y / 2));
        this.gameObject.transform.translatePos();
    }
    
    public float findClosest(){
        if (circles.isEmpty()) return width/2;
        Ball closest = this.circles.get(0);
        
        for (int i = 0; i< this.circles.size(); i++){
            Ball b = this.circles.get(i);
            if (closest.gameObject.transform.pos.y < 0 && b.gameObject.transform.pos.y > 0){
                closest = b;
            }
            if (b.gameObject.transform.pos.y < closest.gameObject.transform.pos.y && b.gameObject.transform.pos.y > 0){
                closest = b;
            }
        }
        
        return closest.gameObject.transform.pos.x;
    }

}

class Ball{

    float speed;
    int index;
    Shape2D gameObject;
    Mathf mathf = new Mathf();

    public Ball(Shape2D obj, float speed, ArrayList<Shape2D> objectList){
        this.gameObject = obj;
        this.speed = speed;
        
        this.gameObject.setColor(255, 255, 255);
        float tmpNum = random((float) Math.PI * 2);
        this.gameObject.rb.velocity = new Vector2D((float) Math.cos(tmpNum) * speed, (float) Math.sin(tmpNum) * speed);
        this.gameObject.transform.collider.isStatic = false;
        this.gameObject.wrapAround = false;
        this.index = objects.size();
        objectList.add(this.gameObject);
    }

    public void update(){
        
    }

    public void reset(){
        this.gameObject.transform.pos = new Vector2D(360, 360);
        float tmpNum = random((float) Math.PI * 2);
        this.gameObject.rb.velocity = new Vector2D((float) Math.cos(tmpNum) * speed, (float) Math.sin(tmpNum) * speed);
        this.gameObject.transform.translatePos();
    }
    
    public void increaseSpeed(){
        this.gameObject.rb.velocity.vectorSum(new Vector2D(1 * mathf.checkSign(this.gameObject.rb.velocity.x), 1 * mathf.checkSign(this.gameObject.rb.velocity.y)));
    }

    public void destroy(){
        int indexInCircles = this.index - (objects.size() - circles.size());
        for (int i = 0; i < circles.size(); i++){
            if (i > indexInCircles){
                circles.get(i).index--;
            }
        }
        circles.remove(indexInCircles);
        objects.remove(this.index);

    }

}

class BooleanB{
    public boolean value = false;
}
