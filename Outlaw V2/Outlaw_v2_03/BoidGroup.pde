

class BoidGroup{
  float size;
  ArrayList <Boid> boids;
  
  BoidGroup(float _size){
    boids = new ArrayList();
    size  = 0;
  }
  
  void addBoid(Boid _b){
    boids.add(_b);
    size++;
  }
}