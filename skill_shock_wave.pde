private static float SHOCK_WAVE_RADIUS;
private static float SHOCK_WAVE_SPEED;

private PShape shockWaveSkillShape;

private float shockWaveX, shockWaveY;

private FixtureDef shockWaveFixture;
private BodyDef shockWaveBodyDef;
private Body shockWaveBody = null;
private boolean shockWaveOnScreen = false;

private Skill shockWaveSkill;

private void prepareShockWave(){
  //shape
  PShape child;
  shockWaveSkillShape = createShape(GROUP);
  child = createShape(ELLIPSE, 0, 0.5, 1.5, 1.5);
  child.setStrokeWeight(0.02);
  child.setStroke(SHOCK_WAVE_STROKE_COLOR);
  child.setFill(SHOCK_WAVE_FILL_COLOR);
  shockWaveSkillShape.addChild(child);
  child = createShape(ELLIPSE, 0, 0.5, 1.5, 1.2);
  child.setStrokeWeight(0.02);
  child.setStroke(SHOCK_WAVE_STROKE_COLOR);
  child.setFill(SKILL_FILL_COLOR);
  shockWaveSkillShape.addChild(child);
  
  //physics
  CircleShape cs = new CircleShape();
  cs.setRadius(box2d.scalarPixelsToWorld(SHOCK_WAVE_RADIUS));
  
  shockWaveFixture = new FixtureDef();
  shockWaveFixture.setShape(cs);
  shockWaveFixture.setFriction(0);
  
  shockWaveBodyDef = new BodyDef();
  shockWaveBodyDef.type = BodyType.KINEMATIC;
  
  //the listener and stuff
  shockWaveSkill = new Skill(800, shockWaveSkillShape, 
  new SkillListener(){
    public void cast(){
      shockWaveX = playerX;
      shockWaveY = PLAYER_Y + SHOCK_WAVE_RADIUS;
      shockWaveBodyDef.position.set(box2d.coordPixelsToWorld(shockWaveX, shockWaveY));
      shockWaveBody = box2d.createBody(shockWaveBodyDef);
      shockWaveBody.createFixture(shockWaveFixture);
      
      shockWaveBody.setUserData(BodyTag.SHOCK_WAVE);
      
      for(Potato p : potatoes)
        p.hitByShockWave = false;
      
      shockWaveOnScreen = true;
    }
    
    public void tick(){
      if(!shockWaveOnScreen)
        return;
        
      shockWaveY -= SHOCK_WAVE_SPEED;
      if(shockWaveY < SHOCK_WAVE_RADIUS / SQRT_2){
        box2d.destroyBody(shockWaveBody);
        shockWaveOnScreen = false;
      }else{
        shockWaveBody.setTransform(box2d.coordPixelsToWorld(shockWaveX, shockWaveY), 0);
      }
    }
    
    public void displayEffects(){
      if(!shockWaveOnScreen)
        return;
      
      pushStyle();
      noFill();
      strokeWeight(0.035 * SCREEN_SIZE);
      stroke(SHOCK_WAVE_STROKE_COLOR);
      circle(shockWaveX, shockWaveY, SHOCK_WAVE_RADIUS * 2);
      strokeWeight(0.0285 * SCREEN_SIZE);
      stroke(SHOCK_WAVE_FILL_COLOR);
      circle(shockWaveX, shockWaveY, SHOCK_WAVE_RADIUS * 2);
      popStyle();
    }
    
    public void reset(){
      shockWaveOnScreen = false;
    }
  }
);
}
