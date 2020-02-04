//gui things
// -pausebutton
private boolean pauseButtonHovered = false;

//score and things like that
private void displayGUI(){
  stroke(GUI_COLOR);
  line(0, GUI_HEIGHT, SCREEN_SIZE, GUI_HEIGHT);
  line(SCREEN_SIZE / 2, 0, SCREEN_SIZE / 2, GUI_HEIGHT);
  line(0, 50, SCREEN_SIZE, 50);
  fill(GUI_COLOR);
  textSize(40);
  textAlign(LEFT);
  text("Score:", 10, 40);
  text("High:", 10, 90);
  text("Lives: ", SCREEN_SIZE / 2 + 10, 40);
  textAlign(RIGHT);
  text(score, SCREEN_SIZE / 2 - 10, 40);
  text(highScore, SCREEN_SIZE / 2 - 10, 90);
  text(playerLives, SCREEN_SIZE - 10, 40);
  
  //pause button
  fill(pauseButtonHovered ? GUI_HOVER_COLOR : BACKGROUND_COLOR);
  pushMatrix();
  translate(SCREEN_SIZE - 45, 55);
  square(0, 0, 40);
  translate(0.5, 0);//it just looked wrong...
  noStroke();
  fill(GUI_COLOR);
  if(paused){
    triangle(5, 5, 35, 20, 5, 35);
  }else{
    rect(5, 5, 12, 30);
    rect(23, 5, 12, 30);
  }
  popMatrix();
}

private boolean mouseInsidePauseButton(){
  return (mouseX > SCREEN_SIZE - 45 && mouseX < SCREEN_SIZE - 5 && mouseY > 55 && mouseY < 95);
}

public void mouseMoved(){
  //pauseButton
  boolean pauseButtonNowHovered = mouseInsidePauseButton();
  if(pauseButtonNowHovered != pauseButtonHovered){
    pauseButtonHovered = pauseButtonNowHovered;
  }
}

public void mousePressed(){
  if(mouseInsidePauseButton()){
    paused = !paused;
    return;
  }
}
