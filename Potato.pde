//everything you need to know about potatoes :)

private static final float POTATO_RADIUS = 0.05 * SCREEN_SIZE;
private static final int POTATO_STARTING_LIVES = 5;
private static final int POTATO_STARTING_LIVES_AT_1000_SCORE = 20;
private static final int POTATO_STARTING_SPEED = 5;
private static final int POTATO_STARTING_SPEED_AT_1000_SCORE = 20;


private int potatoStartingLives(){
  return int(map(score, 0, 1000, POTATO_STARTING_LIVES, POTATO_STARTING_LIVES_AT_1000_SCORE));
}

private int potatoStartingSpeed(){
  return int(map(score, 0, 1000, POTATO_STARTING_SPEED, POTATO_STARTING_SPEED_AT_1000_SCORE));
}

private class Potato{
  //potato has position and speed
  private float x, y, dx, dy;
  
  //it also has lives remaining until it breaks
  private int lives;
  
  public Potato(){
    PVector speed = PVector.fromAngle(random(PI + QUARTER_PI, TWO_PI - QUARTER_PI)).mult(potatoStartingSpeed());//downwards
    lives = potatoStartingLives();
    x = random(POTATO_RADIUS, SCREEN_SIZE - POTATO_RADIUS);
    y = POTATO_RADIUS;
    dx = speed.x;
    dy = -speed.y;//angles in Processing don't seem to be done the usual way...
  }
  
  public void tick(){
    x += dx;
    y += dy;
    
    if(x < POTATO_RADIUS)
      dx = abs(dx);
    if(x > SCREEN_SIZE - POTATO_RADIUS)
      dx = -abs(dx);
    if(y < POTATO_RADIUS)
      dy = abs(dy);
    
    switch(playerCollision()){
      case TOP:
        dy = -abs(dy);
      case LEFT:
        dx = -abs(dx);
    }
  }
  
  public void display(){
    String l = String.valueOf(lives);
    float s = POTATO_RADIUS / l.length();
    noStroke();
    fill(255, 255, 0);
    circle(x, y, POTATO_RADIUS * 2);
    fill(255);
    circle(x, y, POTATO_RADIUS * 1.4);
    fill(0);
    textSize(s);
    textAlign(CENTER);
    text(l, x, y + s / 2 * 0.8);
  }
  
  //the side of collision
  private int playerCollision(){
    float dxl = x - playerLeft();//delta x for the left side
    float dxr = x - playerRight();//delta x for the right side
    float dyt = y - PLAYER_TOP;//delta y for the top
    
    // completely inside horisontaly                                         and below the top side            but not completely below
    if(x > playerLeft() + POTATO_RADIUS && x < playerRight() - POTATO_RADIUS && y > PLAYER_TOP - POTATO_RADIUS && y < PLAYER_BOTTOM + POTATO_RADIUS)
      return TOP;
    
    if(sqrt(dxl * dxl + dyt * dyt) <= POTATO_RADIUS){//top left corner is inside the potato
      return abs(dxl) > abs(dyt) ? LEFT : TOP;
    }else if(sqrt(dxr * dxr + dyt * dyt) <= POTATO_RADIUS){//top right corner is inside the potato
      return abs(dxr) > abs(dyt) ? RIGHT : TOP;
    }
    return -1;
  }
}
