
Canvas canvas;

int       botCount;
ArrayList Movers;


void setup() {
  fullScreen(P2D);
  //size(400, 400);
  canvas = new Canvas(640, 460);


  botCount = 50;
  Movers = new ArrayList();
  for (int i = 0; i < botCount; i++) {
    Movers.add(new Mover(new PVector(i*20, canvas.pgHeight/2 + sin(i)*15 ), 1));
  }
}


void draw() {
  canvas.pgBackground();
  for (int i = Movers.size()-1; i >= 0; i--) {
    Mover mover = (Mover) Movers.get(i);
    mover.update();
  }

  for (int i = Movers.size()-1; i >= 0; i--) {
    Mover mover = (Mover) Movers.get(i);
    mover.display();
  }
  canvas.display();
}




void mousePressed() {
  for (int i = Movers.size()-1; i >= 0; i--) {
    Mover mover = (Mover) Movers.get(i);
    PVector direction = new PVector(random(-1, 1), random(-1, 1));
    direction.normalize();
    mover.acceleration = direction;
  }
}