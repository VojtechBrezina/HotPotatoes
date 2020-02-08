//hopefuly we can fit all the powerups in this tab
//!important the activation has to be done before the fist tick, co the powerups
//           that should disappear instantly won't flash in the inventory

//sqrt() is expensive...
private static final float SQRT_2 = sqrt(2);

ArrayList<Powerup> playerPowerups = new ArrayList<Powerup>();

private PShape healthPowerupShape, spikesPowerupShape, weakGravityPowerupShape, increaseWidthPowerupShape;
private void preparePowerups(){
  PShape child;//will be useful to compose complex things
  
  healthPowerupShape = createShape();
  healthPowerupShape.beginShape();
  healthPowerupShape.stroke(BONUS_HEALTH_STROKE_COLOR);
  healthPowerupShape.fill(BONUS_HEALTH_FILL_COLOR);
  healthPowerupShape.strokeWeight(0.05);
  healthPowerupShape.vertex(-0.125, -0.375);healthPowerupShape.vertex(0.125, -0.375);healthPowerupShape.vertex(0.125, -0.125);healthPowerupShape.vertex(0.375, -0.125);
  healthPowerupShape.vertex(0.375, 0.125);healthPowerupShape.vertex(0.125, 0.125);healthPowerupShape.vertex(0.125, 0.375);healthPowerupShape.vertex(-0.125, 0.375);
  healthPowerupShape.vertex(-0.125, 0.125);healthPowerupShape.vertex(-0.375, 0.125);healthPowerupShape.vertex(-0.375, -0.125);healthPowerupShape.vertex(-0.125, -0.125);
  healthPowerupShape.endShape(CLOSE);
  
  spikesPowerupShape = createShape(TRIANGLE, -0.3, 0.3, 0, -0.3, 0.3, 0.3);
  spikesPowerupShape.setStrokeWeight(0.05);
  spikesPowerupShape.setStroke(SPIKE_STROKE_COLOR);
  spikesPowerupShape.setFill(SPIKE_FILL_COLOR);
  
  weakGravityPowerupShape = createShape(GROUP);
  child = createShape(RECT, -0.05, -0.2, 0.1, 0.2);
  child.setStrokeWeight(0.02);
  child.setStroke(GRAVITY_ARROW_STROKE_COLOR);
  child.setFill(GRAVITY_ARROW_FILL_COLOR);
  weakGravityPowerupShape.addChild(child);
  child = createShape();
  child.beginShape();
  child.strokeWeight(0.02);
  child.stroke(GRAVITY_ARROW_STROKE_COLOR);
  child.fill(GRAVITY_ARROW_FILL_COLOR);                                  //I am going mad from those shapes//
  child.vertex(-0.2, 0.15);child.vertex(-0.15, 0.1);child.vertex(-0.05, 0.15);child.vertex(-0.05, 0.1);child.vertex(0.05, 0.1);child.vertex(0.05, 0.15);child.vertex(0.15, 0.1);
  child.vertex(0.2, 0.15);child.vertex(0, 0.3);
  child.endShape(CLOSE);
  weakGravityPowerupShape.addChild(child);
  
  increaseWidthPowerupShape = createShape(GROUP);
  child = createShape(RECT, -0.3, 0.1, 0.6, 0.2);
  child.setStrokeWeight(0.05);
  child.setStroke(PLAYER_EXTENDED_STROKE_COLOR);
  child.setFill(PLAYER_EXTENDED_FILL_COLOR);
  increaseWidthPowerupShape.addChild(child);
  child = createShape(RECT, -0.15, 0.1, 0.3, 0.2);
  child.setStrokeWeight(0.05);
  child.setStroke(PLAYER_STROKE_COLOR);
  child.setFill(PLAYER_FILL_COLOR);
  increaseWidthPowerupShape.addChild(child);
}

