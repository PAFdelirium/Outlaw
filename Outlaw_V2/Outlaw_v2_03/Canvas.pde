

class Canvas{
  int pgWidth, pgHeight;
  int scaleWidth, scaleHeight;
  PVector cropOffset;
  
  PGraphics pg;
  
  Canvas(int _width, int _height){
    this.pgWidth  = _width;
    this.pgHeight = _height;
    
    pg = createGraphics(this.pgWidth, this.pgHeight, JAVA2D);
    
    // Calculate scaleWidth, scaleWidth and cropOffset
    cropScale();
  }
  
  void display(){
    image(pg, cropOffset.x, cropOffset.y, scaleWidth, scaleHeight);
  }
  
  void pgBackground(){
    pg.beginDraw();
    pg.background(BACKGROUND_COLOR);
    pg.endDraw();
  }
  
  void transparentBackground(color _color, float _transparency){
    pg.beginDraw();
    pg.noStroke();
    pg.fill(_color, _transparency);
    pg.rect(0, 0, pgWidth, pgHeight);
    pg.stroke(255);
    pg.fill(255);
    pg.text(frameRate, 20, 20);
    pg.noFill();
    pg.ellipse(pgWidth/2, pgHeight/2, 500, 500);
    pg.endDraw();
  }
 
  void cropScale() {
    float screenRatio = width/height;
    float pgRatio = pg.width/pg.height;
    if (pgRatio == screenRatio) {
      scaleWidth = width;
      scaleHeight = height;
    }
    cropOffset = new PVector(0,0);
    if (pgRatio > screenRatio) {  //// page is wider
      scaleHeight = height;
      scaleWidth = int(ceil(pg.width*height/pg.height));
      cropOffset = new PVector( -(scaleWidth-width)/2, 0 );
      //println("page wider: ", scaleWidth, scaleHeight, cropOffset.x, cropOffset.y);
    } else {
      scaleWidth = width;
      scaleHeight = int(ceil(height/pgRatio));
      cropOffset = new PVector( 0, -(scaleHeight-height)/2 );
      //println("page taller: ", scaleWidth, scaleHeight, cropOffset.x, cropOffset.y);
    }
  }
}