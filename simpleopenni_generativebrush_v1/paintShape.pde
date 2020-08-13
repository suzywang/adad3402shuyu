class PaintShape {

  PShape shapeUnit;
  PVector position;
  int alpha;
  color clr;

  PaintShape(PVector p, color c, float angle, int []components) {  
    float px=0;
    float py=0;
    position=p;
    float a = 0;
    float r = 0;
    clr=c;
    float u = random(0.5, 1);
    shapeUnit=createShape();
    shapeUnit.beginShape();
    shapeUnit.fill(c);
    shapeUnit.noStroke();
    while (a < TWO_PI) {
      shapeUnit.vertex(px, py); 
      float v = random(0.85, 1);
      px= r * cos(angle + a) * u * v;
      py= r * sin(angle + a) * u * v;
      a += PI / 180;
      for (int i = 0; i < 2; i++) {
        r += sin(a * components[i]);
      }
    }
    shapeUnit. endShape(CLOSE);
  }


  void show() {
    pushMatrix();
    translate(position.x, position.y);
    shape(shapeUnit);
    popMatrix();
  }
}

//PaintShape类：笔刷图形单元