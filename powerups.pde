//hopefuly we can fit all the powerups in this tab
//!important the activation has to be done before the fist tick, co the powerups
//           that should disappear instantly won't flash in the inventory

ArrayList<Powerup> playerPowerups = new ArrayList<Powerup>();

private Powerup generatePowerup(){
  float r = random(100);
  if(r <= 10)//10%
    return new HealthPowerup();
  
  if(r <= 20)//10% + 10%
    return new SpikesPowerup();
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
    fill(#45AEFC);
    stroke(#1E79BC);
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
    stroke(#A20000);
    fill(#FC4560);
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
    super(400);//10 seconds
  }
  
  public void display(){
    super.display();
    pushStyle();
    strokeWeight(0.05);
    stroke(#5A6781);
    fill(#7D9DC4);
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
