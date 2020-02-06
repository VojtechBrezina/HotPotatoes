//particle stuff

private ArrayList<Particle> particles = new ArrayList<Particle>();


private PShape potatoParticleShape;
private void prepareParticles(){
  potatoParticleShape = createShape();
  potatoParticleShape.beginShape();
  potatoParticleShape.fill(POTATO_COLOR);
  potatoParticleShape.noStroke();
  potatoParticleShape.vertex(-POTATO_RADIUS * 0.5, POTATO_RADIUS * 0.4);
  potatoParticleShape.vertex(POTATO_RADIUS * 0.5, POTATO_RADIUS * 0.4);
  potatoParticleShape.vertex(0, POTATO_RADIUS * -0.5);
  potatoParticleShape.endShape(CLOSE);
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
  
  public void tick(){
    x += dx; y += dy; r += dr;
    dy += 0.5;
  }
  
  public boolean dead(){
    return y > SCREEN_SIZE + 100;
  }
  
  public void display(){
    pushMatrix();
    translate(x, y);
    rotate(r);
    shape(shape);
    popMatrix();
  }
}

private class PotatoParticle extends Particle{
  public PotatoParticle(float x, float y){
    super(x, y, random(TWO_PI), random(-5, 5), random(-5, 1), random(-0.01, 0.01), potatoParticleShape);
  }
}
