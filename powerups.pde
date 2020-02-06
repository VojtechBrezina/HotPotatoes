//hopefuly we can fit all the powerups in this tab
//!important the activation has to be done before the fist tick, co the powerups
//           that should disappear instantly won't flash in the inventory

ArrayList<Powerup> playerPowerups = new ArrayList<Powerup>();

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
  private int remainingTime;//some powerups have a timer
  private boolean active = false;
 public boolean dead(){return remainingTime <= 0;}
  
  protected Powerup(int time){
    remainingTime = time;
  }
  
  //always use with super.activate(); or it won't end
  public void activate(){
    active = true;
  }
  
  public void tick(){//not ready for overrides yet
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
      return true;
    }
    return false;
  }
  
  protected void display(){//would make it abstract, but let me just keep things simple
    fill(POWERUP_FILL_COLOR);
    stroke(POWERUP_STROKE_COLOR);
    pushStyle();
    strokeWeight(0.05);
    square(-0.45, -0.45, 0.9);//this should make it look better on the potatoes
    popStyle();
  }
  
  protected void deactivate(){}//not everything needs this one, but it'll be useful
}

//a simple powerup that adds one life and diappears
private class HealthPowerup extends Powerup{
  public HealthPowerup(){
    super(0);
  }
  
  public void activate(){
    super.activate();
    playerLives++;
  }
  
  public void display(){
    super.display();
    //too lazy to make a constant rn
    stroke(BONUS_HEALTH_STROKE_COLOR);
    fill(BONUS_HEALTH_FILL_COLOR);
    pushStyle();
    strokeWeight(0.05);
    beginShape();
    //just trust me, it's a plus shape and I don't need a milion lines in this file
    vertex(-0.125, -0.375);vertex(0.125, -0.375);vertex(0.125, -0.125);vertex(0.375, -0.125);vertex(0.375, 0.125);vertex(0.125, 0.125);vertex(0.125, 0.375);vertex(-0.125, 0.375);vertex(-0.125, 0.125);vertex(-0.375, 0.125);vertex(-0.375, -0.125);vertex(-0.125, -0.125);
    endShape(CLOSE);
    popStyle();
  }
}

//spikes boost the damage dealt to potatoes
//they don't add up the time, but they are upgraded for even greater damage
private class SpikesPowerup extends Powerup{
  public SpikesPowerup(){
    super(800);//20 seconds
  }
  
  public void display(){
    super.display();
    pushStyle();
    strokeWeight(0.05);
    stroke(SPIKE_STROKE_COLOR);
    fill(SPIKE_FILL_COLOR);
    triangle(-0.3, 0.3, 0, -0.3, 0.3, 0.3);
    popStyle();
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

private class WeakGravityPowerup extends Powerup{
  public WeakGravityPowerup(){
    super(600);//15 seconds
  }
  
  public void display(){
    super.display();
    pushStyle();
    strokeWeight(0.02);
    stroke(GRAVITY_ARROW_STROKE_COLOR);
    fill(GRAVITY_ARROW_FILL_COLOR);
    translate(0, -0.1);                             //I am going mad from those shapes//
    beginShape();vertex(-0.05, -0.1);vertex(0.05, -0.1);vertex(0.05, 0.1);vertex(-0.05, 0.1);endShape(CLOSE);
    beginShape();vertex(-0.2, 0.25);vertex(-0.15, 0.2);vertex(-0.05, 0.25);vertex(-0.05, 0.2);vertex(0.05, 0.2);vertex(0.05, 0.25);vertex(0.15, 0.2);vertex(0.2, 0.25);vertex(0, 0.4);endShape(CLOSE);
    popStyle();
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
    super(400);//10seconds
  }
  
  public void display(){
    super.display();
    pushStyle();
    strokeWeight(0.05);
    stroke(PLAYER_STROKE_COLOR);
    fill(PLAYER_FILL_COLOR);
    rect(-0.3, 0.1, 0.6, 0.2);
    stroke(PLAYER_EXTENDED_STROKE_COLOR);
    fill(PLAYER_EXTENDED_FILL_COLOR);
    rect(-0.15, 0.1, 0.3, 0.2);
    popStyle();
  }
  
  public void activate(){
    super.activate();
    makePlayerBody(PLAYER_INCREASED_WIDTH);
  }
  
  public void deactivate(){
    makePlayerBody(PLAYER_WIDTH);
  }
}
