class PaintShape{
  
  PShape shapeUnit;
  PVector position;
  int alpha=50;//初始透明度
  color clr;
  long startTime;//生成该图形单元的时间
  long THRESHOLDTIME=2000;//开始变化透明度的距离生成该图形单元的时间阈值
  
  PaintShape(PVector p,color c,float angle,int []components){  
    float px=0;
    float py=0;
    position=p;
    float a = 0;
    float r = 0;
    clr=c;
    float u = random(0.5, 1);
    shapeUnit=createShape();
    shapeUnit.beginShape();
    shapeUnit.noStroke();
    shapeUnit.fill(c,alpha);
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
    
    startTime=millis();//记录生成图形单元的时间
    }
  
  int getAlpha(){
  return alpha;
  }  
  
  void setFill(){
  if(alpha>0&&millis()-startTime>=THRESHOLDTIME){  
  alpha--;
  shapeUnit.setFill(color(clr,alpha));
  }
  }
  //当生成该图形单元2000ms后，不断更新透明度，设置填充，直到透明度为0
  
  void show(){
  pushMatrix();
  translate(position.x,position.y);
  shape(shapeUnit);
  popMatrix();
  }
  //绘制
}

//PaintShape类：笔刷图形单元