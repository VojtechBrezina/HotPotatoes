import shiffman.box2d.*;

import org.jbox2d.collision.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

import java.util.Map;
import java.util.WeakHashMap;

//sqrt() is expensive...
private static final float SQRT_2 = sqrt(2);

private static int SCREEN_SIZE = 700; //The size of the gameScreen

private static final int TICK_DELAY = 25; //40tps
private int lastTick;

public void settings(){
  loadData();
  size(SCREEN_SIZE, SCREEN_SIZE + GUI_HEIGHT);
}

public void setup(){
  
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

private void loadData(){
  try{
    String[] data = loadStrings("data.txt");
    highScore = parseInt(data[0]);
    SCREEN_SIZE = parseInt(data[1]);
    
  }catch(Exception e){
    highScore = 0;
  }
  
  POTATO_RADIUS = 0.05 * SCREEN_SIZE;
  POTATO_STARTING_SPEED = 0.043 * SCREEN_SIZE;
  POTATO_STARTING_SPEED_AT_1000_SCORE = 0.071 * SCREEN_SIZE;
  POTATO_POWERUP_SCALE = POTATO_RADIUS * cos(QUARTER_PI) * 2;
  
  GUI_LINE_HEIGHT = int(SCREEN_SIZE * 0.08);
  GUI_PADDING = GUI_LINE_HEIGHT * 0.15;
  GUI_HEIGHT = GUI_LINE_HEIGHT * GUI_LINE_COUNT;
  GUI_PADDING = GUI_LINE_HEIGHT * 0.15;
  
  PAUSE_BUTTON_X = SCREEN_SIZE - GUI_LINE_HEIGHT + GUI_PADDING;
  PAUSE_BUTTON_Y = GUI_PADDING;
  PAUSE_BUTTON_SIZE = GUI_LINE_HEIGHT - GUI_PADDING * 2;
  
  POWERUPS_SIZE = GUI_LINE_HEIGHT - GUI_PADDING * 2;
  POWERUPS_X = SCREEN_SIZE - POWERUPS_SIZE / 2 - GUI_PADDING;
  POWERUPS_Y = GUI_LINE_HEIGHT * 2.5;
  
  DEFAULT_GRAVITY = -4.0 / TICK_DELAY * SCREEN_SIZE;
  WEAK_GRAVITY = -0.7 / TICK_DELAY * SCREEN_SIZE;
  
  PLAYER_WIDTH = 0.3 * SCREEN_SIZE;
  PLAYER_INCREASED_WIDTH = 0.5 * SCREEN_SIZE;
  PLAYER_HEIGHT = 0.07 * SCREEN_SIZE;
  SPIKE_RADIUS = PLAYER_HEIGHT * 0.2;
  PLAYER_Y = 0.9 * SCREEN_SIZE;
  
  SHOCK_WAVE_RADIUS = SCREEN_SIZE;
  SHOCK_WAVE_SPEED = 0.07 * SCREEN_SIZE;
  
  STEAL_SPEED = 0.042 * SCREEN_SIZE;
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
