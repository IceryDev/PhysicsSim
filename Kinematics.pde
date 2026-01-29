class Rigidbody2D {
  
    public float mass = 1;
    
    //Kinematics
    public Transform transform;
    public Vector2D velocity = new Vector2D(0, 0);
    public float angularVelocity = 0;
    //private Vector2D linearDrag = new Vector2D(10, 0);
    private Force2D force = new Force2D(0, 0, ForceMode.Impulse);
    
    
    public Rigidbody2D (Transform transform){
        this.transform = transform;
    }
    
    public void update(){
        if (this.transform.collider.isStatic) { return; }
        this.transform.pos.x += this.velocity.x;
        this.transform.pos.y += this.velocity.y;
        this.transform.translatePos();
        
        this.transform.rotateVertices(angularVelocity);
        
        this.applyForce();
    }
    
    public void applyForce(){
         this.velocity.x += ((this.force.x) / this.mass);
         this.velocity.y += ((this.force.y) / this.mass);
    }
    
    public void applyImpulse(Force2D force, Collision2D collision){
        if (collision.applied == true || this.transform.collider.isStatic) return;
        this.velocity.x += ((force.x) / this.mass);
        this.velocity.y += ((force.y) / this.mass);
    }
    
    public Vector2D getToroidalPos(){
        return new Vector2D((this.transform.pos.x) - ((width + this.transform.size.x / 2) * checkSign(this.velocity.x)), 
                              this.transform.pos.y - ((height + this.transform.size.y / 2) * checkSign(this.velocity.y)));
    }
    
    private int checkSign(float x){
        if (x > 0) { return 1; }
        else if (x < 0) { return -1; }
        else { return 0; }
    }
    
}

enum Collider2D{
    Circle,
    Square,
    Rectangle,
    Polygon;
    
    public boolean enabled = true;
    public boolean isStatic = false;
    public boolean isTrigger = false;
    public boolean isColliding = false;
    
    private float cor = 1; //Coefficient of Restitution -> 1 : Elastic, 0 : Inelastic
    
    public boolean setCor(float value){
        if (value < 0 || value > 1) { return false; }
        this.cor = value;
        return true;
    }
    
    public float getCor(){
        return this.cor;
    }
    
    
}

class Force2D extends Vector2D{
    public ForceMode mode;
    
    public Force2D (float magnitudeX, float magnitudeY, ForceMode mode) {
        super(magnitudeX, magnitudeY);
        this.mode = mode;
    }
}

enum ForceMode {
    Impulse,
    Continuous;
}
