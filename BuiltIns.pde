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

class UIBuilder{
    UIProperties p = new UIProperties();

    public UIBuilder setPos(float x, float y){
        this.p.pos = new Vector2D(x, y);
        return this;
    }

    public UIBuilder setSize(float x, float y){
        this.p.size = new Vector2D(x, y);
        return this;
    }

    public UIBuilder setText(String text){
        this.p.text = text;
        return this;
    }

    public UIBuilder removeText(){
        this.p.text = null;
        return this;
    }

    public UIBuilder setLayer(int layer){
        this.p.layer = layer;
        return this;
    }

    public UIBuilder setFill(int R, int G, int B){
        this.p.fillColor[0] = (int) mathf.clamp(R, 0, 255);
        this.p.fillColor[1] = (int) mathf.clamp(G, 0, 255);
        this.p.fillColor[2] = (int) mathf.clamp(B, 0, 255);
        return this;
    }

    public UIBuilder setTextColor(int R, int G, int B){
        this.p.textColor[0] = (int) mathf.clamp(R, 0, 255);
        this.p.textColor[1] = (int) mathf.clamp(G, 0, 255);
        this.p.textColor[2] = (int) mathf.clamp(B, 0, 255);
        return this;
    }

    public UIBuilder setType(String type){
        this.p.type = type;
        return this;
    }

    public UIBuilder setBorder(boolean hasBorder){
        this.p.hasBorder = hasBorder;
        return this;
    }

    public UIBuilder setSmooth(int smooth){
        this.p.borderSmooth = smooth;
        return this;
    }

    public UIBuilder addImage(PImage img){
        this.p.img = img;
        return this;
    }

    public UIProperties build(){
        return this.p;
    }
}

class UIProperties{
    Vector2D pos = new Vector2D(0, 0);
    Vector2D size;
    UIShape shape = UIShape.Rect;
    protected int layer = 0;
    String type = "Widget";
    PImage img;

    //Text
    String text;
    int textSize = 20;

    //Color
    int[] fillColor = {0, 0, 0};
    int[] borderColor = {0, 0, 0};
    int[] textColor = {0, 0, 0};

    //Settings
    public boolean hasBorder = false;
    int strokeThickness = 1;
    int borderSmooth = 0;
}

class UIElement{
    Vector2D pos = new Vector2D(0, 0);
    Vector2D size;
    public UIShape shape = UIShape.Rect;
    protected int layer = 0;
    Canvas attachedCanvas;
    String type = "Widget";
    PImage img;

    //Text
    String text;
    int textSize = 20;

    //Color
    int[] fillColor = {0, 0, 0};
    int[] borderColor = {0, 0, 0};
    int[] textColor = {0, 0, 0};

    //Settings
    public boolean enabled = true;
    public boolean hasBorder = false;
    protected boolean hasEvent = false;
    int strokeThickness = 1;
    int borderSmooth = 0;

    public UIElement(UIProperties p){
        if (!SceneManager.activeScene.checkHandler(UtilityType.UI)){
            System.err.println("No canvas found in the active scene, element could not be appended!");
            return;
        }
        this.pos.x = p.pos.x;
        this.pos.y = p.pos.y;
        this.size = (p.size != null) ? new Vector2D(p.size.x, p.size.y) : 
                        new Vector2D(this.attachedCanvas.defaultElementSize.x, this.attachedCanvas.defaultElementSize.y);
        for (int i = 0; i < this.fillColor.length; i++){
            this.fillColor[i] = p.fillColor[i];
            this.textColor[i] = p.textColor[i];
            this.borderColor[i] = p.borderColor[i];
        }
        if (p.text != null){
            this.text = p.text;
        }
        if (p.img != null){
            this.img = p.img;
        }
        this.hasBorder = p.hasBorder;
        this.borderSmooth = p.borderSmooth;
        this.attachedCanvas = (Canvas) SceneManager.activeScene.handlers.get(UtilityType.UI);
        this.attachedCanvas.addElement(this);
    }

    public void changeColor(int R, int G, int B){
        this.fillColor[0] = (int) mathf.clamp(R, 0, 255);
        this.fillColor[1] = (int) mathf.clamp(G, 0, 255);
        this.fillColor[2] = (int) mathf.clamp(B, 0, 255);
    }

    public void drawElement(){
        switch(this.shape){
            case Rect:
                if(this.hasBorder) { 
                    stroke(this.borderColor[0], this.borderColor[1], this.borderColor[2]); 
                    strokeWeight(this.strokeThickness);
                }
                else { noStroke(); }
                fill(this.fillColor[0], this.fillColor[1], this.fillColor[2]);
                rect(this.pos.x, this.pos.y, this.size.x, this.size.y, this.borderSmooth);
                noStroke();
                if (this.text != null) { 
                    float tWidth = textWidth(this.text);
                    textSize(this.textSize);
                    fill(this.textColor[0], this.textColor[1], this.textColor[2]);
                    text(this.text, this.pos.x - (tWidth/2), this.pos.y + (this.textSize/3)); 
                }
                break;
            case Ellipse:
                if(this.hasBorder) { 
                    stroke(this.borderColor[0], this.borderColor[1], this.borderColor[2]); 
                    strokeWeight(this.strokeThickness);
                }
                else { noStroke(); }
                fill(this.fillColor[0], this.fillColor[1], this.fillColor[2]);
                ellipse(this.pos.x, this.pos.y, this.size.x, this.size.y);
                noStroke();
                if (this.text != null) { 
                    float tWidth = textWidth(this.text);
                    textSize(this.textSize);
                    fill(this.textColor[0], this.textColor[1], this.textColor[2]);
                    text(this.text, this.pos.x - (tWidth/2), this.pos.y + (this.textSize/3)); 
                }
                break;
            case Image:
            default:
                System.out.println("No such shape type exists in the drawElement method.");
                break;
        }
    }
}

