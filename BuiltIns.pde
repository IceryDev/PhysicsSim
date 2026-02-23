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
    public boolean enabled = true;
    Vector2D pos = new Vector2D(0, 0);
    Vector2D size = new Vector2D(1, 1);

    public UIElement setPos(float x, float y){
        this.pos = new Vector2D(x, y);
        return this;
    }

    public UIElement setSize(float x, float y){
        this.size = new Vector2D(x, y);
        return this;
    }
}

abstract class Button extends UIElement{
    
    boolean hasOutline = false;
    String text;

    public Button(){

    }

    public void onClick(){

    }
}

class Canvas{
    ArrayList<UIElement> elements = new ArrayList<>();
    Vector2D defaultElementSize;

    public void addElement(UIElement e){
        if (e == null) { return; }
        this.elements.add(e);
    }

    public void setDefaultElementSize(float sizeX, float sizeY){

    }


}

class Scene{
    Canvas sceneCanvas;
    ArrayList<Shape2D> shapes = new ArrayList<>();
    ArrayList<GameObject> gameObjects = new ArrayList<>();
    HashMap<UtilityType, Utility> handlers = new HashMap<>();
    String name = "0";

    public Scene(boolean useDefault){
        if (!useDefault) { return; }
        this.addHandler(UtilityType.Shapes)
            .addHandler(UtilityType.Collisions)
            .addHandler(UtilityType.Objects);
        SceneManager.addScene(this);
        if (SceneManager.activeScene == null) { SceneManager.activeScene = this; }
    }

    public void updateScene(){
        for (Utility u : handlers.values()){
            u.update(this);
        }
        this.cleanup();
    }

    public Scene addHandler(UtilityType ut){
        Utility u;
        switch(ut){
            case Shapes:
                u = new ShapeDrawer();
                break;
            case Collisions:
                u = new CollisionHandler();
                break;
            case Objects:
                u = new ObjectHandler();
                break;
            default:
                System.err.println("No utility type matches the type given.");
                return this;
        }
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