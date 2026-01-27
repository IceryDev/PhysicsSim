class Shape2D {
  
    //Constants
    private final int RGB_MAX_VALUE = 255;
  
    //Kinematics
    public Rigidbody2D rb;
    public Transform transform;
    
    //Shape Properties
    public int[] colr = {0, 0, 0};
    
    //Color Change
    private boolean[] colorChangeMode = {true, true, true}; //true/false -> increase/decrease, {R, G, B}
    
    //Wrap Around Motion
    public boolean wrapAround = false;
    
    public Shape2D(float posX, float posY, float sizeX, float sizeY, Collider2D collider){
        this.transform = new Transform(new Vector2D(posX, posY), collider, this);
        this.rb = new Rigidbody2D(this.transform);
        
        this.transform.setVertex(new Vector2D(sizeX, sizeY));
    }
    
    public void setColor(int red, int blue, int green){
        this.colr[0] = red;
        this.colr[1] = blue;
        this.colr[2] = green;
    }
    
    public void update(){
        this.rb.update();
        
        // Wrap around requires the drawing of 4 replicate objects with positions of the original object and the toroidal position.
        if (wrapAround) {
            this.transform.pos.x = this.transform.pos.x % (width + this.transform.size.x / 2); //Screen width
            this.transform.pos.y = this.transform.pos.y % (height + this.transform.size.y / 2); //Screen height
            this.transform.translatePos();
        }
    }
    
    public Matrix points(){
        return this.transform.vertexTransform;
    }
    
    public void changeColor(int spdR, int spdG, int spdB){
        int[] spdRGB = {spdR, spdG, spdB};
        for (int i = 0; i < 3; i++){
            if (colr[i] >= RGB_MAX_VALUE - spdRGB[i] && colorChangeMode[i] == true){
                colorChangeMode[i] = false;
            }
      
            if (colr[i] <= spdRGB[i] && colorChangeMode[i] == false) {
                colorChangeMode[i] = true;
            }
      
            colr[i] = (colr[i] + (spdRGB[i] * ((colorChangeMode[i]) ? 1 : -1)));
        }
    }
}

class ShapeDrawer{
    public void updateAll(ArrayList<Shape2D> obj){
        for (int i = 0; i < obj.size(); i++){
            obj.get(i).update();
        }
    }
    
    public void drawCircle(Shape2D obj){
        if(obj.transform.collider != Collider2D.Circle){
            System.err.println("Cannot create a circle without a circle collider!"); return;
        }
        fill(obj.colr[0], obj.colr[1], obj.colr[2]);
        ellipse(obj.transform.pos.x, obj.transform.pos.y, obj.transform.size.x, obj.transform.size.y);
    }
    
    public void drawCircle(Shape2D obj, Vector2D toroidalPos){
        if(obj.transform.collider != Collider2D.Circle){
            System.err.println("Cannot create a circle without a circle collider!"); return;
        }
        
        fill(obj.colr[0], obj.colr[1], obj.colr[2]);
        ellipse(obj.transform.pos.x, obj.transform.pos.y, obj.transform.size.x, obj.transform.size.y);
        ellipse(toroidalPos.x, toroidalPos.y, obj.transform.size.x, obj.transform.size.y);
        ellipse(toroidalPos.x, obj.transform.pos.y, obj.transform.size.x, obj.transform.size.y);
        ellipse(obj.transform.pos.x, toroidalPos.y, obj.transform.size.x, obj.transform.size.y);
    }
    
    public void drawQuad(Shape2D obj){
        Matrix vertices = obj.points();
        if (vertices.columns != 4) { System.err.println("A quadrilateral has to have 4 vertices!"); return;}
        fill(obj.colr[0], obj.colr[1], obj.colr[2]);
        quad(vertices.getVal(0, 0), vertices.getVal(1, 0),
             vertices.getVal(0, 1), vertices.getVal(1, 1),
             vertices.getVal(0, 2), vertices.getVal(1, 2),
             vertices.getVal(0, 3), vertices.getVal(1, 3));    
    }
    
    public void drawQuad(Shape2D obj, Matrix toroidal){
        Matrix vertices = obj.points();
        if (vertices.columns != 4) { System.err.println("A quadrilateral has to have 4 vertices!"); return;}
        fill(obj.colr[0], obj.colr[1], obj.colr[2]);
        quad(vertices.getVal(0, 0), vertices.getVal(1, 0),
             vertices.getVal(0, 1), vertices.getVal(1, 1),
             vertices.getVal(0, 2), vertices.getVal(1, 2),
             vertices.getVal(0, 3), vertices.getVal(1, 3));  
          
        quad(toroidal.getVal(0, 0), vertices.getVal(1, 0),
             toroidal.getVal(0, 1), vertices.getVal(1, 1),
             toroidal.getVal(0, 2), vertices.getVal(1, 2),
             toroidal.getVal(0, 3), vertices.getVal(1, 3));
             
        quad(vertices.getVal(0, 0), toroidal.getVal(1, 0),
             vertices.getVal(0, 1), toroidal.getVal(1, 1),
             vertices.getVal(0, 2), toroidal.getVal(1, 2),
             vertices.getVal(0, 3), toroidal.getVal(1, 3));  
             
        quad(toroidal.getVal(0, 0), toroidal.getVal(1, 0),
             toroidal.getVal(0, 1), toroidal.getVal(1, 1),
             toroidal.getVal(0, 2), toroidal.getVal(1, 2),
             toroidal.getVal(0, 3), toroidal.getVal(1, 3));  
    }
}
