//things for drawing

//colors should be all in one place
//private static final color PLAYER_COLOR = #7BDE98;
private static final color POTATO_COLOR = #BCB308;
private static final color BACKGROUND_COLOR = #D0DCF0;
private static final color GUI_COLOR = #0A0467;
private static final color GUI_HOVER_COLOR = #03CEFF;

//for animations
/*private static final int ANIMATION_EMPTY = 0;
private static final int ANIMATION_HOVER = 1;
private static final int ANIMATION_LEAVE = 2;
private static final int ANIMATION_ACTIVATE = 4;
private static final int ANIMATION_DEACTIVATE = 8;*/

private int lastFrame;
private int elapsedTime;


//render one frame of the game
private void renderFrame(){
  elapsedTime = millis() - lastFrame;
  lastFrame += elapsedTime;
  
  background(BACKGROUND_COLOR);
  
  //the game is rendered under the gui and we'd like to have the coordinates adjusted
  pushMatrix();
  translate(0, GUI_HEIGHT);
  for(Potato p : potatoes)
    p.display();
  
  displayPlayer();
  popMatrix();
  
  displayGUI();//gui tab (it was getting long)
}
