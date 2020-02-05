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

private class Potato{
  //the box2D body
  Body body;
  
  //it might have a powerup on it
  Powerup powerup;
  
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
    stroke(#8E8701);
    fill(POTATO_COLOR);//rendering tab
    circle(pos.x, pos.y, POTATO_RADIUS * 2);
    
    if(powerup != null){
      pushMatrix();
      translate(pos.x, pos.y);
      scale(POTATO_POWERUP_SCALE);//might make a constant for that...
      powerup.display();
      popMatrix();
    }
    
    stroke(#8E8701);
    fill(BACKGROUND_COLOR);//rendering tab
    circle(pos.x, pos.y, sqrt(map(lives, startLives, 0, 0, PI * POTATO_RADIUS * POTATO_RADIUS)));
  }
  
  public void handlePlayerCollision(){
    int damage = min(lives, 1 + spikesLevel);
    lives -= damage;
    score += damage;
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
