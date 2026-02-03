ArrayList<Shape2D> objects = new ArrayList<>();
CollisionHandler ch;
ShapeDrawer sd;
Mathf mathf = new Mathf();

class GameObject{
    Shape2D gameObject;

    public GameObject(Shape2D obj){
        this.gameObject = obj;
    }

    public void update(){
        
    }

    public void onTriggerEnter(){

    }

    public void onTriggerExit(){

    }

    public void onCollisionEnter(){

    }

    public void onCollisionExit(){

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