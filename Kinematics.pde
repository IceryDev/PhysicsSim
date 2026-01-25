class Rigidbody2D {
  
    private double PRECISION = 1e-5;
  
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
        
        this.applyForce(this.force);
    }
    
    public void applyForce(Force2D force){
        if (Math.abs(force.x - this.force.x) < PRECISION && Math.abs(force.y - this.force.y) < PRECISION && force.mode == ForceMode.Impulse) { //<>//
            this.force = new Force2D(0, 0, ForceMode.Impulse);
        }
        else {
            this.force = force;
            this.velocity.x += ((this.force.x) / this.mass);
            this.velocity.y += ((this.force.y) / this.mass);
        }
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
