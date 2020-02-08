//everything you need to know about potatoes :)

private static final float POTATO_RADIUS = 0.05 * SCREEN_SIZE;
private static final int POTATO_STARTING_LIVES = 2;
private static final int POTATO_STARTING_LIVES_AT_1000_SCORE = 20;
private static final int POTATO_STARTING_SPEED = 30;
private static final int POTATO_STARTING_SPEED_AT_1000_SCORE = 50;
private static final float POTATO_POWERUP_SCALE = POTATO_RADIUS * cos(QUARTER_PI) * 2;

private int potatoStartingLives(){
  return int(map(score, 0, 1000, POTATO_STARTING_LIVES, POTATO_STARTING_LIVES_AT_1000_SCORE));
}

private int potatoStartingSpeed(){
  return int(map(score, 0, 1000, POTATO_STARTING_SPEED, POTATO_STARTING_SPEED_AT_1000_SCORE));
}

private final class Potato{
  //the box2D body
  private Body body;
  
  //it might have a powerup on it
  private Powerup powerup;
  
  //lives remaining until it breaks
  private int lives; public int lives(){return lives;}//just to be clean about the acces
  private final int startLives;
  
  public Potato(){
    float angle = random(TWO_PI);
    Vec2 speed = new Vec2(cos(angle) * potatoStartingSpeed(), -sin(angle) * potatoStartingSpeed());
    lives = potatoStartingLives();
    potatoBodyDef.position.set(box2d.coordPixelsToWorld(
      random(POTATO_RADIUS, SCREEN_SIZE - POTATO_RADIUS), POTATO_RADIUS
    ));
    body = box2d.createBody(potatoBodyDef);
    body.createFixture(potatoFixture);
    body.setLinearVelocity(speed);
    body.setAngularVelocity(0);
    body.setLinearDamping(0);
    body.setAngularDamping(0);
    
    body.setUserData(this);//Hey, I'a Potato, and here is my motherobject
    
    lives = startLives = potatoStartingLives();
    
    powerup = generatePowerup();
  }

  public void display(){
    Vec2 pos = box2d.getBodyPixelCoord(body);
    stroke(POTATO_STROKE_COLOR);
    fill(POTATO_FILL_COLOR);//rendering tab
    circle(pos.x, pos.y, POTATO_RADIUS * 2);
    
    if(powerup != null){
      pushMatrix();
      translate(pos.x, pos.y);
      scale(POTATO_POWERUP_SCALE);//might make a constant for that...
      powerup.display();
      popMatrix();
    }
    
    stroke(POTATO_STROKE_COLOR);
    fill(BACKGROUND_COLOR);//rendering tab
    circle(pos.x, pos.y, sqrt(map(lives, startLives, 0, 0, PI * POTATO_RADIUS * POTATO_RADIUS)));
  }
  
  public void handlePlayerCollision(){
    dealDamage(min(lives, 1 + spikesLevel));
  }
  
  public void dealDamage(int damage){
    Vec2 pos = box2d.getBodyPixelCoord(body);
    pos.addLocal(random(-POTATO_RADIUS , POTATO_RADIUS), random(-POTATO_RADIUS , POTATO_RADIUS));
    for(int i = 0; i < 3 * damage; i++){//the more damage, the more particles :)
        if(powerup == null || random(1) < 0.5)
          particles.add(new PotatoParticle(pos.x, pos.y));
        else
          particles.add(new PowerupParticle(pos.x, pos.y));
    }
    lives -= damage;
    score += damage;
  }
  
  public void dealRelativeDamage(float fraction){
    dealDamage(max(1, int(startLives * fraction)));//at least 1
  }
  
  public Powerup grabPowerup(){//just for the steal skill rn
    Powerup p = powerup;
    powerup = null;
    return p;
  }
  
  public boolean dead(){
    return lives <= 0;
  }
  
  public boolean outOfScreen(){
    return box2d.getBodyPixelCoord(body).y > SCREEN_SIZE + POTATO_RADIUS;
  }
  
  //!make sure there are no ghost potatoes in the world!
  //if destroyed by player, add some score and activate the powerup
  public void destroy(boolean byPlayer){
    if(byPlayer){
      score += POTATO_BREAK_SCORE;//logic tab
      if(powerup != null)
        addPowerupToPlayer(powerup);
    }
    box2d.destroyBody(body);
  }
}
