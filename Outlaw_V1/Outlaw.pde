/*
ABER ICH WILL MUSIK!!!
import ddf.minim.*;
Minim minim;
AudioPlayer p;

Ideen für POWERUPS:l

Finte:
Zelle die nur für Gegner Rot ist und 1/4 der normalen lebenspunkte hat
rapid fire
mine
double
speed+
health+

Negative Powerups aus Innocents
speed-
maxAmmo/2
mine
Kopfgeld

*/

// Einstellungen
int   bots        = 50;
int   anzPlayer   = 2;
float mapWidth  = random(100, 2000);
float mapHeight = random(100, 2000);

// Gloabal Stuff
int score = 0;
boolean kingDead;

boolean[] U = new boolean[2];
boolean[] D = new boolean[2];
boolean[] L = new boolean[2];
boolean[] R = new boolean[2];
boolean[] M = new boolean[2];
boolean[] S = new boolean[2];
char[][]  tasten = new char[2][7];

// Objekte
View view[];
Background bg;
ArrayList Bullets;
ArrayList Zellen;
ArrayList Explotions;
Zelle player[];


void setup(){
  size(displayWidth, displayHeight);
  smooth();
  //minim = new Minim(this);
  //Fehler beim laden...
  //p = minim.loadFile("track.wav");
  //p.play();
  
  // Steuerung Player 1
  tasten[0][0] = 'w';
  tasten[0][1] = 's';
  tasten[0][2] = 'a';
  tasten[0][3] = 'd';
  tasten[0][4] = '<';
  tasten[0][5] = 'r';
  tasten[0][6] = 'q';
  
  tasten[1][0] = 'o';
  tasten[1][1] = 'l';
  tasten[1][2] = 'k';
  tasten[1][3] = 'ö';
  tasten[1][4] = 'm';
  tasten[1][5] = 'ü';
  tasten[1][6] = 'i';
  
  bg = new Background(300);
  Explotions = new ArrayList();
  player = new Zelle[anzPlayer];
  for(int i = 0; i < anzPlayer; i++){
    player[i] = new Zelle(mapWidth/2, mapHeight/2, true, i, false);
    player[i].life = 100;
  }
  Bullets = new ArrayList();
  // Zellen Erschaffen
  Zellen = new ArrayList();
  for(int i=0; i<bots;i++){
    Zellen.add(new Zelle(mapWidth/2, mapHeight/2, false, -1, false));
  }
  //View erschaffen
  view = new View[anzPlayer];
  for(int i = 0; i < anzPlayer; i++){
      view[i] = new View(player[i].l.x, player[i].l.y, width/anzPlayer, height);
  }
  findNewKing();
}

void draw(){
  println("Score = " + score);
  background(0);
  for(int i = 0; i < anzPlayer; i++){
    view[i].update(player[i].l.x, player[i].l.y);
  }
  if(kingDead){findNewKing();}
  // Map rand anzeigen + Player update
  updatePlayer();
  //Explosionen anzeigen
  showExplotion();
  // Bullets 
  bulletzeug();
  // Player anzeigen
  showPlayer();
  // Bots anzeigen
  zellenzeug();
  // Linie in der Mitte des Bildschirms
  if(anzPlayer == 2){
    strokeWeight(45);
    stroke(255);
    line(width/2, 0, width/2, height);
  }
  for(int i = 0; i<anzPlayer; i++){
    view[i].hub(i);
  }
}

void findNewKing(){
  int k;
  k = int(random(Zellen.size()-1));
  for(int i = Zellen.size()-1; i >= 0; i--){
    Zelle zelle = (Zelle) Zellen.get(i);
    if(i == k){
      zelle.king = true;
      zelle.life = 100;
      zelle.a = 0.2; 
      //zelle.reloadt = 10;
      kingDead = false;
    }
  }
}

void keyPressed(){
  for(int i = 0; i < anzPlayer; i++){
    if     (key == tasten[i][0]){U[i] = true;}
    if(key == tasten[i][1]){D[i] = true;}
    if(key == tasten[i][2]){L[i] = true;}
    if(key == tasten[i][3]){R[i] = true;}
    if(key == tasten[i][4]){M[i] = true;}
    if(key == tasten[i][6]){S[i] = true;}
    if(key == tasten[i][5]){M[i] = false;}
  }
}

