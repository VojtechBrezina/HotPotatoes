private static final String DATA_FILE = "data.txt";

private static final String DATA_KEY_SCREEN_SIZE = "ScreenSize";
private static final String DATA_KEY_HIGH_SCORE = "HighScore";
private static final String DATA_KEY_VERSION = "Version";

private static final int DATA_VERSION = 1;

private void loadData(){
  initDefaultData();
  
  try{
    JSONObject data = loadJSONObject(DATA_FILE);
    int version = data.getInt(DATA_KEY_VERSION);
    
    if(version >= 1){
      SCREEN_SIZE = data.getInt(DATA_KEY_SCREEN_SIZE);
      highScore = data.getInt(DATA_KEY_HIGH_SCORE);
    }
    
    
  }catch(Exception e){
  }
  
  calculateSizes();
}

private void saveData(){
  JSONObject data = new JSONObject();
  data.setInt(DATA_KEY_SCREEN_SIZE, SCREEN_SIZE);
  data.setInt(DATA_KEY_HIGH_SCORE, highScore);
  data.setInt(DATA_KEY_VERSION, DATA_VERSION);
  saveJSONObject(data, DATA_FILE);
}

private void initDefaultData(){
  SCREEN_SIZE = 700;
  highScore = 0;
}

private void calculateSizes(){
  POTATO_RADIUS = 0.05 * SCREEN_SIZE;
  POTATO_STARTING_SPEED = 0.043 * SCREEN_SIZE;
  POTATO_STARTING_SPEED_AT_1000_SCORE = 0.071 * SCREEN_SIZE;
  POTATO_POWERUP_SCALE = POTATO_RADIUS * cos(QUARTER_PI) * 2;
  
  GUI_LINE_HEIGHT = int(SCREEN_SIZE * 0.08);
  GUI_PADDING = GUI_LINE_HEIGHT * 0.15;
  GUI_HEIGHT = GUI_LINE_HEIGHT * GUI_LINE_COUNT;
  GUI_PADDING = GUI_LINE_HEIGHT * 0.15;
  
  PAUSE_BUTTON_X = SCREEN_SIZE - GUI_LINE_HEIGHT + GUI_PADDING;
  PAUSE_BUTTON_Y = GUI_PADDING;
  PAUSE_BUTTON_SIZE = GUI_LINE_HEIGHT - GUI_PADDING * 2;
  
  POWERUPS_SIZE = GUI_LINE_HEIGHT - GUI_PADDING * 2;
  POWERUPS_X = SCREEN_SIZE - POWERUPS_SIZE / 2 - GUI_PADDING;
  POWERUPS_Y = GUI_LINE_HEIGHT * 2.5;
  
  DEFAULT_GRAVITY = -4.0 / TICK_DELAY * SCREEN_SIZE;
  WEAK_GRAVITY = -0.7 / TICK_DELAY * SCREEN_SIZE;
  
  PLAYER_WIDTH = 0.3 * SCREEN_SIZE;
  PLAYER_INCREASED_WIDTH = 0.5 * SCREEN_SIZE;
  PLAYER_HEIGHT = 0.07 * SCREEN_SIZE;
  SPIKE_RADIUS = PLAYER_HEIGHT * 0.2;
  PLAYER_Y = 0.9 * SCREEN_SIZE;
  
  SHOCK_WAVE_RADIUS = SCREEN_SIZE;
  SHOCK_WAVE_SPEED = 0.07 * SCREEN_SIZE;
  
  STEAL_SPEED = 0.042 * SCREEN_SIZE;
}
