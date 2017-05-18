


class Mover{
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  float friction = 0.025;
  float mass;
  float radius   = 5;
  
  Mover(){
    location     = new PVector();
    velocity     = new PVector();
    acceleration = new PVector();
    mass         = 0;
  }
  
  Mover(PVector _l, float _m){
     location     = _l;
     velocity     = new PVector(0, 0);
     acceleration = new PVector(0, 0);
     mass         = _m;
  }
  
  // FUNCTIONALITY
  
  /*
    // Newton's 2nd law: F = M * A
    // or A = F / M
  */
  void applyForce(PVector _f){
     PVector f = PVector.div(_f, this.mass);
     this.acceleration.add(f);
  }
  
  void update(){
     // Velocity changes according to acceleration
     this.velocity.add(this.acceleration);
     // Apply the friction to the velocity
     this.velocity.mult(1-friction);
     // Position changes by velocity
     this.location.add(this.velocity);
     // Clear acceleration each frame
     acceleration.mult(0);
  }
  
  void display(){
    canvas.pg.beginDraw();
    canvas.pg.noFill();
    canvas.pg.stroke(255);
    canvas.pg.strokeWeight(1);
    //canvas.pg.smooth();
    canvas.pg.ellipse(location.x, location.y, radius*2, radius*2);
    canvas.pg.endDraw();
  }
}