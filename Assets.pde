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
