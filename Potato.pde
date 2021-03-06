//everything you need to know about potatoes :)

private static float POTATO_RADIUS;
private static final int POTATO_STARTING_LIVES = 2;
private static final int POTATO_STARTING_LIVES_AT_1000_SCORE = 20;
private static float POTATO_STARTING_SPEED;
private static float POTATO_STARTING_SPEED_AT_1000_SCORE;
private static float POTATO_POWERUP_SCALE;

private FixtureDef potatoFixture;
private BodyDef potatoBodyDef;

private LinkedList<Potato> potatoes = new LinkedList<Potato>();
private int potatoSpawnTimer;


private void preparePotatoSpawner(){
  for(int i = 0; i < STARTING_POTATOES; i++)
    potatoes.add(new Potato());
  potatoSpawnTimer = potatoSpawnDelay();
}

//define the potato physics
private void definePotato(){
  CircleShape potatoShape = new CircleShape();
  potatoShape.setRadius(box2d.scalarPixelsToWorld(POTATO_RADIUS));
  
  potatoFixture = new FixtureDef();
  potatoFixture.setShape(potatoShape);
  potatoFixture.setDensity(1);
  potatoFixture.setFriction(0);
  potatoFixture.setRestitution(0.95);
  
  potatoBodyDef = new BodyDef();
  potatoBodyDef.type = BodyType.DYNAMIC;
}

private void tickPotatoes(){
  ListIterator<Potato> iterator = potatoes.listIterator(0);
  while(iterator.hasNext()){
    Potato p = iterator.next();
    if(p.dead()){
      p.destroy(true);
      iterator.remove();
    }else if(p.outOfScreen()){
      playerLives -= p.lives();
      p.destroy(false);
      iterator.remove();
    }
  }
                              // it'boring otherwise
  if(potatoSpawnTimer == 0 || potatoes.size() == 0){
    potatoSpawnTimer = potatoSpawnDelay();
    potatoes.add(new Potato());
  }else
    potatoSpawnTimer--;
}

private void displayPotatoes(){
  for(Potato p : potatoes)//hope this is good enough...
      p.display();
}

private void clearPotatoes(){
  for(Potato p : potatoes)
    p.destroy(false);//never just .clear() a list full of box2d bodies, that could get very messy
  potatoes.clear();
}

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
  
  public boolean hitByShockWave = false;//just there for the skill code, so it's public
  
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
    Vec2 pos = pos();
    stroke(POTATO_STROKE_COLOR);
    fill(POTATO_FILL_COLOR);//rendering tab
    circle(pos.x, pos.y, POTATO_RADIUS * 2);
    
    if(powerup != null){
      pushMatrix();
      translate(pos.x, pos.y);
      scale(POTATO_POWERUP_SCALE);
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
    Vec2 pos = pos();
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
  
  public Vec2 pos(){
    return box2d.getBodyPixelCoord(body);
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
