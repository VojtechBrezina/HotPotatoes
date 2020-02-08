//skills

private Skill[] skills;

private PShape shockWaveSkillShape;

private void prepareSkills(){
  PShape child;
  
  //shapes
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
  
  //the rest
  skills = new Skill[]{
    new Skill(800, shockWaveSkillShape, new SkillCaster(){
      public void cast(){
        for(Potato p : potatoes)
          p.dealRelativeDamage(0.5);
      }
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
  for(int i = skills.length - 1; i >= 0; i--){
    pushMatrix();
    translate(SCREEN_SIZE - GUI_PADDING - ((i + 0.5)* POWERUPS_SIZE), GUI_LINE_HEIGHT * 3.5);
    scale(POWERUPS_SIZE);
    skills[i].display();
    popMatrix();
  }
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
  private SkillCaster caster;
  private PShape shape;
  
  public Skill(int cd, PShape s, SkillCaster c){
    cooldown = cd;
    caster = c;
    shape = s;
  }
  
  public void reset(){
    cooldownLeft = 0;
  }
  
  public void cast(){
    if(cooldownLeft == 0){
      caster.cast();
      cooldownLeft = cooldown;
    }
  }
  
  public void tick(){
    cooldownLeft = max(0, cooldownLeft - 1);
  }
  
  public void display(){
    pushStyle();
    strokeWeight(0.02);
    clip(-0.5, -0.5, 1, 1);
    noStroke();
    fill(SKILL_FILL_COLOR);
    square(-0.5, -0.5, 1);
    shape(shape);
    fill(BACKGROUND_COLOR, 200);
    noStroke();
    arc(0, 0, SQRT_2, SQRT_2, 0, TWO_PI * (float(cooldownLeft) / cooldown));
    noFill();
    stroke(SKILL_STROKE_COLOR);//some skills are drawing on top of the border...
    square(-0.5, -0.5, 1);
    noClip();
    popStyle();
  }
}

private interface SkillCaster{//let's do it the "proper" way
  public void cast();
}
