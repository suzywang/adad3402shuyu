class Brush {
  float angle;
  int components[];
  float x0, y0, x1, y1;//handPositions
  color clr;//random color
  int id;//bodyId
  ArrayList<PaintShape> shapes0=new ArrayList();
  ArrayList<PaintShape> shapes1=new ArrayList();
  int NUM=100;
  
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

    int number=shapes0.size();
    //println(number);
    if (number<20) {
      shapes0.add(new PaintShape(new PVector(x0, y0), clr, angle, components));
      shapes1.add(new PaintShape(new PVector(x1, y1), clr, angle, components));
    } else {
      shapes0.remove(0);
      shapes0.add(new PaintShape(new PVector(x0, y0), clr, angle, components));
      shapes1.remove(0);
      shapes1.add(new PaintShape(new PVector(x1, y1), clr, angle, components));
    }
    angle += random(-0.15, 0.15);
  }
  
  
  
  void update(PVector handRight, PVector handLeft,float z) {

    y0=map(constrain(handRight.x,-width/2,width/2), -width/2, width/2, 0, height);
    y1=map(constrain(handLeft.x,-width/2,width/2), -width/2, width/2, 0, height);
    x0=map(constrain(z,500,2048), 500, 2048, width, 0);
    x1=map(constrain(z,500,2048), 500, 2048, width, 0);

    int number=shapes0.size();
    //println(number);
    if (number<20) {
      shapes0.add(new PaintShape(new PVector(x0, y0), clr, angle, components));
      shapes1.add(new PaintShape(new PVector(x1, y1), clr, angle, components));
    } else {
      shapes0.remove(0);
      shapes0.add(new PaintShape(new PVector(x0, y0), clr, angle, components));
      shapes1.remove(0);
      shapes1.add(new PaintShape(new PVector(x1, y1), clr, angle, components));
    }
    angle += random(-0.15, 0.15);
  }
  
  
  
  
  

  void paint() {
    for (PaintShape paintShape : shapes0) {
      paintShape.show();
    }

    for (PaintShape paintShape : shapes1) {
      paintShape.show();
    }
  }
}