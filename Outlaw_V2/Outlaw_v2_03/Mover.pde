/*

  class Position
  
  - represents a 2D position
  
*/

class Position{
  
  // MEMBER VARIABLES
  PVector position;
 
  // CONSTRUCTORS
  Position()                  { position = new PVector(0, 0);       }
  Position(PVector _p)        { position = new PVector(_p.x, _p.y); }
  Position(float _x, float _y){ position = new PVector(_x, _y);     }
 
  // SETTERS 
  void set(PVector _p)        { position.x = _p.x; position.y = _p.y; }
  void set(float _x, float _y){ position.x = _x;   position.y = _y;   }
  void setX(float _x)         { position.x = _x;                      }
  void setY(float _y)         { position.y = _y;                      }
 
  // GETTERS
  PVector get (){ return position;   }
  float   getX(){ return position.x; }
  float   getY(){ return position.y; }
 
  // OTHERS
  void add(PVector  _v){ position.add(_v); }
  void sub(PVector _v) { position.sub(_v); }
 
} // class Position END

/*

  class Position
  
  - represents a 2D position
  
*/

class Velocity{
    
  // MEMBER VARIABLES
  PVector velocity;

  // CONSTRUCTORS
  Velocity()                  { velocity = new PVector(0, 0);       }
  Velocity(PVector _v)        { velocity = new PVector(_v.x, _v.y); }
  Velocity(float _x, float _y){ velocity = new PVector(_x, _y);     }
 
  // SETTERS
  void set (float _x, float _y){ velocity.x = _x;   velocity.y = _y;   }
  void set (PVector _v        ){ velocity.x = _v.x; velocity.y = _v.y; }
  void setX(float _x          ){ velocity.x = _x; }
  void setY(float _y          ){ velocity.y = _y; }
 
  // GETTERS
  PVector get (){ return velocity;   }
  float   getX(){ return velocity.x; }
  float   getY(){ return velocity.y; }
 
  // OTHERS
  void add (PVector _v) { velocity.add (_v); }
  void mult(float   _f) { velocity.mult(_f); }
 
 // OTHERS END
} // class Position END

/*

  Class Mover
  
  - represents a moving entity
  - based on position, velocity and acceleration
  - related to friction and mass

*/

class Mover{
  
  // MEMBER VARIABLES
  Position l;              // location
  Velocity v;              // velocity
  PVector acceleration;    // acceleration
  
  // @TODO: maxSpeed isnt yet implemented in mover ! only effects Boids steering forces
  
  float friction;          // Friction 
  float mass;              // Mass of mover
  
  // CONSTRUCTORS
  // DEFAULT CONSTRUCTOR
  Mover(){
    l            = new Position();    // Initialize with L(0, 0)
    v            = new Velocity();    // Initialize with V(0, 0)
    acceleration = new PVector(0, 0); // Initialize with A(0, 0)
 
    friction     = 0.025;             // default friction
    mass         = 1;                 // default mass
  }
  
  // Constructor  for custom location and mass
  Mover(PVector _l, float _m){
    l            = new Position(_l);  // Initialize with given position
    v            = new Velocity();    // Initialize with V(0, 0)
    acceleration = new PVector(0, 0); // Initialize with A(0, 0)
   
    friction     = 0.025;             // default friction
    mass = _m;                        // Initialize with given mass
  }
  
  /*
    // Function for applying a force to the mover by adding a force-vector to its acceleration
    // Newton's 2nd law: F = M * A
    // or A = F / M
  */
  void applyForce(PVector _f){
     PVector f = PVector.div(_f, mass);
     this.acceleration.add(f);
  }
  
  // Fuction for updating the movers position
  void update(){
     // Velocity changes according to acceleration
     v.add(acceleration);
     // Apply the friction to the velocity
     v.mult(1-friction);
     // Position changes by velocity
     l.add(v.get());
     // Clear acceleration each frame
     acceleration.mult(0);
  }
}
// MOVER END


 