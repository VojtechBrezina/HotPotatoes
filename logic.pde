//the general game logic

private static final int POTATO_BREAK_SCORE = 3;
private static final int START_POTATO_SPAWN_DELAY = 400;//10 seconds
private static final int POTATO_SPAWN_DELAY_AT_1000_SCORE = 0;//:) 20 potatoes per second...
private int potatoSpawnDelay(){return int(map(score, 0, 1000, START_POTATO_SPAWN_DELAY, POTATO_SPAWN_DELAY_AT_1000_SCORE));}
private static final int STARTING_POTATOES = 1;

private int score;
private int highScore;

private boolean paused = false;
private boolean gameOver;

//amount of spikes powerups
private int spikesLevel;

//reset everything so it's ready for a new game
private void newGame(){
  gameOver = false;
  
  score = 0;
  spikesLevel = 0;
  playerLives = START_PLAYER_LIVES;//adjustable in the player tab

  preparePotatoSpawner();
  box2d.setGravity(0, DEFAULT_GRAVITY);
  makePlayerBody(PLAYER_WIDTH);//in the player tab
  
  lastTick = millis();
}

//one tick of the game
private void gameTick(){
  if(paused)//just keep it inside
    return;
  
  tickParticles();
  
  if(gameOver)//on the gameOver screen, only particles are alive
    return;
  
  tickPlayer();
  tickSkills();
  box2d.step();
  tickPotatoes();
  tickPowerups();
    
  highScore = max(highScore, score);
  
  if(playerLives <= 0)
   gameOver();
}

private void gameOver(){
  playerLives = 0;
  
  destroyPlayerExtension();
  destroyPlayer();
    
  clearPotatoes();
  
  playerPowerups.clear();
  
  resetSkills();
  
  gameOver = true;
}
