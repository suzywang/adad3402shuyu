class Brush {
  float angle;
  int components[];
  float x0, y0, x1, y1;//handPositions
  color clr;//random color
  int id;//bodyId

  Brush(int _id) {
    id=_id;
    angle = random(TWO_PI);
    clr = color(random(255), random(255), random(255), 50);
    components = new int[2];
    for (int i = 0; i < 2; i++) {
      components[i] = int(random(1, 5));
    }  
    println("brush initialised");
  }


  void update(PVector handRight, PVector handLeft) {
    y0=map(constrain(handRight.x,-width/2,width/2), -width/2, width/2, 0, height);
    y1=map(constrain(handLeft.x,-width/2,width/2), -width/2, width/2, 0, height);
    x0=map(constrain(handRight.z,500,2048), 500, 2048, width, 0);
    x1=map(constrain(handLeft.z,500,2048), 500, 2048, width, 0);
    angle += random(-0.15, 0.15);
  }
  
  
  
  void update(PVector handRight, PVector handLeft,float z) {
    y0=map(constrain(handRight.x,-width/2,width/2), -width/2, width/2, 0, height);
    y1=map(constrain(handLeft.x,-width/2,width/2), -width/2, width/2, 0, height);
    x0=map(constrain(z,500,2048), 500, 2048, width, 0);
    x1=map(constrain(z,500,2048), 500, 2048, width, 0);
    angle += random(-0.15, 0.15);
  }
  
  
  
  
  

  void paint() {
    float px0=0;
    float py0=0;
    float px1=0;
    float py1=0;
    float a0 = 0;
    float r0 = 0;
    float u0 = random(0.5, 1);
    float a1 = 0;
    float r1 = 0;
    float u1 = random(0.5, 1);
    beginShape();
    fill(clr);
    noStroke();
    while (a0 < TWO_PI) {
      vertex(px0, py0); 
      float v = random(0.85, 1);
      px0= x0+r0 * cos(angle + a0) * u0 * v;
      py0= y0+r0 * sin(angle + a0) * u0 * v;
      a0 += PI / 180;
      for (int i = 0; i < 2; i++) {
        r0 += sin(a0 * components[i]);
      }
    }
    endShape(CLOSE);
    
    beginShape();
    fill(clr);
    noStroke();
    while (a1 < TWO_PI) {
      vertex(px1, py1); 
      float v = random(0.85, 1);
      px1= x1+r1 * cos(angle + a1) * u1 * v;
      py1= y1+r1 * sin(angle + a1) * u1 * v;
      a1+= PI / 180;
      for (int i = 0; i < 2; i++) {
        r1 += sin(a1 * components[i]);
      }
    }
    endShape(CLOSE);

  }
}