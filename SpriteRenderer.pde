class SpriteRenderer{
    public PImage img;
    public Vector2D size;
    public Matrix vertices = new Matrix(2, 4);
    public Matrix distances = new Matrix(2, 4);
    private Transform transform;

    public SpriteRenderer(Transform transform, PImage img, Vector2D size){
        this.transform = transform;
        this.transform.imgAttached = true;
        this.img = img;
        this.size = size;

        this.setVertex();
        this.setDistances();
    }

    private void setVertex(){
        this.vertices.setVec(new Vector2D(this.transform.pos.x + this.size.x / 2, this.transform.pos.y + this.size.y / 2), 0);
        this.vertices.setVec(new Vector2D(this.transform.pos.x + this.size.x / 2, this.transform.pos.y - this.size.y / 2), 1);
        this.vertices.setVec(new Vector2D(this.transform.pos.x - this.size.x / 2, this.transform.pos.y - this.size.y / 2), 2);
        this.vertices.setVec(new Vector2D(this.transform.pos.x - this.size.x / 2, this.transform.pos.y + this.size.y / 2), 3);
    }

    private void setDistances(){

        for (int i = 0; i < this.vertices.columns; i++){
            this.distances.setVal(0, i, this.vertices.getVal(0, i) - this.transform.pos.x);
            this.distances.setVal(1, i, this.vertices.getVal(1, i) - this.transform.pos.y);
        }

    }

    public void translatePos(){

        for (int i = 0; i < this.vertices.columns; i++){
            this.vertices.setVal(0, i, this.distances.getVal(0, i) + this.transform.pos.x);
            this.vertices.setVal(1, i, this.distances.getVal(1, i) + this.transform.pos.y);
        }
    }

    public void rotateVertices(){ 
        this.distances = this.transform.rotMatrix.matMul(this.distances);
    }
}