class View{
  float x, y, vWidth, vHeight;
 View(float x, float y, float vWidth, float vHeight){
  this.x = x;
  this.y = y;
  this.vWidth = vWidth;
  this.vHeight = vHeight;
 }
 
 void update(float tx, float ty){
   x = tx-vWidth/2;
   y = ty-vHeight/2;
 }
 
 boolean inView(float tx, float ty, float d){
   boolean in;
   if(tx > x-d/2 && tx < x+vWidth+d/2 && ty > y-d/2 && ty < y+vHeight+d/2){
    in = true;
   }else{
    in = false;
   }
  return in; 
 }

 void hub(int p){
   strokeWeight(2);
   stroke(255);
   fill(255);
   rect(p*width/2, vHeight-50, vWidth, vHeight);
   fill(0);
   rect(10+p*width/2, vHeight-40, vWidth-20, vHeight-20);
   fill(0);
   textSize(25);
   fill(255);
   text("Ammo: ", 25+p*width/2, vHeight-12);
   for(int i = player[p].ammo; i > 0; i--){
     rect(150+i*7+p*width/2, vHeight-30, 2, 20);
   }
   text("HP: ", 400+p*width/2, vHeight-12);
   rect(450+p*width/2, vHeight-30, 100*player[p].life/player[p].maxLife*2, 20);
   noFill();
   rect(445+p*width/2, vHeight-35, 210, 30);
 }

}