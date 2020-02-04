//things for drawing
private static final color PLAYER_COLOR = #7BDE98;

//render one frame of the game
private void renderFrame(){
  background(255);
  
  //the game is rendered under the gui and we'd like to have the coordinates adjusted
  pushMatrix();
  translate(0, GUI_HEIGHT);
  displayPlayer();
  for(Potato p : potatoes)
    p.display();
  popMatrix();
  
  displayGUI();
}

//score and things like that
private void displayGUI(){
  stroke(0);
  line(0, GUI_HEIGHT, SCREEN_SIZE, GUI_HEIGHT);
  fill(0);
  textSize(40);
  textAlign(LEFT);
  text("Score:", 10, 40);
  text("Lives: ", SCREEN_SIZE / 2 + 5, 40);
  textAlign(RIGHT);
  text(score, SCREEN_SIZE / 2 - 5, 40);
  text(playerLives, SCREEN_SIZE - 10, 40);
}

//display the player
private void displayPlayer(){
  pushStyle();//the rectMode won't necesarilly be used for other things and it might get everything messy
  noStroke();
  fill(PLAYER_COLOR);
  rectMode(CENTER);
  rect(box2d.getBodyPixelCoord(playerBody).x, PLAYER_Y, PLAYER_WIDTH, PLAYER_HEIGHT);
  popStyle();
}
