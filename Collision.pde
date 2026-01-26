class CollisionHandler{
    public void handleCollisions(ArrayList<Shape2D> objects){
        if (objects.size() < 2) { return; }
        for (int i = 0; i < objects.size() - 1; i++){ //Change this it won't work for multiple objects
            if (isColliding(objects.get(i).transform, objects.get(i+1).transform, 2) != null){
                objects.get(i).setColor(255, 0, 0);
                objects.get(i+1).setColor(255, 0, 0);
            }
            else {
                objects.get(i).setColor(255, 255, 255);
                objects.get(i+1).setColor(255, 255, 255);
            }
        }
    }
    
    private void calculateResults(){
    
    }
    
    private Collision2D isColliding(Transform objA, Transform objB, int collisionType){
        switch(collisionType){
            case 0: //Circle-Circle
                break;
            case 1: //Polygon-Circle (objA is the polygon)
                break;
            case 2: //Polygon-Polygon
                int colsA = objA.edgeNormals.columns;
                int colsB = objB.edgeNormals.columns;
                Vector2D collisionAxis = null;
                float min = Float.MAX_VALUE;
                for (int i = 0; i < colsA + colsB; i++){ //<>//
                    Vector2D currentEdgeNormal = (i < colsA) ? objA.edgeNormals.getVec(i) : objB.edgeNormals.getVec(i - colsA);
                    Vector2D minMaxA = getMaxAndMinProjection(currentEdgeNormal, objA.vertexTransform);
                    Vector2D minMaxB = getMaxAndMinProjection(currentEdgeNormal, objB.vertexTransform);
                    
                    if (minMaxA.y < minMaxB.x || minMaxB.y < minMaxA.x){
                        return null;
                    }
                    
                    float overlap = Math.min(minMaxA.y, minMaxB.y) - Math.max(minMaxA.x, minMaxB.x); // x is min and y is max
                    
                    if (min > overlap) {
                        collisionAxis = currentEdgeNormal;
                        min = overlap;
                    }
                }
                
                return new Collision2D(min, collisionAxis, objA, objB);
            default:
                break;
        }
        return null;
    }
    
    private Vector2D getMaxAndMinProjection(Vector2D axis, Matrix vertices){
        float min = Float.MAX_VALUE;
        float max = -Float.MAX_VALUE;
        for (int i = 0; i < vertices.columns; i++){
            float tmp = vertices.getVec(i).scalarProject(axis, false);
            min = Math.min(min, tmp);
            max = Math.max(max, tmp);
        }
        return new Vector2D(min, max);
    }
}

class Collision2D{
    public float collisionDepth = -1; //Negative/Zero/Positive -> Not colliding/Touching/Colliding
    public Vector2D collisionAxis; // null if no collision
    public Transform[] collidedObjects = new Transform[2];
    
    public Collision2D(float collisionDepth, Vector2D collisionAxis, Transform objA, Transform objB){
        this.collisionDepth = collisionDepth;
        this.collisionAxis = collisionAxis;
        this.collidedObjects[0] = objA;
        this.collidedObjects[1] = objB;
    }
}
