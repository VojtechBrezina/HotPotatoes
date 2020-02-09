//things for drawing

//colors should be all in one place
private static final color PLAYER_FILL_COLOR = #739FFC;
private static final color PLAYER_STROKE_COLOR = #003BB7;
private static final color PLAYER_EXTENDED_FILL_COLOR = #73FC9D;
private static final color PLAYER_EXTENDED_STROKE_COLOR = #02B93A;

private static final color POTATO_FILL_COLOR = #BCB308;
private static final color POTATO_STROKE_COLOR = #8E8701;

private static final color POWERUP_FILL_COLOR = #45AEFC;
private static final color POWERUP_STROKE_COLOR = #1E79BC;

private static final color BONUS_HEALTH_FILL_COLOR = #FC4560;
private static final color BONUS_HEALTH_STROKE_COLOR = #A20000;

private static final color SPIKE_FILL_COLOR = #7D9DC4;
private static final color SPIKE_STROKE_COLOR = #5A6781;

private static final color GRAVITY_ARROW_FILL_COLOR = #28F779;
private static final color GRAVITY_ARROW_STROKE_COLOR = #03A241;

private static final color SKILL_FILL_COLOR = #65FF00;
private static final color SKILL_STROKE_COLOR = #4FBF06;

private static final color SHOCK_WAVE_FILL_COLOR = #FFFFFF;
private static final color SHOCK_WAVE_STROKE_COLOR = #AAAAAA;

private static final color STEAL_ICON_FILL_COLOR = #FFEB0D;
private static final color STEAL_ICON_STROKE_COLOR = #B2A61F;

private static final color BACKGROUND_COLOR = #D0DCF0;
private static final color GUI_COLOR = #0A0467;
private static final color GUI_HOVER_COLOR = #03CEFF;

//for animations (if any), that are independent on the game logic (might animate the pause button ant stuff)
private int lastFrame;
private int elapsedTime;


//render one frame of the game
private void renderFrame(){
  elapsedTime = millis() - lastFrame;
  lastFrame += elapsedTime;
  
  background(BACKGROUND_COLOR);
  
  //the game is rendered under the gui and we'd like to have the coordinates adjusted
  pushMatrix();
  translate(0, GUI_HEIGHT);
  displayPotatoes();
  if(gameOver){
    textAlign(CENTER);
    textSize(GUI_LINE_HEIGHT);//something
    fill(GUI_COLOR);
    text("Game Over (click)", SCREEN_SIZE / 2, SCREEN_SIZE / 2);
  }else{//no player or potatoes
    displayPlayer();
  }
  
  displayParticles();
  popMatrix();
  
  displayGUI();//gui tab (it was getting long)
}
