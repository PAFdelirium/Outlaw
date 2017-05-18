class Bullet{
 float x, y, vx = 1, vy = 1, dx, dy;
 float a = 35;
 float d = 5;
 int damage = 10;
 float friction = 0.05;
 int owner;
 Bullet(float x, float y, float dx, float dy, int owner){
  this.x = x;
  this.y = y;
  this.dx = dx;
  this.dy = dy;
  this.owner = owner;
    if(dx == 0 && dy == 0){
     dx = 1;
     dy = 1; 
    }
    vx = dx * a;
    vy = dy * a;
 } 

  void display(int tview){
   stroke(0, 255, 0);
   strokeWeight(2);
   ellipse(x-view[tview].x+tview*width/2, y-view[tview].y, d, d); 
  }
  
  boolean endOfWay(){
    boolean out;
    if(sqrt(sq(vx)+sq(vy)) < 0.2){
      out = true;
    }else{
      out = false;
    }
    return out;
  }
  
  boolean hit(){
    // Besser wäre eine takeDamage Funktion in der Klasse Zelle selbst.
    // Hier vielleicht nur eine removeBullet Funktion einbauen...
    int p=0;
    for(int i = 0;i < anzPlayer; i++){
      float tx = player[i].l.x-x;
      float ty = player[i].l.y-y;
      if(sqrt(sq(tx)+sq(ty)) < player[i].d/2+d/2){
        player[i].life -= damage;
        i = -1;
        return true;
      }

    }
    for(int i = Zellen.size()-1; i >= 0; i--){
      Zelle zelle = (Zelle) Zellen.get(i);
      float tx = zelle.l.x-x;
      float ty = zelle.l.y-y;
      if(sqrt(sq(tx)+sq(ty)) < zelle.d/2+d/2){
        zelle.life -= damage;
        i = -1;
        p = i;
      }
    }
    if(p == -1){
     return true; 
    }else{
     return false; 
    }
  }
  
  void collide(){
    if(x < 0+d/2){
      x = 0;
      vx*=-0.8;
    }else if(x > mapWidth-d/2){
      x = mapWidth;
     vx*=-0.8; 
    }else if(y < 0+d/2){
      y = 0;
      vy*=-0.8;
    }else if(y > mapHeight-d/2){
     y = mapHeight;
     vy*=-0.8; 
    }
  }

  void update(){
    vx *= 1-friction;
    vy *= 1-friction;
    d -= d/100*random(10);
    x += vx;
    y += vy; 
  }
}