void keyReleased(){
  for(int i = 0; i < anzPlayer; i++){
    if     (key == tasten[i][0]){U[i] = false;}
    if(key == tasten[i][1]){D[i] = false;}
    if(key == tasten[i][2]){L[i] = false;}
    if(key == tasten[i][3]){R[i] = false;}
    if(key == tasten[i][6]){S[i] = false;}
  }
}

void updatePlayer(){
  for(int i = 0; i < anzPlayer; i++){
    if(player[i].dead()){
      addExplotion(player[i].l.x, player[i].l.y, false);
      player[i].l.x = random(0+player[i].d, mapWidth-player[i].d);
      player[i].l.y = random(0+player[i].d, mapHeight-player[i].d);
      player[i].life = 100;
    }
    player[i].update();
      if( i == 0){
        if(0-view[i].x+mapWidth <= width/anzPlayer){
          line(0-view[i].x+mapWidth, 0, 0-view[i].x+mapWidth, height);
        }
        line(0-view[i].x, 0, 0-view[i].x, height);
        line(0, 0-view[i].y, width/anzPlayer, 0-view[i].y);
        line(0, mapHeight-view[i].y, width/anzPlayer, mapHeight-view[i].y);
      }if( i == 1){
        if(0-view[i].x+i*width/2 >= width/2){
          line(0-view[i].x+i*width/2, 0, 0-view[i].x+i*width/2, height);
        }
        line(0-view[i].x+mapWidth+i*width/2, 0, 0-view[i].x+mapWidth+i*width/2, height);
        line(width/2, 0-view[i].y, width, 0-view[i].y);
        line(width/2, mapHeight-view[i].y, width, mapHeight-view[i].y);
      } 
  }
}

void showPlayer(){
  for(int i = 0; i < anzPlayer; i++){
    for(int v = 0; v<anzPlayer; v++){
      if(view[v].inView(player[i].l.x, player[i].l.y, player[i].d) == true){
        player[i].display(v);
      }
    }
  }
}

void zellenzeug(){
    for(int i = Zellen.size()-1; i >= 0; i--){
    Zelle zelle = (Zelle) Zellen.get(i);
    if(zelle.dead()){
      addExplotion(zelle.l.x, zelle.l.y, zelle.king);
      if(zelle.king){kingDead = true;}
      Zellen.remove(i);
    }
    zelle.update();
    for(int v = 0; v<anzPlayer; v++){
      if(view[v].inView(zelle.l.x, zelle.l.y, zelle.d) == true){
        zelle.display(v);
      }
    }
  }
}

void bulletzeug(){
  for(int i = Bullets.size()-1; i >= 0; i--){
    Bullet bullet = (Bullet) Bullets.get(i);
    bullet.update();
    bullet.collide();
    //if(){Bullets.remove(i);}
    for(int v = 0; v<anzPlayer; v++){
      if(view[v].inView(bullet.x, bullet.y, bullet.d)){
        bullet.display(v);
      }
    }
    if(bullet.endOfWay() || bullet.hit()){Bullets.remove(i);}
  } 
}

boolean addExplotion(float x, float y, boolean king){
   for(int i = 0; i < 50; i++){
     Explotions.add(new Explode(x,y, king));
   }
   if(Explotions.size() == 0){
     return true;
   }else{
     return false;
   }
  }
void showExplotion(){
  for(int i = Explotions.size()-1; i >= 0; i--){
    Explode explode = (Explode) Explotions.get(i);
    explode.update();
    explode.collide();
    for(int v = 0; v < anzPlayer; v++){
      if(view[v].inView(explode.x, explode.y, explode.d)){
        explode.display(v);
      }
    }
    if(explode.endOfWay()){Explotions.remove(i);}
  }
}
/*
Ideen:
100 Zellem, Kopfgeld immer nur auf eine, alle anderen ziehen Punkte ab!

*/