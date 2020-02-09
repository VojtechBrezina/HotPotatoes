//skills
//each skill has its own tab bc the shapes are big and there are the effects and all

private Skill[] skills;

private PShape stealSkillShape;

private void prepareSkills(){
  PShape child;
  
  //init
  prepareShockWave();
  
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
  
  
  //the rest
  skills = new Skill[]{
    shockWaveSkill,
    
    new Skill(700, stealSkillShape, new SkillListener(){
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
    })
  };
  
  resetSkills();
}

private void tickSkills(){
  for(Skill s : skills)
    s.tick();
}

private void resetSkills(){
  for(Skill s : skills)
    s.reset();
}

private void displaySkills(){
  int x = 0;
  for(int i = skills.length - 1; i >= 0; i--){
    skills[i].display(SCREEN_SIZE - (x + 1) * GUI_PADDING - ((x + 0.5)* POWERUPS_SIZE), GUI_LINE_HEIGHT * 3.5, POWERUPS_SIZE);
    x++;
  }
}

private void displaySkillEffects(){
  for(Skill s : skills)
    s.displayEffects();
}

private void checkForSkillCasts(){
  if(paused || gameOver)
    return;
  if(key - '1' > skills.length - 1 || key - '1' < 0)
    return;
  skills[key - '1'].cast();
}

private final class Skill{
  private int cooldownLeft;
  private final int cooldown;
  private SkillListener listener;
  private PShape shape;
  
  public Skill(int cd, PShape s, SkillListener l){
    cooldown = cd;
    listener = l;
    shape = s;
  }
  
  public void reset(){
    cooldownLeft = 0;
    listener.reset();
  }
  
  public void cast(){
    if(cooldownLeft == 0){
      listener.cast();
      cooldownLeft = cooldown;
    }
  }
  
  public void tick(){
    cooldownLeft = max(0, cooldownLeft - 1);
    listener.tick();
  }
  
  public void display(float x, float y, float s){
    pushMatrix();
    translate(x, y);
    scale(s);
    pushStyle();
    strokeWeight(0.02);
    clip(-0.5, -0.5, 1, 1);
    noStroke();
    fill(SKILL_FILL_COLOR);
    square(-0.5, -0.5, 1);
    shape(shape);
    noFill();
    stroke(SKILL_STROKE_COLOR);//some skills are drawing on top of the border...
    square(-0.5, -0.5, 1);
    fill(BACKGROUND_COLOR, 200);
    noStroke();
    arc(0, 0, SQRT_2, SQRT_2, 0, TWO_PI * (float(cooldownLeft) / cooldown));
    noClip();
    popStyle();
    popMatrix();
  }
  
  public void displayEffects(){
    listener.displayEffects();
  }
}

private interface SkillListener{//let's do it the "proper" way
  public void cast();
  public void tick();
  public void displayEffects();
  public void reset();
}
