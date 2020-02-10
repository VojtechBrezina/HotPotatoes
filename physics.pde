//box2d stuff

private static float DEFAULT_GRAVITY;
private static float WEAK_GRAVITY;

private enum BodyTag{
  PLAYER, SHOCK_WAVE
}

private Box2DProcessing box2d;

private Body leftWall, rightWall, topWall;

//do everything needed to init the physics library
private void initPhysics(){
  //get the world ready (gravity is set in newGame(), bc it's now a part of the game state)
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();
  
  definePotato();
  makeWalls();
}

//prepare the invisible walls around the world
private void makeWalls(){
  PolygonShape wallShape = new PolygonShape();
  float wallSize = box2d.scalarPixelsToWorld(SCREEN_SIZE / 2);                                //--v--  not wotking though - might make it a feature...
  float bottomGap = box2d.scalarPixelsToWorld(SCREEN_SIZE - PLAYER_Y - PLAYER_HEIGHT / 2);//to make sure the player won't smash potatoes agaist the wall
  wallShape.setAsBox(wallSize, wallSize);
  
  FixtureDef wallFixture = new FixtureDef();
  wallFixture.setShape(wallShape);
  wallFixture.setFriction(0);
  
  BodyDef wallBodyDef = new BodyDef();
  wallBodyDef.type = BodyType.STATIC;
  
  wallBodyDef.position.set(box2d.coordPixelsToWorld(SCREEN_SIZE * -0.5, SCREEN_SIZE * 0.5 - bottomGap));
  leftWall = box2d.createBody(wallBodyDef);
  leftWall.createFixture(wallFixture);
  
  wallBodyDef.position.set(box2d.coordPixelsToWorld(SCREEN_SIZE * 1.5, SCREEN_SIZE * 0.5 - bottomGap));
  rightWall = box2d.createBody(wallBodyDef);
  rightWall.createFixture(wallFixture);
  
  wallBodyDef.position.set(box2d.coordPixelsToWorld(SCREEN_SIZE * 0.5, SCREEN_SIZE * -0.5));
  topWall = box2d.createBody(wallBodyDef);
  topWall.createFixture(wallFixture);
}
  
