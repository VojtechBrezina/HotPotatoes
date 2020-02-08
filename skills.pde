//skills

private Skill[] skills;

private void prepareSkills(){
  skills = new Skill[]{
    new Skill(){
      public int getMaximumCooldown(){// Shock Wave
        return 800; //20seconds
      }
      
      public void cast(){
        for(Potato p : potatoes)
          p.dealDamage(1);
      }
      
      public void display(){
        pushStyle();
        strokeWeight(0.02);
        clip(-0.5, -0.5, 1, 1);
        fill(#00CAFF);
        square(-0.5, -0.5, 1);
        stroke(#777777);
        fill(#FFFFFF);
        circle(0, 0.5, 1.5);
        fill(#00CAFF);
        circle(0, 0.5, 1.2);
        noClip();
        popStyle();
      }
    }
  };
  
  resetSkills();
}

private void tickSkills(){
  for(Skill s : skills)
    skillRemainingCooldown(s, max(skillRemainingCooldown(s) - 1, 0));
}

private void resetSkills(){
  for(Skill s : skills)
    skillRemainingCooldown(s, 0);
}

private void displaySkills(){
  for(int i = skills.length - 1; i >= 0; i--){
    pushMatrix();
    translate(SCREEN_SIZE - GUI_PADDING - ((i + 0.5)* POWERUPS_SIZE), GUI_LINE_HEIGHT * 3.5);
    scale(POWERUPS_SIZE);
    skills[i].display();
    fill(BACKGROUND_COLOR, 200);
    noStroke();
    clip(-0.5, -0.5, 1, 1);
    arc(0, 0, SQRT_2, SQRT_2, 0, TWO_PI * (float(skillRemainingCooldown(skills[i])) / skills[i].getMaximumCooldown()));
    noClip();
    popMatrix();
  }
}

private void checkForSkillCasts(){
  Skill s = skills[key - '1'];
  if(skillRemainingCooldown(s) == 0){
    skillRemainingCooldown(s, s.getMaximumCooldown());
    s.cast();
  }
}

//no need for instances
private interface Skill{
  public Map<Skill, Integer> remainingCooldown = new WeakHashMap<Skill, Integer>();
  
  public int getMaximumCooldown();
  public void cast();
  public void display();
}

//look away
private int skillRemainingCooldown(Skill s){return Skill.remainingCooldown.get(s);}
private void  skillRemainingCooldown(Skill s, int v){Skill.remainingCooldown.put(s, v);}
