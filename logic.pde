//the general game logic

private int score;

private ArrayList<Potato> potatoes = new ArrayList<Potato>();

//reset everything so it's ready for a new game
private void newGame(){
  playerX = SCREEN_SIZE / 2;
  score = 0;
  potatoes.clear();
  
  //for testing
  for(int i = 0; i < 2; i++)
    potatoes.add(new Potato());
  
  lastTick = millis();
}

//one tick of the game
private void gameTick(){
  handlePlayer();
  box2d.step();
}
