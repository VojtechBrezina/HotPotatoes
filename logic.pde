//the general game logic

private static final int POTATO_BREAK_SCORE = 10;

private int score;

private ArrayList<Potato> potatoes = new ArrayList<Potato>();

//reset everything so it's ready for a new game
private void newGame(){
  score = 0;
  
  for(Potato p : potatoes)
    p.destroy(false);//never just .clear() a list full of box2d bodies, that could get very messy
  potatoes.clear();
  
  playerLives = START_PLAYER_LIVES;//adjustable in the player tab
  
  //for testing
  for(int i = 0; i < 2; i++)
    potatoes.add(new Potato());
  
  lastTick = millis();
}

//one tick of the game
private void gameTick(){
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
}
