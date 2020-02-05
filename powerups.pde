//hopefuly we can fit all the powerups in this tab
//!important the activation has to be done before the fist tick, co the powerups
//           that should disappear instantly won't flash in the inventory

ArrayList<Powerup> playerPowerups = new ArrayList<Powerup>();

private Powerup generatePowerup(){
  float r = random(100);
  if(r <= 10)//10%
    return new HealthPowerup();
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
  
  protected abstract void display();
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
    fill(#FC4560);
    noStroke();
    beginShape();
    //just trust me, it's a plus shape and I don't need a milion lines in this file
    vertex(-5, -15);vertex(5, -15);vertex(5, -5);vertex(15, -5);vertex(15, 5);vertex(5, 5);vertex(5, 15);vertex(-5, 15);vertex(-5, 5);vertex(-15, 5);vertex(-15, -5);vertex(-5, -5);
    endShape(CLOSE);
  }
}
