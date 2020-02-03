private static final int SCREEN_SIZE = 500; //The size of the gameScreen
private static final int GUI_HEIGHT = 100;  //Space required for score and other things

private static final int TICK_DELAY = 50; //20tps
private int lastTick;

public void settings(){
  size(SCREEN_SIZE, SCREEN_SIZE + GUI_HEIGHT);
}

public void setup(){
  newGame();
}

public void draw(){
  renderFrame();
  if(millis() - lastTick >= TICK_DELAY){
    lastTick += TICK_DELAY;
    gameTick();
  }
}
