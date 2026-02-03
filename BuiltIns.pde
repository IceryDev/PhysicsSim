ArrayList<Shape2D> objects = new ArrayList<>(); //Stores all the shapes
ArrayList<GameObject> gameObjects = new ArrayList<>(); //Stores all the objects
CollisionHandler ch;
ShapeDrawer sd;
Mathf mathf = new Mathf();

class GameObject{
    Shape2D shape;
    String tag = "Default";

    public GameObject(Shape2D obj){
        this.shape = obj;
        this.shape.gameObject = this;
    }

    public void update(){
        
    }

    public void onTriggerEnter(GameObject other){

    }

    public void onTriggerExit(GameObject other){

    }

    public void onCollisionEnter(GameObject other){

    }

    public void onCollisionExit(GameObject other){

    }

    public void destroy(){
        
    }
}

class Timer{
    int time = 0;
    int totalTime;
    public boolean started = false;
    
    public Timer(int timer){
        this.time = timer;
        this.totalTime = timer;
        this.started = false;
    }
    
    public boolean updateTime(){
        if (this.started == false) {return true;}
        this.time--;
        if (this.time <= 0){
            this.started = false;
            return true;
        }
        else {
            return false;
        }
    }
    
    public void startTimer(){
        this.started = true;
        this.time = this.totalTime;
    }
    
}