//anything that works with the player

//player dimensoins are relative to the screen size
private static final float PLAYER_WIDTH = 0.3 * SCREEN_SIZE;
private static final float PLAYER_INCREASED_WIDTH = 0.5 * SCREEN_SIZE;
private static final float PLAYER_HEIGHT = 0.07 * SCREEN_SIZE;
private float playerWidth;

//spike size for the visualisation
private static final float SPIKE_RADIUS = PLAYER_HEIGHT * 0.2;

//the y-position is also relative to screen size
private static final float PLAYER_Y = 0.9 * SCREEN_SIZE;

private static final int START_PLAYER_LIVES = 5;

private Body playerBody;

private int playerLives;


//prepare the physics of the player
private void makePlayerBody(float newWidth){
  float playerX = SCREEN_SIZE / 2;
  if(playerBody != null){
    box2d.destroyBody(playerBody);
    playerX = box2d.getBodyPixelCoord(playerBody).x;
  }
  
  playerWidth = newWidth;
  
  PolygonShape playerShape = new PolygonShape();
  float playerWidth = box2d.scalarPixelsToWorld(newWidth / 2);
  float playerHeight = box2d.scalarPixelsToWorld(PLAYER_HEIGHT / 2);
  playerShape.setAsBox(playerWidth, playerHeight);
  
  FixtureDef playerFixture = new FixtureDef();
  playerFixture.setShape(playerShape);
  playerFixture.setFriction(0);
  
  BodyDef playerBodyDef = new BodyDef();
  playerBodyDef.type = BodyType.KINEMATIC;
  
  playerBodyDef.position.set(box2d.coordPixelsToWorld(playerX, PLAYER_Y));
  playerBody = box2d.createBody(playerBodyDef);
  playerBody.createFixture(playerFixture);
  
  playerBody.setUserData("Player");
}

private void destroyPlayerExtension(){
  if(playerWidth == PLAYER_INCREASED_WIDTH){
    for(int i = 0; i < 50; i++)
      particles.add(new PlayerExtensionParticle());
    makePlayerBody(PLAYER_WIDTH);
  }
}

//not really, just the effects of it
private void destroyPlayer(){
  for(int i = 0; i < 60; i++)
    particles.add(new PlayerParticle());
}

//do one tick with the player
private void tickPlayer(){
  //player moves with the mouse, but leaves a small gap between himself and the edge
  float tx = max(playerWidth / 2 + 10, min(SCREEN_SIZE - playerWidth / 2 - 10, mouseX));//target x
  playerBody.setTransform(box2d.coordPixelsToWorld(tx, PLAYER_Y), 0);
}

//display the player
private void displayPlayer(){
  float playerX = box2d.getBodyPixelCoord(playerBody).x;
  
  pushStyle();//the rectMode won't necesarilly be used for other things and it might get everything messy
  rectMode(CENTER);
  stroke(PLAYER_EXTENDED_STROKE_COLOR);
  fill(PLAYER_EXTENDED_FILL_COLOR);
  rect(playerX, PLAYER_Y, playerWidth, PLAYER_HEIGHT);
  stroke(PLAYER_STROKE_COLOR);
  fill(PLAYER_FILL_COLOR);
  rect(playerX, PLAYER_Y, PLAYER_WIDTH, PLAYER_HEIGHT);
  popStyle();
  
  //draw the spikes
  {
    int spikeCount = spikesLevel * int(playerWidth / 4 / SPIKE_RADIUS);//five spikes per level, to have it nice
    float spikeGap = playerWidth * 0.9 / spikeCount;
    stroke(SPIKE_STROKE_COLOR);
    fill(SPIKE_FILL_COLOR);
    for(int i = 0; i < spikeCount; i++){
      pushMatrix();
      translate(playerX - playerWidth * 0.45 + spikeGap * (i + 0.5), PLAYER_Y - PLAYER_HEIGHT / 2);
      triangle(-SPIKE_RADIUS, 0, 0, -SPIKE_RADIUS * 3, SPIKE_RADIUS, 0);
      popMatrix();
    }
  }
}
