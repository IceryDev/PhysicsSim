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

class Box extends GameObject{
    public Box(Shape2D obj){
        super(obj);
    }
}