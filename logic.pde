//the general game logic

//reset everything so it's ready for a new game
private void newGame(){
  playerX = SCREEN_SIZE / 2;
  
  lastTick = millis();
}

//one tick of the game
private void gameTick(){
  handlePlayer();
}
