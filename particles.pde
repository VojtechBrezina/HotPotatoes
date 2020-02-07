//particle stuff

private ArrayList<Particle> particles = new ArrayList<Particle>();


private PShape potatoParticleShape, powerupParticleShape;
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
}


private abstract class Particle{
  private float x, y, r;
  private float dx, dy, dr;
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
