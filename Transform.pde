class Transform{
    public Vector2D pos;
    private ArrayList<Vector2D> initialVertexPos = new ArrayList<>();
    public Shape2D parent;
    public Matrix vertexTransform;
    public Matrix edgeNormals;
    public float rotInRad = 0;
    private float currentRot = 0;
    public Matrix rotMatrix = new Matrix(2, 2);
    private Matrix distances;
    
    public Vector2D size;
    public Collider2D collider;
    
    public Transform(Vector2D pos, Collider2D collider, Shape2D parent){
        this.pos = pos;
        this.collider = collider;
        this.parent = parent;
        
    }
    
    public void setVertex(Vector2D size){
        if (this.collider == Collider2D.Polygon) {
            System.err.println("No vertex information provided for Polygon Collider, setting it to Rectangle...");
            this.collider = Collider2D.Rectangle;
        }
        
        
        this.size = size;
        switch (this.collider){
            case Circle:
                this.initialVertexPos.add(new Vector2D(this.pos.x, this.pos.y));
                break;
            case Square:
            case Rectangle:
                this.initialVertexPos.add(new Vector2D(this.pos.x + size.x / 2, this.pos.y + size.y / 2));
                this.initialVertexPos.add(new Vector2D(this.pos.x + size.x / 2, this.pos.y - size.y / 2));
                this.initialVertexPos.add(new Vector2D(this.pos.x - size.x / 2, this.pos.y - size.y / 2));
                this.initialVertexPos.add(new Vector2D(this.pos.x - size.x / 2, this.pos.y + size.y / 2));             
                break;
            default:
                break;
        }
        this.createVertexMatrix();
        this.createEdgeNormals();
        this.distances = this.getDistances();
    }
    
    private void createVertexMatrix(){
        this.vertexTransform = new Matrix(2, initialVertexPos.size());
        for (int i = 0; i < initialVertexPos.size(); i++){
            this.vertexTransform.setVal(0, i, initialVertexPos.get(i).x);
            this.vertexTransform.setVal(1, i, initialVertexPos.get(i).y);
        }
    }
    
    private void createEdgeNormals(){
        if (this.collider == Collider2D.Circle){ return; } //If the collider is a circle then there are infinite normals, so the edge normals remain null
        
        Matrix normals = new Matrix(this.vertexTransform.rows, this.vertexTransform.columns);
        Vector2D temp = new Vector2D(this.vertexTransform.getVal(0, 0) - this.vertexTransform.getVal(0, this.vertexTransform.columns - 1),
                                     this.vertexTransform.getVal(1, 0) - this.vertexTransform.getVal(1, this.vertexTransform.columns - 1));
        temp = new Vector2D(temp.y, -temp.x);
        temp = temp.normalise();
        normals.setVec(temp, 0);
        for (int i = 1; i < normals.columns; i++){
            temp = this.vertexTransform.getVec(i).vectorSum(this.vertexTransform.getVec(i - 1).negate());
            temp = new Vector2D(temp.y, -temp.x);
            normals.setVec(temp.normalise(), i);
        }
        this.edgeNormals = normals;
    }
    
    private void createRotMatrix(){
        float[][] tempArray = {{(float) Math.cos(this.rotInRad), (float) -Math.sin(this.rotInRad)}, 
                               {(float) Math.sin(this.rotInRad), (float) Math.cos(this.rotInRad)}};
        this.rotMatrix.setArray(tempArray);
    }
    
    //Coordinates in terms of the body frame
    private Matrix getDistances(){
        Matrix distanceMatrix = new Matrix(vertexTransform.rows, vertexTransform.columns);
        for (int i = 0; i < this.vertexTransform.columns; i++){
            distanceMatrix.setVal(0, i, this.vertexTransform.getVal(0, i) - this.pos.x);
            distanceMatrix.setVal(1, i, this.vertexTransform.getVal(1, i) - this.pos.y);
        }
        return distanceMatrix;
    }
    
    public void translatePos(){
        for (int i = 0; i < this.vertexTransform.columns; i++){
            this.vertexTransform.setVal(0, i, this.distances.getVal(0, i) + this.pos.x);
            this.vertexTransform.setVal(1, i, this.distances.getVal(1, i) + this.pos.y);
        }
    }
    
    public Matrix translatePos(Vector2D toroidalPos){
        Matrix toroidalTransform = new Matrix(2, this.vertexTransform.columns);
        for (int i = 0; i < toroidalTransform.columns; i++){
            toroidalTransform.setVal(0, i, this.distances.getVal(0, i) + toroidalPos.x);
            toroidalTransform.setVal(1, i, this.distances.getVal(1, i) + toroidalPos.y);
        }
        return toroidalTransform;
    }
    
    public void rotateVertices(float rotInRad){ 
        this.rotInRad = rotInRad;
        this.currentRot = (this.currentRot + rotInRad) % ((float) Math.PI * 2);
        this.createRotMatrix();
        this.distances = this.rotMatrix.matMul(this.distances);
        if (this.edgeNormals != null) { this.edgeNormals = this.rotMatrix.matMul(this.edgeNormals); }
        this.translatePos();
    }

    public void setRotation(float radians){
        this.rotateVertices(radians - this.currentRot);
        this.currentRot = radians;
    }
}
