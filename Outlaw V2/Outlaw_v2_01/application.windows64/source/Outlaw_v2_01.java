import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Outlaw_v2_01 extends PApplet {


Canvas canvas;

int       botCount;
ArrayList movers;


public void setup() {
  
  //size(400, 400);
  canvas = new Canvas(640, 460);


  botCount = 250;
  movers = new ArrayList();
  for (int i = 0; i < botCount; i++) {
    movers.add(new Mover(new PVector(i*20, canvas.pgHeight/2 + sin(i)*15 ), 1, random(1, 5)));
  }
}


public void draw() {
  //canvas.pgBackground();
  canvas.transparentBackground(255);
  for (int i = movers.size()-1; i >= 0; i--) {
    Mover mover = (Mover) movers.get(i);
    mover.run(movers, canvas);
  }
  /*
  for (int i = Movers.size()-1; i >= 0; i--) {
    Mover mover = (Mover) Movers.get(i);
    mover.display();
  }
  */
  canvas.display();
  //collide();
  
  for (int i = movers.size()-1; i >= 0; i--) {
    Mover mover = (Mover) movers.get(i);
    for (int k = movers.size()-1; k >= 0; k--) {
      if(i != k){
        Mover other = (Mover) movers.get(k);
        mover.checkCollision(other);
      }
    }
  }
  
  
}




public void mousePressed() {
  for (int i = movers.size()-1; i >= 0; i--) {
    Mover mover = (Mover) movers.get(i);
    PVector direction = new PVector(random(-1, 1), random(-1, 1));
    direction.normalize();
    mover.acceleration = direction;
  }
}



public void collide(){
 for(int i = 0; i < movers.size(); i++){
    Mover zelleA = (Mover) movers.get(i);
    for(int k = 0; k < movers.size(); k++){
     if(i != k){
       Mover zelleB;
   
      zelleB = (Mover) movers.get(k); 
      
      if(zelleA.l.getX() + zelleA.radius + zelleB.radius > zelleB.l.getX() &&
         zelleA.l.getX() < zelleB.l.getX() + zelleA.radius + zelleB.radius &&
         zelleA.l.getY() + zelleA.radius + zelleB.radius > zelleB.l.getY() &&
         zelleA.l.getY() < zelleB.l.getY() + zelleA.radius + zelleB.radius){
           double distance = Math.sqrt(
                            ((zelleA.l.getX() - zelleB.l.getX()) * (zelleA.l.getX() - zelleB.l.getX()))
                          + ((zelleA.l.getY() - zelleB.l.getY()) * (zelleA.l.getY() - zelleB.l.getY())));
           if(distance < zelleA.radius + zelleB.radius){
             float newVelXA = (zelleA.v.getX() *(zelleA.mass - zelleB.mass) + ( 2 * zelleB.mass * zelleB.v.getX())) / (zelleA.mass + zelleB.mass);
             float newVelYA = (zelleA.v.getY() *(zelleA.mass - zelleB.mass) + ( 2 * zelleB.mass * zelleB.v.getY())) / (zelleA.mass + zelleB.mass);
             float newVelXB = (zelleB.v.getX() *(zelleB.mass - zelleA.mass) + ( 2 * zelleA.mass * zelleA.v.getX())) / (zelleB.mass + zelleA.mass);
             float newVelYB = (zelleB.v.getY() *(zelleB.mass - zelleA.mass) + ( 2 * zelleA.mass * zelleA.v.getY())) / (zelleB.mass + zelleA.mass);
             zelleA.v.setX(newVelXA);
             zelleA.v.setY(newVelYA);
             zelleB.v.setX(newVelXB);
             zelleB.v.setY(newVelYB);
             
             zelleA.l.setX(zelleA.l.getX() +newVelXA);
             zelleA.l.setY(zelleA.l.getY() +newVelYA);
             zelleB.l.setX(zelleB.l.getX() +newVelXB);
             zelleB.l.setY(zelleB.l.getY() +newVelYB);
            
             
           }
         }
     }
    }
  }
}


class Canvas{
  int pgWidth, pgHeight;
  int scaleWidth, scaleHeight;
  PVector cropOffset;
  
  PGraphics pg;
  
  Canvas(int _width, int _height){
    this.pgWidth  = _width;
    this.pgHeight = _height;
    
    pg = createGraphics(this.pgWidth, this.pgHeight, JAVA2D);
    
    // Calculate scaleWidth, scaleWidth and cropOffset
    cropScale();
  }
  
  public void display(){
    image(pg, cropOffset.x, cropOffset.y, scaleWidth, scaleHeight);
  }
  
  public void pgBackground(){
    pg.beginDraw();
    pg.background(0);
    pg.endDraw();
  }
  
  public void transparentBackground(float _transparency){
    pg.beginDraw();
    pg.noStroke();
    pg.fill(0, _transparency);
    pg.rect(0, 0, pgWidth, pgHeight);
    pg.endDraw();
  }
 
  public void cropScale() {
    float screenRatio = width/height;
    float pgRatio = pg.width/pg.height;
    if (pgRatio == screenRatio) {
      scaleWidth = width;
      scaleHeight = height;
    }
    cropOffset = new PVector(0,0);
    if (pgRatio > screenRatio) {  //// page is wider
      scaleHeight = height;
      scaleWidth = PApplet.parseInt(ceil(pg.width*height/pg.height));
      cropOffset = new PVector( -(scaleWidth-width)/2, 0 );
      //println("page wider: ", scaleWidth, scaleHeight, cropOffset.x, cropOffset.y);
    } else {
      scaleWidth = width;
      scaleHeight = PApplet.parseInt(ceil(height/pgRatio));
      cropOffset = new PVector( 0, -(scaleHeight-height)/2 );
      //println("page taller: ", scaleWidth, scaleHeight, cropOffset.x, cropOffset.y);
    }
  }
}
/*

  class Position
  
  - represents a 2D position
  
*/

class Position{
 PVector position;
 
 /*
   CONSTRUCTORS
 */
 
 Position(){
   position = new PVector(0, 0);
 }
 
 Position(float _x, float _y){
  position = new PVector(_x, _y); 
 }
 
 Position(PVector _position){
  position = new PVector(_position.x, _position.y);
 }
 
 // CONSTRUCTORS END
 
 /*
   SETTERS
 */
 public void set(float _x, float _y){
   position.x = _x;
   position.y = _y;
 }
 
 public void set(PVector _position){
   position.x = _position.x;
   position.y = _position.y;
 }
 
 public void setX(float _x){
   position.x = _x; 
 }
 
 public void setY(float _y){
   position.y = _y; 
 }
 
 // SETTERS END
 
 /*
   GETTERS
 */
 
 public PVector get (){ return position;   }
 public float   getX(){ return position.x; }
 public float   getY(){ return position.y; }
 
 // GETTERS END
 
 // OTHERS
 
 public void add(Velocity _v){ position.add(_v.get()); }
 public void add(PVector  _v){ position.add(_v); }
 
 public void sub(PVector _v) { position.sub(_v); }
 
 // OTHERS END
} // class Position END

/*

  class Position
  
  - represents a 2D position
  
*/

class Velocity{
 PVector velocity;
 
 /*
   CONSTRUCTORS
 */
 
 Velocity(){
   velocity = new PVector(0, 0);
 }
 
 Velocity(float _x, float _y){
  velocity = new PVector(_x, _y); 
 }
 
 Velocity(PVector _velocity){
  velocity = new PVector(_velocity.x, _velocity.y);
 }
 
 // CONSTRUCTORS END
 
 /*
   SETTERS
 */
 public void set(float _x, float _y){
   velocity.x = _x;
   velocity.y = _y;
 }
 
 public void set(PVector _velocity){
   velocity.x = _velocity.x;
   velocity.y = _velocity.y;
 }
 
 public void setX(float _x){
   velocity.x = _x; 
 }
 
 public void setY(float _y){
   velocity.y = _y; 
 }
 
 // SETTERS END
 
 /*
   GETTERS
 */
 
 public PVector get (){ return velocity;   }
 public float   getX(){ return velocity.x; }
 public float   getY(){ return velocity.y; }
 
 // GETTERS END
 
 // OTHERS
 
 public void add (PVector _v) { velocity.add (_v); }
 public void mult(float   _f) { velocity.mult(_f); }
 
 // OTHERS END
} // class Position END

class Mover{
  Position l;              // location
  Velocity v;              // velocity
  PVector acceleration;    // acceleration
  
  float friction = 0.025f;  // Friction 
  float mass     = 1;      // Mass of mover
  float radius   = 3.5f;      // Radius of mover
  
  float maxForce = 0.1f;   // Maximum steering force
  float maxSpeed = 5000;      // Maximum speed
  
  float neighbordist      = 100;
  float desiredSeperation = 0;
  
  Mover(){
    l     = new Position();
    v     = new Velocity();
    acceleration = new PVector();
  }
  
  Mover(PVector _l, float _m, float _r){
     l     = new Position(_l);
     v     = new Velocity();
     acceleration = new PVector(0, 0);
     mass         = _m;
     radius       = _r;
     desiredSeperation = _r*3;
     //maxSpeed = random(3, 10);
     maxForce = random(0.05f, 0.1f);
     mass = radius;
  }
  
  // FUNCTIONALITY
  public void run(ArrayList<Mover> _movers, Canvas _canvas){
    flock(_movers);
    update();
    borders(_canvas.pgWidth, _canvas.pgHeight);
    display(_canvas);
  }
  
  public void flock(ArrayList<Mover> _movers){
    PVector sep = seperate(_movers); // Seperation
    PVector ali = align   (_movers); // Alignment
    PVector coh = cohesion(_movers); // Cohesion
    
    // Arbitarily weight these forces
    sep.mult(1.5f);
    ali.mult(1.0f);
    coh.mult(1.0f);
    
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  
  /*
    // Newton's 2nd law: F = M * A
    // or A = F / M
  */
  public void applyForce(PVector _f){
     PVector f = PVector.div(_f, this.mass);
     this.acceleration.add(f);
  }
  
   // Wraparound
  public void borders(float _w, float _h) {
    if (l.getX() < -radius)      l.setX(_w+radius);
    if (l.getY() < -radius)      l.setY(_h+radius);
    if (l.getX() > _w+radius) l.setX(-radius);
    if (l.getY() > _h+radius) l.setY(-radius);
  }
  
  // A Method that calculates and applies a steering force towards a target
  // STEER = DESIRED - VELOCITY
  
  public PVector seek(PVector _target){
    PVector steer;
    PVector desired;
    
    desired = PVector.sub(_target, l.get());
    // scale to maximum speed
    desired.setMag(maxSpeed);
    
    steer = PVector.sub(desired, v.get());
    steer.limit(maxForce);
    return steer;
  }
  
  public void update(){
     // Velocity changes according to acceleration
     this.v.add(this.acceleration);
     // Apply the friction to the velocity
     this.v.mult(1-friction);
     // Position changes by velocity
     this.l.add(this.v);
     // Clear acceleration each frame
     acceleration.mult(0);
  }
  
  public void display(Canvas _canvas){
    _canvas.pg.beginDraw   ();
    _canvas.pg.noFill      ();
    //_canvas.pg.fill        (random(150, 255));
    _canvas.pg.stroke      (255);
    //_canvas.pg.noStroke();
    _canvas.pg.strokeWeight(1);
    _canvas.pg.smooth    ();
    _canvas.pg.ellipse     (l.getX(), l.getY(), radius*2, radius*2);
    _canvas.pg.endDraw     ();
  }
  
  public PVector seperate(ArrayList<Mover> _movers){
    PVector steer             = new PVector(0, 0, 0);
    int     count             = 0;
    
    // For every Mover in the System, check if it's to close
    for(Mover other: _movers){
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
  public PVector align(ArrayList<Mover> _movers){
    PVector steer = new PVector();
    PVector sum = new PVector(0, 0);
    int count = 0;
    for(Mover other : _movers){
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
  public PVector cohesion(ArrayList<Mover> _movers){
    PVector steer = new PVector(0, 0);
    PVector sum   = new PVector(0, 0);
    int count          = 0;
    for(Mover other: _movers){
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
  
  public void checkCollision(Mover _other){
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
 
  public void settings() {  fullScreen(P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Outlaw_v2_01" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
