//anything that works with the player

//player dimensoins are relative to the screen size
private static final float PLAYER_WIDTH = 0.2 * SCREEN_SIZE;
private static final float PLAYER_HEIGHT = 0.07 * SCREEN_SIZE;

//the y-position is also relative to screen size
private static final float PLAYER_Y = 0.9 * SCREEN_SIZE;
private static final float PLAYER_TOP = PLAYER_Y - PLAYER_HEIGHT / 2;
private static final float PLAYER_BOTTOM = PLAYER_Y + PLAYER_HEIGHT / 2;

private float playerX;

//do one tick with the player
private void handlePlayer(){
  //player moves with the mouse, but leaves a small gap between himself and the edge
  playerX = max(PLAYER_WIDTH / 2 + 10, min(SCREEN_SIZE - PLAYER_WIDTH / 2 - 10, mouseX));
}

private float playerLeft(){
  return playerX - PLAYER_WIDTH / 2;
}
private float playerRight(){
  return playerX + PLAYER_WIDTH / 2;
}
