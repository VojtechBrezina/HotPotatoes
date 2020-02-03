//anything that works with the player

//player dimensoins are relative to the screen size
private static final float PLAYER_WIDTH = 0.2 * SCREEN_SIZE;
private static final float PLAYER_HEIGHT = 0.07 * SCREEN_SIZE;

//the y-position is also relative to screen size
private static final float PLAYER_Y = 0.9 * SCREEN_SIZE;

private Body playerBody;


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
}

//do one tick with the player
private void handlePlayer(){
  //player moves with the mouse, but leaves a small gap between himself and the edge
  float tx = max(PLAYER_WIDTH / 2 + 10, min(SCREEN_SIZE - PLAYER_WIDTH / 2 - 10, mouseX));//target x
  float x = box2d.getBodyPixelCoord(playerBody).x;//actual x
  
                                        //convert the difference            and multiplay by ticks per second...
  playerBody.setLinearVelocity(new Vec2(box2d.scalarPixelsToWorld(tx - x) * 1000.0 / TICK_DELAY, 0));
}
