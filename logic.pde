//the general game logic

private static final int POTATO_BREAK_SCORE = 10;
private static final int START_POTATO_SPAWN_DELAY = 400;//20 seconds
private static final int POTATO_SPAWN_DELAY_AT_1000_SCORE = 0;//:) 20 potatoes per second...
private int potatoSpawnDelay(){return int(map(score, 0, 1000, START_POTATO_SPAWN_DELAY, POTATO_SPAWN_DELAY_AT_1000_SCORE));}
private static final int STARTING_POTATOES = 3;

private int score;
private int highScore;

private ArrayList<Potato> potatoes = new ArrayList<Potato>();
private int potatoSpawnTimer;

private boolean paused = false;

//reset everything so it's ready for a new game
private void newGame(){
  score = 0;
  saveStrings("data.txt", new String[]{String.valueOf(highScore)});
  
  for(Potato p : potatoes)
    p.destroy(false);//never just .clear() a list full of box2d bodies, that could get very messy
  potatoes.clear();
  
  playerLives = START_PLAYER_LIVES;//adjustable in the player tab

  for(int i = 0; i < STARTING_POTATOES; i++)
    potatoes.add(new Potato());
  
  potatoSpawnTimer = potatoSpawnDelay();
  
  lastTick = millis();
}

//one tick of the game
private void gameTick(){
  if(paused)//just keep it inside
    return;
  
  handlePlayer();
  box2d.step();
  
  if(playerLives <= 0)
    newGame();
  
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
  
  if(potatoSpawnTimer == 0){
    potatoSpawnTimer = potatoSpawnDelay();
    potatoes.add(new Potato());
  }else
    potatoSpawnTimer--;
    
  highScore = max(highScore, score);
}
