/*
  SUPER AWESOME CONFIGURATION
  
  boids             = 250
  radius            = random(1, 5)
  maxForce          = 0.01
  maxSpeed          = 2
  mass              = 0.5
  neighbordist      = 5 / radius*4
  desiredSeperation = r*2
  friction          = 0.025
  
*/


/*

  Class Boid
  
  - represents a mover with swarm movement extensions

*/
final boolean NOCLIP = false;

class Boid extends Mover{
  float radius;      // Radius of mover
  
  float maxForce;    // Maximum steering force
  float maxSpeed;    // Maximum speed
  
  float neighbordist; //   
  float desiredSeperation = 0;
  
  Boid(){
    super();
    radius   = 1;
    maxForce = 0.01;
    maxSpeed = 2;
    
    neighbordist      = radius*4;
    desiredSeperation = radius*2;
  }
  
  Boid(PVector _l, float _m, float _r){
     super(_l, _m);
     radius   = _r;
     maxSpeed = 2;
     maxForce = 0.01;
     neighbordist      = _r*4;
     desiredSeperation = _r*2;
  }
  
  Boid(PVector _l, float _m, float _r, float _mf, float _ms, float _nd, float _ds){
    super(_l, _m);
    radius   = _r;
    maxForce = _mf;
    maxSpeed = _ms;
    neighbordist      = _nd;
    desiredSeperation = _ds;
  }
  
  // FUNCTIONALITY
  void run(ArrayList<Boid> _boids, Canvas _canvas){
    flock(_boids);
    update();
    borders(_canvas.pgWidth, _canvas.pgHeight);
    display(_canvas);
  }
  
