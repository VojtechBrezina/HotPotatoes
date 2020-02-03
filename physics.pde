//box2d stuff

private Box2DProcessing box2d;

private CircleShape potatoShape;
private FixtureDef potatoFixture;
private BodyDef potatoBodyDef;

//do everything needed to init the physics library
private void initPhysics(){
  //get the world ready
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  
  //define the potato for reusing
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

private void makeWalls(){
  
}
  
