//gui things
                  //-vvv- needs to be int, because it's used int size()  
private static int GUI_LINE_HEIGHT;
private static int GUI_LINE_COUNT = 4;
private static int GUI_HEIGHT;  //Space required for score and other things
private static float GUI_PADDING;

//pause button def
private static float PAUSE_BUTTON_X;
private static float PAUSE_BUTTON_Y;
private static float PAUSE_BUTTON_SIZE;
private boolean pauseButtonHovered = false;

//powerups stuff
private static float POWERUPS_SIZE;
private static float POWERUPS_X;//the're drawn rtl
private static float POWERUPS_Y;

//score and things like that
private void displayGUI(){
  stroke(GUI_COLOR);
  for(int i = 1; i <= GUI_LINE_COUNT; i++)
    line(0, GUI_LINE_HEIGHT * i, SCREEN_SIZE, GUI_LINE_HEIGHT * i);
  line(SCREEN_SIZE / 2, 0, SCREEN_SIZE / 2, GUI_LINE_HEIGHT * 2);
  fill(GUI_COLOR);
  textSize(GUI_LINE_HEIGHT - GUI_PADDING);
  textAlign(LEFT);
  text("Score:", GUI_PADDING, GUI_LINE_HEIGHT - GUI_PADDING);
  text("High:", GUI_PADDING, GUI_LINE_HEIGHT * 2 - GUI_PADDING);
  text("Lives: ", SCREEN_SIZE / 2 + GUI_PADDING, GUI_LINE_HEIGHT * 2 - GUI_PADDING);
  text("Powerups:", GUI_PADDING, GUI_LINE_HEIGHT * 3 - GUI_PADDING);
  text("Skills:", GUI_PADDING, GUI_LINE_HEIGHT * 4 - GUI_PADDING);
  
  textAlign(RIGHT);
  text(score, SCREEN_SIZE / 2 - GUI_PADDING, GUI_LINE_HEIGHT - GUI_PADDING);
  text(highScore, SCREEN_SIZE / 2 - GUI_PADDING, GUI_LINE_HEIGHT * 2 - GUI_PADDING);
  text(playerLives, SCREEN_SIZE - GUI_PADDING, GUI_LINE_HEIGHT * 2 - GUI_PADDING);
  
  //powerups
  for(int i = 0; i < playerPowerups.size(); i++){
    pushMatrix();
    translate(POWERUPS_X - i * (POWERUPS_SIZE + GUI_PADDING), POWERUPS_Y);
    scale(POWERUPS_SIZE);
    playerPowerups.get(i).display();
    popMatrix();
  }
  
  //pause button
  pushMatrix();
  translate(PAUSE_BUTTON_X, PAUSE_BUTTON_Y);
  fill(pauseButtonHovered ? GUI_HOVER_COLOR : BACKGROUND_COLOR);
  square(0, 0, GUI_LINE_HEIGHT - GUI_PADDING * 2);
  scale(PAUSE_BUTTON_SIZE);
  noStroke();
  fill(GUI_COLOR);
  if(paused){
    triangle(0.2, 0.2, 0.8, 0.5, 0.2, 0.8);
  }else{
    rect(0.2, 0.2, 0.2, 0.6);
    rect(0.6, 0.2, 0.2, 0.6);
  }
  popMatrix();
  
  //skills
  displaySkills();
}

private boolean mouseInsidePauseButton(){
  return (mouseX > PAUSE_BUTTON_X && mouseX < PAUSE_BUTTON_X + PAUSE_BUTTON_SIZE && mouseY > PAUSE_BUTTON_Y && mouseY < PAUSE_BUTTON_Y + PAUSE_BUTTON_SIZE);
}

public void mouseMoved(){
  //pauseButton
  boolean pauseButtonNowHovered = mouseInsidePauseButton();
  if(pauseButtonNowHovered != pauseButtonHovered){
    pauseButtonHovered = pauseButtonNowHovered;
  }
}

public void mousePressed(){
  if(gameOver){//priority, over the rest of the gui
    newGame();
    return;
  }
  
  //pause button
  if(mouseInsidePauseButton()){
    paused = !paused;
    return;
  }
}

//!important The system will spam this event as long as you hold the key (as often as in the system settings for key repeating) and we want only the first press
private boolean pauseKeyPressed = false;
public void keyPressed(){
  switch(key){
    case 'p':
      if(!pauseKeyPressed){
        paused = !paused;
        pauseKeyPressed = true;
      }
      break;
    default:
      checkForSkillCasts();
      break;
  }
}

public void keyReleased(){
  switch(key){
    case 'p':
      pauseKeyPressed = false;
      break;
  }
}