  void flock(ArrayList<Boid> _boids){
    PVector sep = seperate(_boids); // Seperation
    PVector ali = align   (_boids); // Alignment
    PVector coh = cohesion(_boids); // Cohesion
    
    // Arbitarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  
   // Wraparound
  void borders(float _w, float _h) {
    if (l.getX() < -radius)      l.setX(_w+radius);
    if (l.getY() < -radius)      l.setY(_h+radius);
    if (l.getX() > _w+radius) l.setX(-radius);
    if (l.getY() > _h+radius) l.setY(-radius);
  }
  
  // A Method that calculates and applies a steering force towards a target
  // STEER = DESIRED - VELOCITY
  
  PVector seek(PVector _target){
    PVector steer;
    PVector desired;
    
    desired = PVector.sub(_target, l.get());
    // scale to maximum speed
    desired.setMag(maxSpeed);
    
    steer = PVector.sub(desired, v.get());
    steer.limit(maxForce);
    return steer;
  }
  
  void display(Canvas _canvas){
    _canvas.pg.beginDraw   ();
    _canvas.pg.noFill      ();
    _canvas.pg.fill        (255);
    _canvas.pg.stroke      (255);
    //_canvas.pg.noStroke();
    _canvas.pg.strokeWeight(1);
    _canvas.pg.smooth    ();
    _canvas.pg.ellipse     (l.getX(), l.getY(), radius*2, radius*2);
    _canvas.pg.endDraw     ();
  }
  
  PVector seperate(ArrayList<Boid> _boids){
    PVector steer             = new PVector(0, 0, 0);
    int     count             = 0;
    
    // For every Mover in the System, check if it's to close
    for(Boid other: _boids){
      float d = PVector.dist(l.get(), other.l.get());
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if(d > 0 && d < desiredSeperation){
        // calculate vector pointing away from neighbor
        PVector diff = PVector.sub(l.get(), other.l.get());
        diff.normalize();
        diff.div(d);      // Weight by distance
        steer.add(diff);
        count++;          // keep track of how many
      }
    }
    // Average -- divide by how many
    if(count > 0){
      steer.div((float) count);
    }
    
    // As long as the Vector is greater than 0
    if(steer.mag() > 0){
      steer.setMag(maxSpeed);
      steer.sub(v.get());
      steer.limit(maxForce);
    }
    
    return steer;
  }
  
  // Alignment
  // For every nearby Mover in the System, calculate the average velocity
  PVector align(ArrayList<Boid> _boids){
    PVector steer = new PVector();
    PVector sum = new PVector(0, 0);
    int count = 0;
    for(Boid other : _boids){
      float d = PVector.dist(l.get(), other.l.get());
      if((d > 0) && (d < neighbordist)){
        sum.add(other.v.get());
        count++;
      }
      if(count > 0){
        sum.div((float) count);
        sum.setMag(maxSpeed);
        // Implement Reynolds: Steering = Desired - Velocity
        steer = PVector.sub(sum, v.get());
        steer.limit(maxForce);
      }else{
        steer = new PVector(0, 0);
      }
    }
    return steer;
  }
  
  // Cohesion
  // For the average position (i.e. Center) of all nearby Movers, calculate steering vector towards that position
  PVector cohesion(ArrayList<Boid> _boids){
    PVector steer = new PVector(0, 0);
    PVector sum   = new PVector(0, 0);
    int count          = 0;
    for(Boid other: _boids){
      float d = PVector.dist(l.get(), other.l.get());
      if((d > 0) && (d < neighbordist)){
        sum.add(other.l.get());
        count++;
      }
    }
    if(count > 0){
      sum.div(count);
      steer = seek(sum);
    }
    return steer;
  }
  
  void checkCollision(Boid _other){
    // Get distances between the mover components
    PVector distanceVect = PVector.sub(_other.l.get(), l.get());
    
    // Calculate magnitude of the vector seperating the movers
    float distanceVectMag = distanceVect.mag();
    
    // Minimum distance before they are touching
    float minDistance = radius + _other.radius;
    
    if(distanceVectMag < minDistance){
      float distanceCorrection = (minDistance-distanceVectMag)/2.0f;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      _other.l.add(correctionVector);
      l.sub(correctionVector);
      
      // get angle of distanceVect
      float theta = distanceVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosi = cos(theta);
      
      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      PVector[] bTemp = {
        new PVector(), new PVector()
      };
      
      /* this ball's position is relative to the other
       so you can use the vector between them (bVect) as the 
       reference point in the rotation expressions.
       bTemp[0].position.x and bTemp[0].position.y will initialize
       automatically to 0.0, which is what you want
       since b[1] will rotate around b[0] */
       
      bTemp[1].x  = cosi * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosi * distanceVect.y - sine * distanceVect.x;
      
      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
      };

      vTemp[0].x  = cosi * v.getX() + sine * v.getY();
      vTemp[0].y  = cosi * v.getY() - sine * v.getX();
      vTemp[1].x  = cosi * _other.v.getX() + sine * _other.v.getY();
      vTemp[1].y  = cosi * _other.v.getY() - sine * _other.v.getX();

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      // final rotated velocity for b[0]
      vFinal[0].x = ((mass - _other.mass) * vTemp[0].x + 2 * _other.mass * vTemp[1].x) / (mass + _other.mass);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((_other.mass - mass) * vTemp[1].x + 2 * mass * vTemp[0].x) / (mass + _other.mass);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosi * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosi * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosi * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosi * bTemp[1].y + sine * bTemp[1].x;

      // I dont know... but this one is fucked up !
      // update balls to screen position
     // _other.l.setX(l.getX() + bFinal[1].x);
      //_other.l.setY(l.getX() + bFinal[1].y);

      l.add(bFinal[0]);

      // update velocities
      v.setX(cosi * vFinal[0].x - sine * vFinal[0].y);
      v.setY(cosi * vFinal[0].y + sine * vFinal[0].x);
      _other.v.setX(cosi * vFinal[1].x - sine * vFinal[1].y);
      _other.v.setY(cosi * vFinal[1].y + sine * vFinal[1].x);
    }
  }
      
    
}