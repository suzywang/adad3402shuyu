class Brush {
  float angle;
  int components[];
  float x0, y0;//massPositions
  color clr0;//random colors
  int id;//bodyId
  ArrayList<PaintShape> shapes0=new ArrayList();
  //int NUM=200;
  boolean isBodyDisappear=false;//
  boolean isRemovedAll=false;

  Brush(int _id) {
    id=_id;
    angle = random(TWO_PI);
    int randomColorIndex=int(random(sizeofBrushColors));
    clr0=color(brushColors[randomColorIndex]);
    components = new int[2];
    for (int i = 0; i < 2; i++) {
      components[i] = int(random(1, 5));
    }
    println("brush initialised");
  }


  void setIsDisappear() {
    this.isBodyDisappear=true;
  }
  //记录人消失


  boolean getIsDisappear() {

    return isBodyDisappear;
  }
  //获取人是否消失

  boolean getIsRemovedAll() {
    int number=shapes0.size();
    if (isBodyDisappear&&number==0) {
      isRemovedAll=true;
    }
    return isRemovedAll;
  }

  //获取PaintShape图形列表元素是否移除完毕

  void updateAlpha() {

    for (PaintShape paintShape : shapes0) {
      paintShape.setFill();
    }

    for (PaintShape paintShape : shapes0) {
      if (paintShape.getAlpha()==0) {
        shapes0.remove(shapes0);
      }
    }
  }

  //更新各个笔刷图形单元的的透明度，当透明度为0时，从列表移除



  void update(PVector mass) {
    y0=map(constrain(mass.x, -width/2, width/2), -width/2, width/2, 0, height);
    x0=map(constrain(mass.z, 500, 2048), 500, 2048, width, 0);

    if (isBodyDisappear==false) {
      shapes0.add(new PaintShape(new PVector(x0, y0), clr0, angle, components));
    }
    angle += random(-0.15, 0.15);
  }

  //根据中心位置，更新PaintShape图形列表

  void update(PVector mass, float z) {

    y0=map(constrain(mass.x, -width/2, width/2), -width/2, width/2, 0, height);

    x0=map(constrain(z, 500, 2048), 500, 2048, width, 0);
    if (isBodyDisappear==false) {
      shapes0.add(new PaintShape(new PVector(x0, y0), clr0, angle, components));
    } 
    angle += random(-0.15, 0.15);
  }

  void paint() {
    for (PaintShape paintShape : shapes0) {
      paintShape.show();
    }
  }
  //绘制PaintShape图形列表中元素
}