private Powerup generatePowerup(){
  float r = random(100);
  if(r <= 10)//10%
    return new HealthPowerup();
  
  if(r <= 20)//10% + ^10%^
    return new SpikesPowerup();
    
  if(r <= 30)//10% + ^20%^
    return new WeakGravityPowerup();
    
  if(r <= 40)//10% + ^30%^
    return new IncreaseWidthPowerup();
  
  return null;
}

private void addPowerupToPlayer(Powerup p){
  for(Powerup pp : playerPowerups){
    if(pp.add(p))//succesfuly merged with some other one
      return;
  }
  //if not, we have to add it
  playerPowerups.add(p);
  p.activate();
}

//define a powerup
private abstract class Powerup{
  private int maxTime;
  private int remainingTime;//some powerups have a timer
  private boolean active = false;
  public boolean dead(){return remainingTime <= 0;}
  
  private PShape shape;
  public final color primaryColor;
  
  protected Powerup(int time, PShape shape, color c){
    maxTime = remainingTime = time;
    this.shape = shape;
    primaryColor = c;
  }
  
  //always use with super.activate(); or it won't end
  public void activate(){
    active = true;
  }
  
  public final void tick(){//not ready for overrides yet
    if(active){
      remainingTime--;
      if(dead()){
        active = false;
        deactivate();
      }
    }
  }
  
  //when a new powerup is added the game tries to group it with one of the same kind
  //if that is not desirable, just override this to whatever necessary
  public boolean add(Powerup p){
    if(p.getClass() == getClass()){
      remainingTime += p.remainingTime;
      maxTime += p.remainingTime;
      return true;
    }
    return false;
  }
  
  public final void display(){
    fill(POWERUP_FILL_COLOR);
    stroke(POWERUP_STROKE_COLOR);
    pushStyle();
    strokeWeight(0.05);
    square(-0.45, -0.45, 0.9);//this should make it look better on the potatoes
    shape(shape);
    fill(BACKGROUND_COLOR, 200);
    noStroke();
    clip(-0.5, -0.5, 1, 1);
    arc(0, 0, SQRT_2, SQRT_2, 0, TWO_PI * (1 - float(remainingTime) / maxTime));
    noClip();
    popStyle();
  }
  
  protected void deactivate(){}//not everything needs this one, but it'll be useful
}

//a simple powerup that adds one life and diappears
private final class HealthPowerup extends Powerup{
  public HealthPowerup(){
    super(0, healthPowerupShape, BONUS_HEALTH_FILL_COLOR);
  }
  
  public void activate(){
    super.activate();
    playerLives++;
  }
}

//spikes boost the damage dealt to potatoes
//they don't add up the time, but they are upgraded for even greater damage
private final class SpikesPowerup extends Powerup{
  public SpikesPowerup(){
    super(800, spikesPowerupShape, SPIKE_FILL_COLOR);//20 seconds
  }
  
  public void activate(){
    super.activate();
    spikesLevel++;
  }
  
  public void deactivate(){
    spikesLevel--;
  }
  
  public boolean add(Powerup p){
    return false;//doesn't add up
  }
}

private final class WeakGravityPowerup extends Powerup{
  public WeakGravityPowerup(){
    super(600, weakGravityPowerupShape, GRAVITY_ARROW_FILL_COLOR);//15 seconds
  }
  
  public void activate(){
    super.activate();
    box2d.setGravity(0, WEAK_GRAVITY);
  }
  
  public void deactivate(){
    box2d.setGravity(0, DEFAULT_GRAVITY);
  }
}

private class IncreaseWidthPowerup extends Powerup{
  public IncreaseWidthPowerup(){
    super(400, increaseWidthPowerupShape, PLAYER_EXTENDED_FILL_COLOR);//10seconds
  }
  
  public void activate(){
    super.activate();
    makePlayerBody(PLAYER_INCREASED_WIDTH);
  }
  
  public void deactivate(){
    makePlayerBody(PLAYER_WIDTH);
  }
}
