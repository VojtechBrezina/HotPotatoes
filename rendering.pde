//things for drawing
private static final color PLAYER_COLOR = #7BDE98;

//render one frame of the game
private void renderFrame(){
  background(255);
  displayGUI();
  translate(0, GUI_HEIGHT);//the game is rendered under the gui and we'd like to have the coordinates adjusted
  displayPlayer();
}

//score and things like that
private void displayGUI(){
  
}

//display the player
private void displayPlayer(){
  pushStyle();//the rectMode won't necesarilly be used for other things and it might get everything messy
  noStroke();
  fill(PLAYER_COLOR);
  rectMode(CENTER);
  rect(playerX, PLAYER_Y, PLAYER_WIDTH, PLAYER_HEIGHT);
  popStyle();
}
