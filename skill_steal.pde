private static float STEAL_SPEED;

private PShape stealSkillShape;

private Skill stealSkill;

private void prepareSteal(){
  PShape child;
  stealSkillShape = createShape(GROUP);
  child = createShape(RECT, -0.03, -0.43, 0.23, 0.13);
  child.setStrokeWeight(0.02);
  child.setStroke(STEAL_ICON_STROKE_COLOR);
  child.setFill(STEAL_ICON_FILL_COLOR);
  stealSkillShape.addChild(child);
  child = createShape(RECT, 0.03, 0.43, -0.23, -0.13);
  child.setStrokeWeight(0.02);
  child.setStroke(STEAL_ICON_STROKE_COLOR);
  child.setFill(STEAL_ICON_FILL_COLOR);
  stealSkillShape.addChild(child);
  child = createShape(ARC, 0, -0.18, 0.5, 0.5, HALF_PI, TWO_PI - HALF_PI);
  child.setStrokeWeight(0.02);
  child.setStroke(STEAL_ICON_STROKE_COLOR);
  child.setFill(STEAL_ICON_FILL_COLOR);
  stealSkillShape.addChild(child);
  child = createShape(ARC, 0, -0.18, 0.25, 0.25, HALF_PI, TWO_PI - HALF_PI);
  child.setStrokeWeight(0.02);
  child.setStroke(STEAL_ICON_STROKE_COLOR);
  child.setFill(SKILL_FILL_COLOR);
  stealSkillShape.addChild(child);
  child = createShape(ARC, 0, 0.18, 0.5, 0.5, - HALF_PI, HALF_PI);
  child.setStrokeWeight(0.02);
  child.setStroke(STEAL_ICON_STROKE_COLOR);
  child.setFill(STEAL_ICON_FILL_COLOR);
  stealSkillShape.addChild(child);
  child = createShape(ARC, 0, 0.18, 0.25, 0.25, - HALF_PI, HALF_PI);
  child.setStrokeWeight(0.02);
  child.setStroke(STEAL_ICON_STROKE_COLOR);
  child.setFill(SKILL_FILL_COLOR);
  stealSkillShape.addChild(child);
  stealSkillShape.scale(1, 0.6);
  child = createShape(RECT, -0.05, -0.6, 0.1, 1.2);
  child.setStrokeWeight(0.02);
  child.setStroke(STEAL_ICON_STROKE_COLOR);
  child.setFill(STEAL_ICON_FILL_COLOR);
  stealSkillShape.addChild(child);
  
  stealSkill = new Skill(700, stealSkillShape, new SkillListener(){
    public void cast(){
      for(Potato p : potatoes){
        Powerup pw = p.grabPowerup();
        if(pw != null)
          addPowerupToPlayer(pw);
      }
    }
    public void tick(){}
    public void displayEffects(){}
    public void reset(){}
  });
}

private class StealParticle extends Particle{
  private Powerup powerup;
  private boolean dead = false;
  
  public StealParticle(float x, float y, Powerup p) {
      super(x, y, 0, 0, 0, 0, null);
      powerup = p;
  }
  
  public boolean dead() {
    return dead;
  }
  
  public void tick() {
    
  }
}
