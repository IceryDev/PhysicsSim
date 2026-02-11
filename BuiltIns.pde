ShapeBuilder shapeBuilder = new ShapeBuilder();
Scene defaultScene = new Scene(true);
Mathf mathf = new Mathf();

class GameObject{
    Shape2D shape;
    Scene parent;
    protected boolean isDestroyed = false;
    protected int layer = 0;
    String tag = "Default";

    public GameObject(Shape2D obj){
        this.shape = obj;
        this.shape.gameObject = this;
        this.parent = SceneManager.activeScene;
        this.parent.gameObjects.add(this);
        this.parent.shapes.add(this.shape);
    }

    public void update(){}

    @SuppressWarnings("unused")
    public void onTriggerEnter(GameObject other){}

    @SuppressWarnings("unused")
    public void onTriggerExit(GameObject other){}

    @SuppressWarnings("unused")
    public void onCollisionEnter(GameObject other){}

    @SuppressWarnings("unused")
    public void onCollisionExit(GameObject other){}

    public void setLayer(int layer){
        this.layer = layer;
        SceneManager.activeScene.sortObjects();
    }

    public int getLayer(){
        return this.layer;
    }

    public void destroy(){
        this.isDestroyed = true;
    }
}

class UIElement{
    //Functionality to come here. :)
}

class Scene{
    ArrayList<Shape2D> shapes = new ArrayList<>();
    ArrayList<GameObject> gameObjects = new ArrayList<>();
    HashMap<UtilityType, Utility> handlers = new HashMap<>();
    String name = "0";

    public Scene(boolean useDefault){
        if (!useDefault) { return; }
        CollisionHandler ch = new CollisionHandler();
        ShapeDrawer sd = new ShapeDrawer();
        ObjectHandler oh = new ObjectHandler();
        this.addHandler(sd)
            .addHandler(ch)
            .addHandler(oh);
        SceneManager.addScene(this);
        if (SceneManager.activeScene == null) { SceneManager.activeScene = this; }
    }

    public void updateScene(){
        for (Utility u : handlers.values()){
            u.update(this);
        }
        this.cleanup();
    }

    public Scene addHandler(Utility u){
        this.handlers.put(u.getKey(), u);
        return this;
    }

    public Scene removeHandler(UtilityType key) {
        this.handlers.remove(key);
        return this;
    }

    private void cleanup(){
        for (int i = this.gameObjects.size() - 1; i >= 0; i--){
            if (this.gameObjects.get(i).isDestroyed) {
                this.gameObjects.remove(i);
                this.shapes.remove(i);
            }
        }
    }

    protected void sortObjects(){
        shapes.sort((Shape2D a, Shape2D b) -> Integer.compare(a.gameObject.layer, b.gameObject.layer));
        gameObjects.sort((GameObject a, GameObject b) -> Integer.compare(a.layer, b.layer));
    }
}

static class SceneManager{
    static HashMap<String, Scene> scenes = new HashMap<>();
    static Scene activeScene;

    public static void changeScene(String name){
        if(!scenes.containsKey(name)){
            System.err.println("No such scene \"" + name + "\" exists!");
            return;
        }
        activeScene = scenes.get(name);
    }

    public static void addScene(Scene scene){
        scene.name = "" + scenes.size();
        scenes.put(scene.name, scene);
    }

    public static void addScene(Scene scene, String name){
        scene.name = name;
        scenes.put(name, scene);
    }

    public static void listScenes(){
        for (Scene s : scenes.values()){
            System.out.println("Scene: " + s.name);
        }
    }

    public static void updateActive(){
        activeScene.updateScene();
    }
    
}

interface Utility{

    public void update(Scene scene);
    public UtilityType getKey();
}

enum UtilityType{
    Collisions,
    Objects,
    Shapes;
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

class ObjectHandler implements Utility{

    public void update(Scene scene){
        for (int i = 0; i < scene.shapes.size(); i++){
            scene.shapes.get(i).update();
        }

        for (int i = 0; i < scene.gameObjects.size(); i++){
            scene.gameObjects.get(i).update();
        }
    }

    public UtilityType getKey(){
        return UtilityType.Objects;
    }
}