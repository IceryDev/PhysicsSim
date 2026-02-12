class Shape2D {
  
    //Constants
    private final int RGB_MAX_VALUE = 255;
  
    //Kinematics
    public Rigidbody2D rb;
    public Transform transform;

    //Image
    public SpriteRenderer sr;
    
    //Shape Properties
    public int[] colr = {255, 255, 255};
    
    //Color Change
    private boolean[] colorChangeMode = {true, true, true}; //true/false -> increase/decrease, {R, G, B}
    
    //Wrap Around Motion
    public boolean wrapAround = false; //Currently only works with quads and circles

    //GameObject Properties
    public GameObject gameObject;
    
    public Shape2D(float posX, float posY, float sizeX, float sizeY, ColliderType collider){
        this.transform = new Transform(new Vector2D(posX, posY), new Collider2D(collider), this);
        this.rb = new Rigidbody2D(this.transform);
        
        this.transform.setVertex(new Vector2D(sizeX, sizeY));
    }

    public Shape2D(float posX, float posY, float sizeX, float sizeY, ColliderType collider, PImage img, float imgSizeX, float imgSizeY){
        this.transform = new Transform(new Vector2D(posX, posY), new Collider2D(collider), this);
        this.rb = new Rigidbody2D(this.transform);
        
        this.transform.setVertex(new Vector2D(sizeX, sizeY));
        this.sr = new SpriteRenderer(this.transform, img, new Vector2D(imgSizeX, imgSizeY));
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

    public Matrix imagePoints(){
        return this.sr.vertices;
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

class ShapeBuilder{
    float posX = 0;
    float posY = 0;
    float sizeX = 1;
    float sizeY = 1;
    ColliderType ct = ColliderType.Square;
    PImage img;
    float imgSizeX = 1;
    float imgSizeY = 1;

    public ShapeBuilder setPos(float x, float y){
        this.posX = x;
        this.posY = y;
        return this;
    }

    public ShapeBuilder setSize(float x, float y){
        this.sizeX = x;
        this.sizeY = y;
        return this;
    }

    public ShapeBuilder setCollider(ColliderType ct){
        this.ct = ct;
        return this;
    }

    public ShapeBuilder addImage(PImage img, float x, float y){
        this.img = img;
        this.imgSizeX = x;
        this.imgSizeY = y;
        return this;
    }

    public ShapeBuilder clearImage(){
        this.img = null;
        this.imgSizeX = 1;
        this.imgSizeY = 1;
        return this;
    }

    public Shape2D build(){
        if (sizeX <= 0 || sizeY <= 0){ 
            throw new IllegalStateException("Shape size must be positive");
        }
        if (img != null && (imgSizeX <= 0 || imgSizeY <= 0)){
            throw new IllegalStateException("Image size must be positive");
        }
        return (this.img == null) ? new Shape2D(this.posX, this.posY, this.sizeX, this.sizeY, this.ct) :
                new Shape2D(this.posX, this.posY, this.sizeX, this.sizeY, this.ct, this.img, this.imgSizeX, this.imgSizeY);
    }
}

class ShapeDrawer implements Utility{

    public void update(Scene scene){
        for (Shape2D shape : scene.shapes){
            if (shape.transform.imgAttached){
                float imgH = shape.sr.img.height;
                float imgW = shape.sr.img.width;
                beginShape(QUADS);
                texture(shape.sr.img);
                vertex(shape.imagePoints().getVal(0, 0), shape.imagePoints().getVal(1, 0), imgW, imgH);
                vertex(shape.imagePoints().getVal(0, 1), shape.imagePoints().getVal(1, 1), imgW, 0);
                vertex(shape.imagePoints().getVal(0, 2), shape.imagePoints().getVal(1, 2), 0, 0);
                vertex(shape.imagePoints().getVal(0, 3), shape.imagePoints().getVal(1, 3), 0, imgH);
                endShape();
            }
            else{
                if (shape.transform.collider.type == ColliderType.Circle){
                    drawCircle(shape);
                }
                else if (shape.transform.vertexTransform.columns == 4){
                    if (shape.wrapAround){drawQuad(shape, shape.transform.translatePos(shape.rb.getToroidalPos()));}
                    else {drawQuad(shape);}
                }
            }
        }
    }

    public UtilityType getKey(){
        return UtilityType.Shapes;
    }

    public void drawAll(ArrayList<Shape2D> obj){
        for (Shape2D shape : obj){
            if (shape.transform.imgAttached){
                float imgH = shape.sr.img.height;
                float imgW = shape.sr.img.width;
                beginShape(QUADS);
                texture(shape.sr.img);
                vertex(shape.imagePoints().getVal(0, 0), shape.imagePoints().getVal(1, 0), imgW, imgH);
                vertex(shape.imagePoints().getVal(0, 1), shape.imagePoints().getVal(1, 1), imgW, 0);
                vertex(shape.imagePoints().getVal(0, 2), shape.imagePoints().getVal(1, 2), 0, 0);
                vertex(shape.imagePoints().getVal(0, 3), shape.imagePoints().getVal(1, 3), 0, imgH);
                endShape();
            }
            else{
                if (shape.transform.collider.type == ColliderType.Circle){
                    drawCircle(shape);
                }
                else if (shape.transform.vertexTransform.columns == 4){
                    if (shape.wrapAround){drawQuad(shape, shape.transform.translatePos(shape.rb.getToroidalPos()));}
                    else {drawQuad(shape);}
                }
            }
        }
    }
    
    public void drawCircle(Shape2D obj){
        if(obj.transform.collider.type != ColliderType.Circle){
            System.err.println("Cannot create a circle without a circle collider!"); return;
        }
        fill(obj.colr[0], obj.colr[1], obj.colr[2]);
        ellipse(obj.transform.pos.x, obj.transform.pos.y, obj.transform.size.x, obj.transform.size.y);
    }
    
    public void drawCircle(Shape2D obj, Vector2D toroidalPos){
        if(obj.transform.collider.type != ColliderType.Circle){
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
