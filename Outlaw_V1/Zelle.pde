class Zelle{
  //Bewegungsgezeugs
  PVector l,v,direction, bdirection;
  float a, d;
  float friction = 0.025;
  boolean typ;
  boolean king;
  // Playergezeugs
  int player;
  int maxLife = 100;
  int life = maxLife;
  // Minutionsgezeugs
  int ammo    = 0;
  int maxAmmo = 30;
  int reload  = 0;
  int reloadt = 25;
 
  Zelle(float x, float y, boolean typ, int player, boolean king){
    this.typ = typ;
    this.player = player;
    this.king = king;
    l = new PVector(x, y);
    v = new PVector(0, 0);
    direction = new PVector(random(-1,1),random(-1, 1));
    bdirection = new PVector(0,0);
    a = 0.2;
    d = 25;
    king = false;
  }
  
  void display(int tview){
  // Zeichnet die Zelle
      if(king){
        stroke(255, 0, 0);
        strokeWeight(3);
      }else if(typ){
        stroke(0, 200, 0);
        strokeWeight(2);
      }else{
        stroke(255);
        strokeWeight(2);
      }
      noFill();
      bdirection.x = 0;
      bdirection.y = 0;
      bdirection.add(v);
      bdirection.normalize();
        line(l.x-view[tview].x+tview*width/2, l.y-view[tview].y, l.x-view[tview].x+tview*width/2+bdirection.x*10, l.y-view[tview].y+bdirection.y*10);
        ellipse(l.x-view[tview].x+tview*width/2, l.y-view[tview].y, d, d);
        strokeWeight(2);
        arc(l.x-view[tview].x+tview*width/2, l.y-view[tview].y, d-6, d-6, 0, TWO_PI/100*(100*life/maxLife));
  } 
  
  void shoot(){
    if(ammo > 0){
      if(king){
        Bullets.add(new Bullet(l.x, l.y, bdirection.x, bdirection.y, 3));
      }else{
        Bullets.add(new Bullet(l.x, l.y, bdirection.x, bdirection.y, player));
      }
      ammo -= 1;
    }
  }
  
  void getAmmo(){
    if(reload < 0){
      if(ammo < maxAmmo){
        ammo += 1; 
        reload = reloadt;
      }
    }
    reload -= 1;
  }
  
  void update(){
    if(typ){
    // Mensch steuert:
      getAmmo();
      if(S[player]){
        shoot();
      }
      if((U[player] || D[player] || L[player] || R[player]) && !M[player]){
        //direction.mult(0);
        if(U[player]){direction.y -= 1;}
        if(D[player]){direction.y += 1;}
        if(L[player]){direction.x -= 1;}
        if(R[player]){direction.x += 1;}
        direction.normalize();
        v.add(PVector.mult(direction, a));
      }
    }else{
    // KI steuert
    kiGehirn(1);
    }
    v.mult(1-friction);
    l.add(v);
    collide();
  } 
  
  boolean dead(){
   boolean d;
   if(life < 0){
     if(king){
      score += 100;
     }else{
      score -= 25;
     }
    d = true;
   }else{d = false;} 
   return d;
  }
 
  void collide(){
    if(l.x < 0+d/2){
      l.x = 0+d/2;
      v.x*=-1;
    }else if(l.x > mapWidth-d/2){
      l.x = mapWidth-d/2;
      v.x*=-1;
    }
    if(l.y < 0+d/2){
     l.y = 0+d/2;
     v.y*=-1; 
    }else if(l.y > mapHeight-d/2){
      l.y = mapHeight-d/2;
      v.y*=-1; 
    }
  }
 
 void kiGehirn(int kiLVL){
 // So handelt die KI
   if(kiLVL <= 1){
   // 1. KI-LEVEL -> Sinnloses umherschwimmen!
     if(king){
       direction.add(new PVector(random(-0.3, 0.3), random(-0.3, 0.3)));
       getAmmo();
       if(int(random(5)) == 3){
         shoot();
       }
     }else{
       direction.add(new PVector(random(-0.3, 0.3), random(-0.3, 0.3)));
     }
   }
   direction.normalize();
   v.add(PVector.mult(direction, a));
 } 
 /*
 // Na toll hab player doppelt...
 int findTarget(){
   float dMin = 10;
   int target = 0;
   for (int i = 0; i < anzPlayer; i++){
     float dist;
     dist = sqrt(sq(player[i].l.x-x)+sq(player[i].l.y-y));
     if(dist <= dMin){
       dMin = dist;
       target = i;
     }
   }
   return target;
 }
 */
}