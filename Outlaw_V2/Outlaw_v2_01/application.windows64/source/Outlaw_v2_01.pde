
Canvas canvas;

int       botCount;
ArrayList movers;


void setup() {
  fullScreen(P2D);
  //size(400, 400);
  canvas = new Canvas(640, 460);


  botCount = 250;
  movers = new ArrayList();
  for (int i = 0; i < botCount; i++) {
    movers.add(new Mover(new PVector(i*20, canvas.pgHeight/2 + sin(i)*15 ), 1, random(1, 5)));
  }
}


void draw() {
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




void mousePressed() {
  for (int i = movers.size()-1; i >= 0; i--) {
    Mover mover = (Mover) movers.get(i);
    PVector direction = new PVector(random(-1, 1), random(-1, 1));
    direction.normalize();
    mover.acceleration = direction;
  }
}



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