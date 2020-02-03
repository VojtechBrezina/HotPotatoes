//box2d stuff

private Box2DProcessing box2d;

private CircleShape potatoShape;
private FixtureDef potatoFixture;
private BodyDef potatoBodyDef;

private Body leftWall, rightWall, topWall;

//do everything needed to init the physics library
private void initPhysics(){
  //get the world ready
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  box2d.listenForCollisions();
  
  definePotato();
  makeWalls();
  makePlayerBody();//in the player tab
}

//define the potato for reusing
private void definePotato(){
  potatoShape = new CircleShape();
  potatoShape.setRadius(box2d.scalarPixelsToWorld(POTATO_RADIUS));
  
  potatoFixture = new FixtureDef();
  potatoFixture.setShape(potatoShape);
  potatoFixture.setDensity(1);
  potatoFixture.setFriction(0);
  potatoFixture.setRestitution(1);
  
  potatoBodyDef = new BodyDef();
  potatoBodyDef.type = BodyType.DYNAMIC;
}

//prepare the invisible walls around the world
private void makeWalls(){
  PolygonShape wallShape = new PolygonShape();
  float wallSize = box2d.scalarPixelsToWorld(SCREEN_SIZE / 2);                                //--v--  not wotking though - might make it afeature...
  float bottomGap = box2d.scalarPixelsToWorld(SCREEN_SIZE - PLAYER_Y - PLAYER_HEIGHT / 2) / 2;//to make sure the player won't smash potatoes agaist the wall
  wallShape.setAsBox(wallSize, wallSize - bottomGap);
  
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
  
  wallBodyDef.position.set(box2d.coordPixelsToWorld(SCREEN_SIZE * 0.5, SCREEN_SIZE * -0.5 + bottomGap * 2));
  topWall = box2d.createBody(wallBodyDef);
  topWall.createFixture(wallFixture);
}
  
