//the general game logic

private static final int POTATO_BREAK_SCORE = 3;
private static final int START_POTATO_SPAWN_DELAY = 400;//10 seconds
private static final int POTATO_SPAWN_DELAY_AT_1000_SCORE = 0;//:) 20 potatoes per second...
private int potatoSpawnDelay(){return int(map(score, 0, 1000, START_POTATO_SPAWN_DELAY, POTATO_SPAWN_DELAY_AT_1000_SCORE));}
private static final int STARTING_POTATOES = 1;

private int score;
private int highScore;

private ArrayList<Potato> potatoes = new ArrayList<Potato>();
private int potatoSpawnTimer;

private boolean paused = false;
private boolean gameOver;

//amount of spikes powerups
private int spikesLevel;

//reset everything so it's ready for a new game
private void newGame(){
  gameOver = false;
  score = 0;
  
  playerLives = START_PLAYER_LIVES;//adjustable in the player tab

  for(int i = 0; i < STARTING_POTATOES; i++)
    potatoes.add(new Potato());
  
  potatoSpawnTimer = potatoSpawnDelay();
  
  spikesLevel = 0;
  box2d.setGravity(0, DEFAULT_GRAVITY);
  
  makePlayerBody(PLAYER_WIDTH);//in the player tab
  
  resetSkills();
  
  lastTick = millis();
}

//one tick of the game
private void gameTick(){
  if(paused)//just keep it inside
    return;
  
  for(Particle p : particles)
    p.tick();
  for(int i = particles.size() - 1; i >= 0; i--)
    if(particles.get(i).dead())
      particles.remove(i);
  if(gameOver)//on the gameOver screen, only particles are alive
    return;
  
  tickSkills();
  handlePlayer();
  box2d.step();
  
  for(int i = potatoes.size() - 1; i >= 0; i--){
    Potato p = potatoes.get(i);
    if(p.dead()){
      p.destroy(true);
      potatoes.remove(i);
    }else if(p.outOfScreen()){
      playerLives -= p.lives();
      p.destroy(false);
      potatoes.remove(i);
    }
  }
  
  for(Powerup p : playerPowerups)
    p.tick();
  
  for(int i = playerPowerups.size() - 1; i >= 0; i--){
    Powerup p = playerPowerups.get(i);
    if(p.dead()){
      playerPowerups.remove(i);
    }
  }
      
                              // it'boring otherwise
  if(potatoSpawnTimer == 0 || potatoes.size() == 0){
    potatoSpawnTimer = potatoSpawnDelay();
    potatoes.add(new Potato());
  }else
    potatoSpawnTimer--;
    
  highScore = max(highScore, score);
  
  if(playerLives <= 0)
   gameOver();
}

private void gameOver(){
  playerLives = 0;
  saveStrings("data.txt", new String[]{String.valueOf(highScore)});
  
  if(playerWidth == PLAYER_INCREASED_WIDTH)
    destroyPlayerExtension();
  for(int i = 0; i < 60; i++)
    particles.add(new PlayerParticle());
    
  for(Potato p : potatoes)
    p.destroy(false);//never just .clear() a list full of box2d bodies, that could get very messy
  potatoes.clear();
  
  playerPowerups.clear();
  
  gameOver = true;
}
