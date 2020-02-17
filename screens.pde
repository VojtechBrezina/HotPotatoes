Screen[] screens;

private void prepareScreens(){
  prepareSettingsScreen();
  
  screens = new Screen[]{
    settingsScreen
  };
}

private class Screen{
  private ScreenListener listener;
  private ArrayList<GUIElement> elements;
  public final String name;
  
  public Screen(String n, ScreenListener l){
    listener = l;
    name = n;
    
    l.prepare(this);
  }
  
  public void addElement(GUIElement e){
    elements.add(e);
  }
}

private interface ScreenListener{
  public void prepare(Screen s);
}
