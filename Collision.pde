class CollisionHandler{
    public void handleCollisions(ArrayList<Shape2D> objects){
        if (objects.size() < 2) { return; }
        for (int i = 0; i < objects.size(); i++){ //Change this it won't work for multiple objects
            for (int j = i + 1; j < objects.size(); j++){
                Collision2D tmp = isColliding(objects.get(i).transform, objects.get(j).transform);
                if (tmp != null){
                    objects.get(i).setColor(255, 0, 0);
                    objects.get(j).setColor(255, 0, 0);
                    System.out.println(objects.get(0).colr[1]);
                }
                else {
                    objects.get(i).setColor(255, 255, 255);
                    objects.get(j).setColor(255, 255, 255);
                    System.out.println(objects.get(0).colr[1]);
                }
            }
        }
    }
    
    private void calculateResults(){
    
    }
    
    private Collision2D isColliding(Transform objA, Transform objB){
        Vector2D collisionAxis = null;
        float min = Float.MAX_VALUE;
        
        boolean isPolyA = (objA.collider != Collider2D.Circle);
        boolean isPolyB = (objB.collider != Collider2D.Circle);
        
        int colsA = (isPolyA) ? objA.edgeNormals.columns : 0;
        int colsB = (isPolyB) ? objB.edgeNormals.columns : 0;
        
        if (isPolyA == isPolyB && isPolyA == false){
            Vector2D displacement = new Vector2D(0, 0);
            displacement.vectorSum(objA.pos).vectorSum(objB.pos.negate());
            if (displacement.magnitude() >= (objA.size.x + objB.size.x)/2){
                return null;
            }
            
            return new Collision2D(displacement.magnitude(), displacement, objA, objB);
        }
        else{
            for (int i = 0; i < colsA + colsB; i++){
               Vector2D currentEdgeNormal = (i < colsA) ? objA.edgeNormals.getVec(i) : objB.edgeNormals.getVec(i - colsA);
               Vector2D minMaxA = (isPolyA) ? getMaxAndMinProjection(currentEdgeNormal, objA.vertexTransform) : 
                                                                     getMaxAndMinCircle(currentEdgeNormal, objA.pos, objA.size.x);
               Vector2D minMaxB = (isPolyB) ? getMaxAndMinProjection(currentEdgeNormal, objB.vertexTransform) : 
                                                                     getMaxAndMinCircle(currentEdgeNormal, objB.pos, objB.size.x);
                    
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
        }
         //<>//
        //return null;
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
    
    private Vector2D getMaxAndMinCircle(Vector2D axis, Vector2D centre, float diameter){
        float projectionScale = centre.scalarProject(axis, false);
        return new Vector2D(projectionScale - (diameter/2), projectionScale + (diameter/2));
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
