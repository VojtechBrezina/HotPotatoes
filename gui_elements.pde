private class GUIElement{
  protected float x, y, w, h;
  protected boolean drawBorder;
  protected GUIElementContent content;
  private boolean hovered = false;
  public boolean enabled = true;
  protected GUIElementListener listener;
  
  public GUIElement(float x, float y, float w, float h, boolean db, GUIElementContent c, GUIElementListener l){
    this.x = x; this.y = y; this.w = w; this.h = h;
    drawBorder = db;
    content = c;
  }
  
  public void display(){
    if(drawBorder){
      noFill();
      stroke(GUI_COLOR);
      rect(x, y, w, h);
    }
    content.display();
  }
}

private interface GUIElementListener{
  public void hovered();
  public void clicked();
}

private abstract class GUIElementContent{
  public abstract void display();
}

private class TextContent extends GUIElementContent{
  private String text;
  private int align;
  private float x, y;
  private float size;
  
  public TextContent(String t, int a, float x, float y, float s){
    text = t;
    align = a;
    this.x = x; this.y = y;
    size = s;
  }
  
  public void set(String t){
    text = t;
  }
  
  public void display(){
    pushStyle();
    textSize(size);
    fill(GUI_COLOR);
    textAlign(align);
    text(text, x, y);
    popStyle();
  }
}

private class Button extends GUIElement{
  private ButtonListener buttonListener;
  
  public Button(float x, float y, float w, float h, GUIElementContent c, ButtonListener bl){
    super(x, y, w, h, true, c, null);
    listener = new GUIElementListener(){
      public void hovered(){}
      public void clicked(){
        buttonListener.clicked();
      }
    };
    buttonListener = bl;
  }
}

private interface ButtonListener{
  public void clicked();
}
