class Brush {
  float angle;
  int components[];
  float x0, y0;//massPositions
  color clr0;//random colors
  int id;//bodyId
  ArrayList<PaintShape> shapes0=new ArrayList();
  //int NUM=200;
  long startTime;//记录人消失的时间
  long TIMETHRESHOLD=6000;//延时时间为6s,当人消失6000ms后,开始逐个消失
  boolean isBodyDisappear=false;//
  boolean isRemove=false;//是否开始移除
  boolean isRemovedAll=false;//是否完全移除

  Brush(int _id) {
    id=_id;
    angle = random(TWO_PI);
    int randomColorIndex=int(random(sizeofBrushColors));
    clr0=color(brushColors[randomColorIndex], 50);
    components = new int[2];
    for (int i = 0; i < 2; i++) {
      components[i] = int(random(1, 5));
    }
    println("brush initialised");
  }


  void setIsDisappear() {
    this.isBodyDisappear=true;
    startTime=millis();
  }
  //记录人消失时刻

  boolean getIsDisappear() {

    return isBodyDisappear;
  }

  //获取人是否消失
  boolean getIsRemovedAll() {
    return isRemovedAll;
  }

  //获取PaintShape图形列表元素是否移除完毕


  void remove() {
    int number=shapes0.size();
    if (isRemove==false) {
      if (isBodyDisappear&&millis()-startTime>=TIMETHRESHOLD) {
        isRemove=true;
      }
    } else {
      if (number!=0) {
        shapes0.remove(0);
      } else {
        isRemovedAll=true;
      }
    }
  }
  //移除函数，当人消失超过6s后，开始逐个移除PaintShape图形列表中元素，直到PaintShape图形列表中元素数量为0


  void update(PVector mass) {
    y0=map(constrain(mass.x, -width/2, width/2), -width/2, width/2, 0, height);
    x0=map(constrain(mass.z, 500, 2048), 500, 2048, width, 0);

    if (isRemove==false) {
      shapes0.add(new PaintShape(new PVector(x0, y0), clr0, angle, components));
    }
    angle += random(-0.15, 0.15);
  }

  //根据中心位置，更新PaintShape图形列表

  //void update(PVector mass,float z) {

  //  y0=map(constrain(mass.x,-width/2,width/2), -width/2, width/2, 0, height);

  //  x0=map(constrain(z,500,2048), 500, 2048, width, 0);
  //  if (isRemove==false) {
  //    shapes0.add(new PaintShape(new PVector(x0, y0), clr0, angle, components));

  //  } 
  //  angle += random(-0.15, 0.15);
  //}

  void paint() {
    for (PaintShape paintShape : shapes0) {
      paintShape.show();
    }
  }
  //绘制PaintShape图形列表中元素
}