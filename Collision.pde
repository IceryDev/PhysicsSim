class CollisionHandler{
  
    ArrayList<Collision2D> collisions = new ArrayList<>();
    
    public void handleCollisions(ArrayList<Shape2D> objects){
        if (objects.size() < 2) { return; }
        
        for (int i = 0; i < objects.size(); i++){ //Change this it won't work for multiple objects
            for (int j = i + 1; j < objects.size(); j++){
                Collision2D tmp = getCollision(objects.get(i).transform, objects.get(j).transform);
                if (tmp != null){
                    collisions.add(tmp);
                }
            }
            objects.get(i).transform.collider.isColliding = false;
        }
        
        for (Collision2D collision : collisions){
            collision.collidedObjects[0].collider.isColliding = true;
            collision.collidedObjects[1].collider.isColliding = true;
        }
        
        calculateResults();
        collisions.clear();
        
    }
    
    private void calculateResults(){
        for (Collision2D c : collisions){
            if (c.applied) {continue;}
            
            float correction = 0;
            Transform objA = c.collidedObjects[0];
            Transform objB = c.collidedObjects[1];
            boolean isStaticA = objA.collider.isStatic;
            boolean isStaticB = objB.collider.isStatic;
            
            if ((isStaticA && isStaticB)) {continue;}
            
            if (!isStaticA){ correction = (isStaticB) ? -1 : -0.5; }
            objA.pos.vectorSum(c.collisionAxis.copy().scalarMul((correction+1) * c.collisionDepth * 1.005));
            objB.pos.vectorSum(c.collisionAxis.copy().scalarMul((correction) * c.collisionDepth * 1.005));
            
            objA.translatePos();
            objB.translatePos();

            Vector2D relativeV = objB.parent.rb.velocity.copy();
            relativeV.vectorSum(objA.parent.rb.velocity.copy().negate());
            float velProjection = relativeV.scalarProject(c.collisionAxis, false);
            
            
            //Coefficient of Restitution
            float coef = Math.min(objA.collider.getCor(), objB.collider.getCor());
            float impulseMagnitude = -(1+coef) * velProjection / (((isStaticA) ? 0 : (1/objA.parent.rb.mass)) + ((isStaticB) ? 0 : (1/objB.parent.rb.mass)));
            
            Vector2D impulse = c.collisionAxis.copy().scalarMul(impulseMagnitude);
            
            if(!isStaticA){ objA.parent.rb.applyImpulse(new Force2D(-impulse.x, -impulse.y, ForceMode.Impulse), c); }
            if(!isStaticB){ objB.parent.rb.applyImpulse(new Force2D(impulse.x, impulse.y, ForceMode.Impulse), c); }
            c.applied = true;
        }
    }
    
    private Collision2D getCollision(Transform objA, Transform objB){
        Vector2D collisionAxis = null;
        float min = Float.MAX_VALUE;
        
        boolean isPolyA = (objA.collider != Collider2D.Circle);
        boolean isPolyB = (objB.collider != Collider2D.Circle);
        
        int colsA = (isPolyA) ? objA.edgeNormals.columns : 0;
        int colsB = (isPolyB) ? objB.edgeNormals.columns : 0;
        //System.out.println(colsA + ":" + colsB);
        
        if (isPolyA == isPolyB && isPolyA == false){
            Vector2D displacement = new Vector2D(0, 0);
            displacement.vectorSum(objA.pos.copy().negate()).vectorSum(objB.pos.copy());
            if (displacement.magnitude() >= (objA.size.x + objB.size.x)/2){
                return null;
            }
            
            return new Collision2D(displacement.magnitude(), displacement, objA, objB);
        }
        else{
            for (int i = 0; i < colsA + colsB; i++){
               
               Vector2D currentEdgeNormal = ((i < colsA) ? objA.edgeNormals.getVec(i) : objB.edgeNormals.getVec(i - colsA)).copy().normalise();
               Vector2D minMaxA = (isPolyA) ? getMaxAndMinProjection(currentEdgeNormal, objA.vertexTransform) : 
                                                                     getMaxAndMinCircle(currentEdgeNormal, objA.pos, objA.size.x);
               Vector2D minMaxB = (isPolyB) ? getMaxAndMinProjection(currentEdgeNormal, objB.vertexTransform) : 
                                                                     getMaxAndMinCircle(currentEdgeNormal, objB.pos, objB.size.x);
                    
               if (minMaxA.y < minMaxB.x || minMaxB.y < minMaxA.x){
                   return null;
               }
                    
               float overlap = Math.min(minMaxA.y, minMaxB.y) - Math.max(minMaxA.x, minMaxB.x); // x is min and y is max
                    
               if (min > overlap) {
                   collisionAxis = currentEdgeNormal.copy();
                   min = overlap;
               }
            }
            return new Collision2D(min, collisionAxis, objA, objB);
        } 
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
    public boolean applied = false;
    
    public Collision2D(float collisionDepth, Vector2D axis, Transform objA, Transform objB){
        this.collisionDepth = collisionDepth;
        
        //Collision axis direction calculation
        this.collisionAxis = new Vector2D(axis.x, axis.y);
        this.collisionAxis.normalise();
        Vector2D vecAToB = new Vector2D(objB.pos.x, objB.pos.y);
        vecAToB.negate().vectorSum(new Vector2D(objA.pos.x, objA.pos.y));
        if (vecAToB.scalarProject(this.collisionAxis, false) < 0){
            this.collisionAxis.negate();
        }
        
        this.collidedObjects[0] = objA;
        this.collidedObjects[1] = objB;
        
    }
}
