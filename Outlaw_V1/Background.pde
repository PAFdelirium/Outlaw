class Background{
  Circle circles[];
  int anz;
  Background(int anz){
    this.anz = anz;
    circles = new Circle[anz];
    for(int i = 0; i < anz; i++){
      circles[i] = new Circle(random(-width/2, mapWidth+width/2),random(-height/2, mapHeight+height/2),random(3, 10));
    }
  }
  
    void display(int p){
      for(int i = 0; i < anz; i++){
        strokeWeight(1);
        if(view[p].inView(circles[i].x-circles[i].z*player[p].l.x/10+p*width/2, circles[i].y-circles[i].z*player[p].l.y/10, circles[i].z)){
          ellipse(circles[i].x-circles[i].z*player[p].l.x/10+p*width/2, circles[i].y-circles[i].z*player[p].l.y/10, circles[i].z, circles[i].z);
        }
      }
    }
  
  class Circle{
    float x,y,z;
    Circle(float x, float y, float z){
      this.x = x;
      this.y = y;
      this.z = z;
    }
  }
}