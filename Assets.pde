class TestButton extends Button{
    int[] myColor = {255, 0, 0};
    
    public TestButton(UIProperties p){
        super(p);
    }

    public void setColor(int R, int G, int B){
        this.myColor[0] = R;
        this.myColor[1] = G;
        this.myColor[2] = B;
    }

    @Override
    public void onClick(){
        box.shape.setColor(this.myColor[0], this.myColor[1], this.myColor[2]);
        System.out.println(this.text + " was clicked!");
    }

    @Override
    public void onHover(){
        for(int i = 0; i < this.borderColor.length; i++){
            this.borderColor[i] = 0;
        }
    }

    @Override
    public void onHoverExit(){
        for(int i = 0; i < this.borderColor.length; i++){
            this.borderColor[i] = 255;
        }
    }
}

class SceneSwitchButton extends Button{
    String sceneToSwitch = "0";
    
    SceneSwitchButton(UIProperties p){
        super(p);
    }

    @Override
    public void onClick(){
       SceneManager.changeScene(this.sceneToSwitch);
    }

    @Override
    public void onHover(){
        for(int i = 0; i < this.borderColor.length; i++){
            this.borderColor[i] = 0;
        }
    }

    @Override
    public void onHoverExit(){
        for(int i = 0; i < this.borderColor.length; i++){
            this.borderColor[i] = 255;
        }
    }
}

class ToggleSwitch extends Button{
    boolean state = false;

    ToggleSwitch(UIProperties p){
        super(p);
    }

    @Override
    public void onClick(){
       if (this.state) {this.changeColor(120, 200, 120);}
       else {this.changeColor(200, 120, 200);}

       this.state = !this.state;
    }

    @Override
    public void onHover(){
        for(int i = 0; i < this.borderColor.length; i++){
            this.borderColor[i] = 0;
        }
    }

    @Override
    public void onHoverExit(){
        for(int i = 0; i < this.borderColor.length; i++){
            this.borderColor[i] = 255;
        }
    }
}

class IncrementButton extends Button{
    boolean state = false;
    int effectedCounter = 0;

    IncrementButton(UIProperties p){
        super(p);
    }

    @Override
    public void onClick(){
       if (this.state) {currentVal[effectedCounter]++; counter[effectedCounter].text = "Count: " + currentVal[effectedCounter];}
       else {
        if(currentVal[effectedCounter] == 0) {return;}
        currentVal[effectedCounter]--; 
        counter[effectedCounter].text = "Count: " + currentVal[effectedCounter];
    }
    }

    @Override
    public void onHover(){
        for(int i = 0; i < this.borderColor.length; i++){
            this.borderColor[i] = 0;
        }
    }

    @Override
    public void onHoverExit(){
        for(int i = 0; i < this.borderColor.length; i++){
            this.borderColor[i] = 255;
        }
    }
}

class Handle extends Button{
    boolean clicked = false;

    Handle(UIProperties p){
        super(p);
    }

    @Override
    public void onClick(){
       this.clicked = true;
    }

    @Override
    public void onRelease(){
        this.clicked = false;
    }

    @Override
    public void onHover(){
        for(int i = 0; i < this.borderColor.length; i++){
            this.borderColor[i] = 0;
        }
    }

    @Override
    public void onHoverExit(){
        for(int i = 0; i < this.borderColor.length; i++){
            this.borderColor[i] = 255;
        }
    }

    @Override
    public void drawElement(){
        if (this.clicked) { 
            this.pos = new Vector2D(mathf.clamp(mouseX, 220, 500), this.pos.y); 
            sliderVal = (int) mathf.clamp((int)(10*(mouseX - 220)/280), 0, 10);
            this.size.x = 20 + sliderVal;
            this.size.y = 20 + sliderVal;
            valueDisplay.text = "" + sliderVal;
            c.appliedV = 1 + sliderVal/5;
        }
        super.drawElement();
    }
}

class ApplyForceButton extends Button{
    ApplyForceButton(UIProperties p){
        super(p);
    }

    @Override
    public void onClick(){
       c.shape.rb.velocity = new Vector2D(c.appliedV, 0);
       c.shape.rb.rotateBody(mathf.randInt((int)mathf.deg2Rad(360)));
    }
}

class Box extends GameObject{
    public Box(Shape2D obj){
        super(obj);
    }
}

class Ball extends GameObject{
    float appliedV = 0;

    public Ball(Shape2D obj){
        super(obj);
    }
}

class Border extends GameObject{
    public Border(Shape2D obj){
        super(obj);
    }
}