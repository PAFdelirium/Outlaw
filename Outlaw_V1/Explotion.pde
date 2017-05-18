class Explode{
  float x, y, d, a;
  PVector direction, v;
  float friction = 0.02;
  boolean king;
  Explode(float x, float y, boolean king){
    this.x = x;
    this.y = y;
    this.king = king;
    d = random(35);
    a = 1;
    direction = new PVector(random(-1,1),random(-1,1));
    v = new PVector(0,0);
  }
  
  void display(int tview){
    strokeWeight(2);
    if(king){stroke(255,0,0);}
    else{stroke(0,255,0);}
    noFill();
    ellipse(x-view[tview].x+tview*width/2, y-view[tview].y, d, d);
  }
  
  
  boolean endOfWay(){
    boolean out;
    if(d <= 1){
      out = true;
    }else{
      out = false;
    }
    return out;
  }
  
  void update(){
    v.add(PVector.mult(direction, a));
    v.mult(1-friction);
    d *= 0.94;
    x += v.x;
    y += v.y;
  }
  void collide(){
    if(x < 0+d/2){
      x = 0+d/2;
      v.x*=-1;
      direction.x*=-1;
    }else if(x > mapWidth-d/2){
      x = mapWidth-d/2;
      v.x*=-1;
      direction.x*=-1;
    }
    if(y < 0+d/2){
     y = 0+d/2;
     v.y*=-1;
     direction.y*=-1; 
    }else if(y > mapHeight-d/2){
      y = mapHeight-d/2;
      v.y*=-1; 
      direction.y*=-1;
    }
  }
}