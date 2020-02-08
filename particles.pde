//particle stuff

private ArrayList<Particle> particles = new ArrayList<Particle>();


private PShape potatoParticleShape, powerupParticleShape, playerExtensionParticleShape, playerParticleShape;
private void prepareParticles(){
  potatoParticleShape = createShape();
  potatoParticleShape.beginShape();
  potatoParticleShape.fill(POTATO_FILL_COLOR);
  potatoParticleShape.noStroke();
  potatoParticleShape.vertex(-POTATO_RADIUS * 0.5, POTATO_RADIUS * 0.4);
  potatoParticleShape.vertex(POTATO_RADIUS * 0.5, POTATO_RADIUS * 0.4);
  potatoParticleShape.vertex(0, POTATO_RADIUS * -0.5);
  potatoParticleShape.endShape(CLOSE);
  
  powerupParticleShape = createShape();
  powerupParticleShape.beginShape();
  powerupParticleShape.fill(POWERUP_FILL_COLOR);
  powerupParticleShape.noStroke();
  powerupParticleShape.vertex(-POTATO_RADIUS * 0.5, POTATO_RADIUS * 0.4);
  powerupParticleShape.vertex(POTATO_RADIUS * 0.5, POTATO_RADIUS * 0.4);
  powerupParticleShape.vertex(0, POTATO_RADIUS * -0.5);
  powerupParticleShape.endShape(CLOSE);
  
  playerExtensionParticleShape = createShape();
  playerExtensionParticleShape.beginShape();
  playerExtensionParticleShape.fill(PLAYER_EXTENDED_FILL_COLOR);
  playerExtensionParticleShape.noStroke();
  playerExtensionParticleShape.vertex(-PLAYER_HEIGHT * 0.3, PLAYER_HEIGHT * 0.2);
  playerExtensionParticleShape.vertex(PLAYER_HEIGHT * 0.3, PLAYER_HEIGHT * 0.2);
  playerExtensionParticleShape.vertex(0, PLAYER_HEIGHT * -0.3);
  playerExtensionParticleShape.endShape(CLOSE);
  
  playerParticleShape = createShape();
  playerParticleShape.beginShape();
  playerParticleShape.fill(PLAYER_FILL_COLOR);
  playerParticleShape.noStroke();
  playerParticleShape.vertex(-PLAYER_HEIGHT * 0.3, PLAYER_HEIGHT * 0.2);
  playerParticleShape.vertex(PLAYER_HEIGHT * 0.3, PLAYER_HEIGHT * 0.2);
  playerParticleShape.vertex(0, PLAYER_HEIGHT * -0.3);
  playerParticleShape.endShape(CLOSE);
}


private abstract class Particle{
  protected float x, y, r;
  protected float dx, dy, dr;
  private PShape shape;
  
  protected Particle(float x, float y, float r, float dx, float dy, float dr, PShape shape){
    this.x = x; this.y = y; this.r  = r;
    this.dx = dx; this.dy = dy; this.dr = dr;
    this.shape = shape;
  }
  
  public final void tick(){
    x += dx; y += dy; r += dr;
    dy += 0.5;
  }
  
  public final boolean dead(){
    return y > SCREEN_SIZE + 100;
  }
  
  public final void display(){
    pushMatrix();
    translate(x, y);
    rotate(r);
    shape(shape);
    popMatrix();
  }
}

private final class PotatoParticle extends Particle{
  public PotatoParticle(float x, float y){
    super(x, y, random(TWO_PI), random(-5, 5), random(-8, -2), random(-0.1, 0.1), potatoParticleShape);
  }
}

private final class PowerupParticle extends Particle{
  public PowerupParticle(float x, float y){
    super(x, y, random(TWO_PI), random(-5, 5), random(-8, -2), random(-0.1, 0.1), powerupParticleShape);
  }
}

private final class PlayerExtensionParticle extends Particle{
  public PlayerExtensionParticle(){
    // sory, but Java is like: "THE CONSTRUCTOR CALL MUST BE THE FIRST STATEMENT IN THE CONSTRUCTOR !!!"
    //... and I am too lazy to do it any other way...
    super(box2d.getBodyPixelCoord(playerBody).x + (random(2) < 1 ? -1 : 1) * random(PLAYER_WIDTH / 2, PLAYER_INCREASED_WIDTH / 2), PLAYER_Y + random(-PLAYER_HEIGHT / 2, PLAYER_HEIGHT / 2), 
      random(TWO_PI), random(-3, 3), random(2, -2), random(-0.8, 0), playerExtensionParticleShape);
  }
}

private final class PlayerParticle extends Particle{
  public PlayerParticle(){
    // sory, but Java is like: "THE CONSTRUCTOR CALL MUST BE THE FIRST STATEMENT IN THE CONSTRUCTOR !!!"
    //... and I am too lazy to do it any other way...
    super(box2d.getBodyPixelCoord(playerBody).x + random(0, PLAYER_WIDTH / 2), PLAYER_Y + random(-PLAYER_HEIGHT / 2, PLAYER_HEIGHT / 2), 
      random(TWO_PI), random(-3, 3), random(2, -2), random(-0.8, 0), playerExtensionParticleShape);
  }
}