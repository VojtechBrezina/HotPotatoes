//everything you need to know about potatoes :)

private static final float POTATO_RADIUS = 0.05 * SCREEN_SIZE;
private static final int POTATO_STARTING_LIVES = 5;
private static final int POTATO_STARTING_LIVES_AT_1000_SCORE = 20;
private static final int POTATO_STARTING_SPEED = 50;
private static final int POTATO_STARTING_SPEED_AT_1000_SCORE = 100;

private int potatoStartingLives(){
  return int(map(score, 0, 1000, POTATO_STARTING_LIVES, POTATO_STARTING_LIVES_AT_1000_SCORE));
}

private int potatoStartingSpeed(){
  return int(map(score, 0, 1000, POTATO_STARTING_SPEED, POTATO_STARTING_SPEED_AT_1000_SCORE));
}

private class Potato{
  //the box2D body
  Body body;
  
  //lives remaining until it breaks
  private int lives;
  
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
    lives = potatoStartingLives();
  }

  public void display(){
    String l = String.valueOf(lives);
    float s = POTATO_RADIUS / l.length();
    Vec2 pos = box2d.getBodyPixelCoord(body);
    noStroke();
    fill(255, 255, 0);
    circle(pos.x, pos.y, POTATO_RADIUS * 2);
    fill(255);
    circle(pos.x, pos.y, POTATO_RADIUS * 1.4);
    fill(0);
    textSize(s);
    textAlign(CENTER);
    text(l, pos.x, pos.y + s / 2 * 0.8);
  }
  
}
