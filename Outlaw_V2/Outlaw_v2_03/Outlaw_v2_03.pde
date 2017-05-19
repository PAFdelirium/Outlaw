
Canvas canvas;

ArrayList boids;
ArrayList movers2;


void setup() {
  fullScreen(P2D);
  canvas = new Canvas((int)RESOLUTION_1.x, (int)RESOLUTION_1.y);
  frameRate(FRAME_RATE);


  int botCount = BOT_COUNT;
  
  // For elliptic startpositions
  float circleAngle = TWO_PI/botCount;
  float angle = 0;
  
  boids = new ArrayList();
  for (int i = 0; i < botCount; i++) {
    angle += circleAngle;
    float radius = 5;
    boids.add(new Boid(new PVector(canvas.pg.width/2 + sin(angle)*200, canvas.pg.height/2 + cos(angle)*200), 0.5, radius, 0.01, 2, radius*random(7, 10), radius*4));
  }
}


void draw() {
  
  canvas.transparentBackground(BACKGROUND_COLOR, BACKGROUND_ALPHA);
  
  updateBoids();
  
  canvas.display();

  collideBoids();
  
}

void mousePressed() {
  for (int i = boids.size()-1; i >= 0; i--) {
    Boid boid = (Boid) boids.get(i);
    PVector direction = new PVector(random(-1, 1), random(-1, 1));
    direction.normalize();
    boid.acceleration = direction;
  }
}

void updateBoids(){
    for (int i = boids.size()-1; i >= 0; i--) {
    Boid boid = (Boid) boids.get(i);
    boid.run(boids, canvas);
  }
}

void collideBoids(){
  if(!NOCLIP){
    for (int i = boids.size()-1; i >= 0; i--) {
      Boid boid = (Boid) boids.get(i);
      for (int k = boids.size()-1; k >= 0; k--) {
        if(i != k){
          Boid other = (Boid) boids.get(k);
          boid.checkCollision(other);
        }
      }
    }
  }
}


/*
void collide(){
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
*/