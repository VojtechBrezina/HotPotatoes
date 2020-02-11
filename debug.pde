private boolean debug = false;

private void displayDebug(){
  if(!debug)
    return;
  
  textSize(20);
  textAlign(LEFT);
  fill(0, 150);
  text("FPS: " + int(frameRate), 10, 25);
  text("Particles: " + particles.size(), 10, 50);
  text("Potatoes: " + potatoes.size(), 10, 75);
}