enum UIShape{
    Ellipse,
    Rect,
    Image;
}

enum EventSource{
    MouseClick,
    MouseRelease,
    MouseMove;
}

static class EventListener{
    static ArrayList<Character> keys = new ArrayList<>();

    public static void checkEvents(EventSource e){
        Scene tmp = SceneManager.activeScene;
        for(UIElement u : tmp.elements){
            if (!u.hasEvent) continue;

            switch(u.type){
                case "Button":
                    Button b = (Button) u;
                    if (b.getEvent()){
                        if (!b.eventConfig.containsKey(e)) {continue;}
                        b.eventConfig.get(e).run();
                    }
                    else {
                        if (!b.negativeConfig.containsKey(e)) {continue;}
                        b.negativeConfig.get(e).run();
                    }
                    break; 
            }
        }
    }

}

abstract class Button extends UIElement{
    HashMap<EventSource, Runnable> eventConfig = 
            new HashMap<>(Map.of(EventSource.MouseClick, () -> this.onClick(),
                                EventSource.MouseMove, () -> this.onHover(),
                                EventSource.MouseRelease, () -> this.onRelease()));
    HashMap<EventSource, Runnable> negativeConfig =
            new HashMap<>(Map.of(EventSource.MouseMove, () -> this.onHoverExit(),
                                EventSource.MouseRelease, () -> this.onRelease()));

    public Button(UIProperties p){
        super(p);
        this.hasEvent = true;
        this.type = "Button";
    }

    public void onClick(){};

    public void onHover(){};

    public void onHoverExit(){};

    public void onRelease(){};

    public boolean getEvent(){
        return ((mouseX > this.pos.x - this.size.x/2 && mouseX < this.pos.x + this.size.x/2) &&
                (mouseY > this.pos.y - this.size.y/2 && mouseY < this.pos.y + this.size.y/2));
    }
}

class Canvas implements Utility{
    Vector2D defaultElementSize = new Vector2D(1, 1);
    Scene attachedScene;

    public Canvas(Scene scene){
        this.attachedScene = scene;
    }

    public void addElement(UIElement e){
        if (e == null) { return; }
        this.attachedScene.elements.add(e);
        this.attachedScene.sortUI();
    }

    public void setDefaultElementSize(float sizeX, float sizeY){
        this.defaultElementSize = new Vector2D(sizeX, sizeY);
    }

    public void update(Scene scene){
        for (UIElement u : scene.elements){
            u.drawElement();
        }
    }

    public UtilityType getKey(){
        return UtilityType.UI;
    }

}

class Scene{
    ArrayList<Shape2D> shapes = new ArrayList<>();
    ArrayList<GameObject> gameObjects = new ArrayList<>();
    HashMap<UtilityType, Utility> handlers = new HashMap<>();
    ArrayList<UIElement> elements = new ArrayList<>();
    String name = "0";
    private int[] backgroundColor = {0, 0, 0};

    public Scene(boolean useDefault){
        if (!useDefault) { return; }
        this.addHandler(UtilityType.Shapes)
            .addHandler(UtilityType.Collisions)
            .addHandler(UtilityType.Objects)
            .addHandler(UtilityType.UI);
        SceneManager.addScene(this);
        if (SceneManager.activeScene == null) { SceneManager.activeScene = this; }
    }

    public void updateScene(){
        background(this.backgroundColor[0], this.backgroundColor[1], this.backgroundColor[2]);
        for (Utility u : handlers.values()){
            u.update(this);
        }
        
        this.cleanup();
    }

    public void changeBackground(int grayScale){
        this.backgroundColor[0] = (int) mathf.clamp(grayScale, 0, 255);
        this.backgroundColor[1] = (int) mathf.clamp(grayScale, 0, 255);
        this.backgroundColor[2] = (int) mathf.clamp(grayScale, 0, 255);
    }

    public void changeBackground(int R, int G, int B){
        this.backgroundColor[0] = (int) mathf.clamp(R, 0, 255);
        this.backgroundColor[1] = (int) mathf.clamp(G, 0, 255);
        this.backgroundColor[2] = (int) mathf.clamp(B, 0, 255);
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
            case UI:
                u = new Canvas(this);
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

    public boolean checkHandler(UtilityType key){
        return this.handlers.containsKey(key);
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

    protected void sortUI(){
        elements.sort((UIElement a, UIElement b) -> Integer.compare(a.layer, b.layer));
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
        scene.name = "" + (scenes.size());
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

        for (String s : scenes.keySet()){
            System.out.println(s);
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
    Shapes,
    UI;
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