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
  
  definePotato();
  makeWalls();
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
  float wallSize = box2d.scalarPixelsToWorld(SCREEN_SIZE);
  wallShape.setAsBox(wallSize, wallSize);
  
  FixtureDef wallFixture = new FixtureDef();
  wallFixture.setShape(wallShape);
  wallFixture.setDensity(1);
  wallFixture.setFriction(0);
  wallFixture.setRestitution(1);
  
  BodyDef wallBodyDef = new BodyDef();
  wallBodyDef.type = BodyType.STATIC;
  
  wallBodyDef.position.set(box2d.coordPixelsToWorld(SCREEN_SIZE * -1, SCREEN_SIZE * 0.5));
  leftWall = box2d.createBody(wallBodyDef);
  leftWall.createFixture(wallFixture);
  
  wallBodyDef.position.set(box2d.coordPixelsToWorld(SCREEN_SIZE * 2, SCREEN_SIZE * 0.5));
  rightWall = box2d.createBody(wallBodyDef);
  rightWall.createFixture(wallFixture);
  
  wallBodyDef.position.set(box2d.coordPixelsToWorld(SCREEN_SIZE * 0.5, SCREEN_SIZE * -1));
  topWall = box2d.createBody(wallBodyDef);
  topWall.createFixture(wallFixture);
}
  
