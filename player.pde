//anything that works with the player

//player dimensoins are relative to the screen size
private static final float PLAYER_WIDTH = 0.3 * SCREEN_SIZE;
private static final float PLAYER_HEIGHT = 0.07 * SCREEN_SIZE;

//spike size for the visualisation
private static final float SPIKE_RADIUS = PLAYER_HEIGHT * 0.2;

//the y-position is also relative to screen size
private static final float PLAYER_Y = 0.9 * SCREEN_SIZE;

private static final int START_PLAYER_LIVES = 20;

private Body playerBody;

private int playerLives;


//prepare the physics of the player
private void makePlayerBody(){
  PolygonShape playerShape = new PolygonShape();
  float playerWidth = box2d.scalarPixelsToWorld(PLAYER_WIDTH / 2);
  float playerHeight = box2d.scalarPixelsToWorld(PLAYER_HEIGHT / 2);
  playerShape.setAsBox(playerWidth, playerHeight);
  
  FixtureDef playerFixture = new FixtureDef();
  playerFixture.setShape(playerShape);
  playerFixture.setFriction(0);
  
  BodyDef playerBodyDef = new BodyDef();
  playerBodyDef.type = BodyType.KINEMATIC;
  
  playerBodyDef.position.set(box2d.coordPixelsToWorld(SCREEN_SIZE * 0.5, PLAYER_Y));
  playerBody = box2d.createBody(playerBodyDef);
  playerBody.createFixture(playerFixture);
  
  playerBody.setUserData("Player");
}

//do one tick with the player
private void handlePlayer(){
  //player moves with the mouse, but leaves a small gap between himself and the edge
  float tx = max(PLAYER_WIDTH / 2 + 10, min(SCREEN_SIZE - PLAYER_WIDTH / 2 - 10, mouseX));//target x
  float x = box2d.getBodyPixelCoord(playerBody).x;//actual x
  
                                        //convert the difference            and multiplay by ticks per second...
  playerBody.setLinearVelocity(new Vec2(box2d.scalarPixelsToWorld(tx - x) * 1000.0 / TICK_DELAY * 2, 0));
}

//display the player
private void displayPlayer(){
  float playerX = box2d.getBodyPixelCoord(playerBody).x;
  
  pushStyle();//the rectMode won't necesarilly be used for other things and it might get everything messy
  stroke(#02C1A9);
  fill(PLAYER_COLOR);
  rectMode(CENTER);
  rect(playerX, PLAYER_Y, PLAYER_WIDTH, PLAYER_HEIGHT);
  popStyle();
  
  //draw the spikes
  {
    int spikeCount = spikesLevel * 5;//five spikes per level, to have it nice
    float spikeGap = PLAYER_WIDTH * 0.9 / spikeCount;
    stroke(#5A6781);
    fill(#7D9DC4);
    for(int i = 0; i < spikeCount; i++){
      pushMatrix();
      translate(playerX - PLAYER_WIDTH * 0.45 + spikeGap * (i + 0.5), PLAYER_Y - PLAYER_HEIGHT / 2);
      triangle(-SPIKE_RADIUS, 0, 0, -SPIKE_RADIUS * 3, SPIKE_RADIUS, 0);
      popMatrix();
    }
  }
}
