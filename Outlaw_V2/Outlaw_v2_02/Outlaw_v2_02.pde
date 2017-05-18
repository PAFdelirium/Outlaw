
Canvas canvas;

int       botCount;
ArrayList boids;
ArrayList movers2;


void setup() {
  fullScreen(P2D);
  //size(400, 400);
  canvas = new Canvas(910, 540);


  botCount = 100;
  boids = new ArrayList();
  for (int i = 0; i < botCount; i++) {
    //float radius = random(1, 5);
    //boids.add(new Boid(new PVector(i*20, canvas.pgHeight/2 + sin(i)*15 ), 0.5, radius));
    
    // SMALL GROUPS CONFIG ( some nice 3 - 5 clusters sometimes )
    float radius = random(1, 5);
    boids.add(new Boid(new PVector(canvas.pg.width/2, canvas.pg.height/2), 0.5, radius, 0.01, 2, radius*4, radius*2));
  }
}


void draw() {
  //canvas.pgBackground();
  canvas.transparentBackground(255);
  for (int i = boids.size()-1; i >= 0; i--) {
    Boid boid = (Boid) boids.get(i);
    boid.run(boids, canvas);
  }
  /*
  for (int i = Movers.size()-1; i >= 0; i--) {
    Mover mover = (Mover) Movers.get(i);
    mover.display();
  }
  */
  canvas.display();
  //collide();
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




void mousePressed() {
  for (int i = boids.size()-1; i >= 0; i--) {
    Boid boid = (Boid) boids.get(i);
    PVector direction = new PVector(random(-1, 1), random(-1, 1));
    direction.normalize();
    boid.acceleration = direction;
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