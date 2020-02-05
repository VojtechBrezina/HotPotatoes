import shiffman.box2d.*;

import org.jbox2d.collision.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

private static final int SCREEN_SIZE = 700; //The size of the gameScreen

private static final int TICK_DELAY = 25; //40tps
private int lastTick;

public void settings(){
  size(SCREEN_SIZE, SCREEN_SIZE + GUI_HEIGHT);
}

public void setup(){
  try{
    highScore = parseInt(loadStrings("data.txt")[0]);
  }catch(Exception e){
    highScore = 0;
  }
  initPhysics();
  newGame();
  lastFrame = millis();
}

public void draw(){
  if(millis() - lastTick >= TICK_DELAY){
    lastTick += TICK_DELAY;
    gameTick();
  }
  
  renderFrame();
}

//called whenever some two things collide in the game (an event just like mousePressed, that is called automaticaly)
public void beginContact(Contact cp){
  //get the data
  Object o1 = cp.getFixtureA().getBody().getUserData();
  Object o2 = cp.getFixtureB().getBody().getUserData();
  
  if(o2 instanceof String && ((String)o2).equals("Player")){
    Object tmp = o2; o2 = o1; o1 = tmp; //if one of the bodies has the player tag, make sure it's the first one
  }
  
  if(o1 instanceof String && ((String)o1).equals("Player") && o2 instanceof Potato){//if the other one has a potato attached to it
    ((Potato)o2).handlePlayerCollision();
  }
}
