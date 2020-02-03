//everything you need to know about potatoes :)

private static final float POTATO_RADIUS = 0.05 * SCREEN_SIZE;
private static final int POTATO_STARTING_LIVES = 5;
private static final int POTATO_STARTING_LIVES_AT_1000_SCORE = 20;

private int potatoStartingLives(){
  return int(map(score, 0, 1000, POTATO_STARTING_LIVES, POTATO_STARTING_LIVES_AT_1000_SCORE));
}

private class Potato{
  //potato has position and speed
  private float x, y, dx, dy;
  
  //it also has lives remaining until it breaks
  private int lives;
  
  public Potato(){
    lives = potatoStartingLives();
    x = random(POTATO_RADIUS, SCREEN_SIZE - POTATO_RADIUS);
    y = POTATO_RADIUS;
  }
  
  public void display(){
    noStroke();
    fill(255, 255, 0);
    circle(x, y, POTATO_RADIUS * 2);
  }
}
