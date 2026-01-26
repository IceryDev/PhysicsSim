class Vector2D {
    public float x;
    public float y;
    
    public Vector2D (float x, float y){
        this.x = x;
        this.y = y;
    }
    
    public Vector2D vectorSum(Vector2D vec){
        this.x += vec.x;
        this.y += vec.y;
        
        return this;
    }
    
    public Vector2D negate(){
        this.x = -this.x;
        this.y = -this.y;
        
        return this;
    }
    
    public float dotProduct(Vector2D vec){
        return (this.x * vec.x) + (this.y * vec.y);
    }
    
    public float magnitude(){
        return (float) Math.hypot(this.x, this.y);
    } 
    
    public Vector2D normalise(){
        float norm = this.magnitude();
        this.x /= norm;
        this.y /= norm;
        
        return this;
    }
}

class Matrix {
    public int rows;
    public int columns;
    
    private float[][] array;
    
    public Matrix (int rows, int columns){
        this.rows = rows;
        this.columns = columns;
        
        this.array = new float[rows][columns];
    }
    
    public float getVal(int rowIndex, int columnIndex) throws IndexOutOfBoundsException{
        if (rowIndex >= this.rows || columnIndex >= this.columns){
            throw new IndexOutOfBoundsException();
        }
        
        return this.array[rowIndex][columnIndex];
    }
    
    public void setVal(int rowIndex, int columnIndex, float value) throws IndexOutOfBoundsException{
        if (rowIndex >= this.rows || columnIndex >= this.columns){
            throw new IndexOutOfBoundsException();
        }
        
        this.array[rowIndex][columnIndex] = value;
    }
    
    public void setVec(Vector2D vec, int columnIndex) throws IndexOutOfBoundsException{
        if (this.rows > 2 || columnIndex >= this.columns){
            throw new IndexOutOfBoundsException();
        }
        this.array[0][columnIndex] = vec.x;
        this.array[1][columnIndex] = vec.y;
        
    }
    
    public Vector2D getVec(int columnIndex) throws IndexOutOfBoundsException {
        if (this.rows > 2 || columnIndex >= this.columns){
            throw new IndexOutOfBoundsException();
        }
        
        return new Vector2D(this.array[0][columnIndex], this.array[1][columnIndex]);
    }
    
    public void setArray(float[][] matrix){
        this.array = matrix.clone();
    }
    
    public Matrix matMul(Matrix matrix){
        if (this.columns != matrix.rows){
            System.err.println("Invalid matrix multiplication with dimensions " + this.rows + "x" + this.columns + " and " + matrix.rows + "x" + matrix.columns);
            return null;
        }
      
        Matrix tempMatrix = new Matrix(this.rows, matrix.columns);
        for (int r = 0; r < this.rows; r++){
            for (int c = 0; c < matrix.columns; c++){
                float cell = 0;
                for (int i = 0; i < this.columns; i++) {
                    cell += this.getVal(r, i) * matrix.getVal(i, c);
                }
                tempMatrix.setVal(r, c, cell);
            }
        }
        
        return tempMatrix;
    }
}
