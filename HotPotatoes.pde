import shiffman.box2d.*;

import org.jbox2d.collision.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

private static final int SCREEN_SIZE = 500; //The size of the gameScreen
private static final int GUI_HEIGHT = 100;  //Space required for score and other things

private static final int TICK_DELAY = 25; //40tps
private int lastTick;

public void settings(){
  try{
    highScore = parseInt(loadStrings("data.txt")[0]);
  }catch(Exception e){
    highScore = 0;
  }
  size(SCREEN_SIZE, SCREEN_SIZE + GUI_HEIGHT);
}

public void setup(){
  initPhysics();
  newGame();
}

public void draw(){
  renderFrame();
  if(millis() - lastTick >= TICK_DELAY){
    lastTick += TICK_DELAY;
    gameTick();
  }
}

//called whenever some two things collide in the game (an event just like mousePressed, that is called automaticaly)
public void beginContact(Contact cp){
  //get the data
  Object o1 = cp.getFixtureA().getBody().getUserData();
  Object o2 = cp.getFixtureB().getBody().getUserData();
  
  if(o2 instanceof String && (String)o2 == "Player"){
    Object tmp = o2; o2 = o1; o1 = tmp; //if one of the bodies has the player tag, make sure it's the first one
  }
  
  if(o1 instanceof String && (String)o1 == "Player" && o2 instanceof Potato){//if the other one has a potato attached to it
    ((Potato)o2).handlePlayerCollision();
  }
}
