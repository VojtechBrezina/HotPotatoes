import shiffman.box2d.*;

import org.jbox2d.collision.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

import java.util.LinkedList;
import java.util.ListIterator;

import java.util.HashSet;

//sqrt() is expensive...
private static final float SQRT_2 = sqrt(2);

private static int SCREEN_SIZE; //The size of the gameScreen

private static final int TICK_DELAY = 25; //40tps
private int lastTick;

public void settings(){
  loadData();
  size(SCREEN_SIZE, SCREEN_SIZE + GUI_HEIGHT);
}

public void setup(){
  surface.setTitle("Hot Potatoes - ESC to close");
  surface.setupExternalMessages();
  
  initPhysics();
  prepareParticles();
  preparePowerups();
  prepareSkills();
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

public void exitActual(){
  saveData();
  super.exitActual();
}

//this callback stuff will be heavy on the performance ;(
//we may need to decrease the tick speed and make everything rough again

//called whenever some two things collide in the game (an event just like mousePressed, that is called automaticaly)
public void beginContact(Contact cp){
  //get the data
  Object o1 = cp.getFixtureA().getBody().getUserData();
  Object o2 = cp.getFixtureB().getBody().getUserData();
  
  if(o1 instanceof Potato){
    Object tmp = o2; o2 = o1; o1 = tmp; //if there there is a potato it is needed at the second place...
  }
  
  if(o2 instanceof Potato && o1 instanceof BodyTag){//...so if the second object is a potato we begin the tests (but only with things, that are of any interest to us
    Potato potato = (Potato)o2;
    switch((BodyTag)o1){
      case PLAYER:
        potato.handlePlayerCollision();
        break;
      case SHOCK_WAVE:
        if(!potato.hitByShockWave)
          potato.dealRelativeDamage(0.5);
        break;
    }
  }
}

public void preSolve(Contact cp, Manifold m){
  //get the data
  Object o1 = cp.getFixtureA().getBody().getUserData();
  Object o2 = cp.getFixtureB().getBody().getUserData();
  
  if(o1 instanceof Potato){
    Object tmp = o2; o2 = o1; o1 = tmp; //if there there is a potato it is needed at the second place...
  }
  
  if(o2 instanceof Potato && o1 instanceof BodyTag){//...so if the second object is a potato we begin the tests (but only with things, that are of any interest to us
    Potato potato = (Potato)o2;
    switch((BodyTag)o1){
      case PLAYER:
        //nothing
        break;
      case SHOCK_WAVE:
        cp.setEnabled(!potato.hitByShockWave);
        potato.hitByShockWave = true;
        break;
    }
  }
}
