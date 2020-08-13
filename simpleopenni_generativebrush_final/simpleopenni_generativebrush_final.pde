import SimpleOpenNI.*;
import processing.sound.*;
import java.io.FilenameFilter;

String[] soundNames;
ArrayList<SoundFile> soundfiles = new ArrayList<SoundFile>();
Reverb reverb;



SimpleOpenNI context;
float        zoomF =0.5f;
float        rotX = radians(180);  

float        rotY = radians(0);
boolean      autoCalib=true;

PVector bodyCenter=new PVector();
PVector      bodyDir = new PVector();
PVector      com = new PVector();                                   
PVector      com2d = new PVector();                                   

color[]       userClr = new color[]{ 
  color(0, 99, 99), 
  color(119, 99, 99), 
  color(239, 99, 99), 
  color(59, 99, 99), 
  color(299, 99, 99), 
  color(179, 99, 99)
};
//骨架颜色数组


ArrayList<Brush> brushes =new ArrayList();
//brushes列表用于存储Brush对象


color []brushColors=new color[]{
  color(207, 72, 100), 
  color(263, 36, 89), 
  color(343, 65, 91), 
  color(13, 66, 98), 
  color(48, 92, 100), 
  color(165, 47, 86), 
  color(123, 50, 80), 
  color(237, 78, 100), 
  color(76, 61, 96), 
  color(0, 68, 100), 
  color(31, 76, 100), 
  color(337, 89, 100)
};
//用于取Brush颜色随机值的数组
int sizeofBrushColors;//Brush颜色随机值的数组的元素数量,当前为12

float minZ=10000;
float minY=10000;

boolean showDepthAndSkeleton=true;//是否展示骨架



void setup()
{
  size(1600, 1600, P3D);
  
  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }

  context.setMirror(true);//设置镜像
  context.enableDepth();//打开深度图
  context.enableUser();//打开用户图以支持骨骼绘制
  
  colorMode(HSB, 360, 100, 100, 255);//设置颜色模式为HSB，四个数值分别为H、S、B、Alpha最大值
  
  smooth();  
  perspective(radians(45), 
    float(width)/float(height), 
    10, 150000);
  
  //视角设置
    
  String path = sketchPath("data/audio");
  soundNames = listFileNames(path);
  printArray(soundNames);
  reverb = new Reverb(this);
  for (int i = 0; i < soundNames.length; i ++) {
    soundfiles.add(new SoundFile(this, "audio/"+soundNames[i]));
  }
  sizeofBrushColors=brushColors.length;//颜色数组的元素数量
  //println(sizeofBrushColors);
}

void draw()
{
  background(0, 0, 99);
  context.update();
  minZ=10000;
  minY=10000;
  // set the scene pos
  pushMatrix();
  translate(width/2, height/2, 0);   
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);

  translate(0, 0, -1000);  // set the rotation center of the scene 1000 infront of the camera
  // draw the skeleton if it's available

  int[] userList = context.getUsers(); 
  //获取被识别的用户id
  
  for (int i=0; i<userList.length; i++)
  {


    if (context.isTrackingSkeleton(userList[i])) {

      if (showDepthAndSkeleton) {
        drawSkeleton(userList[i]);
      }
      
      //当需要展示骨架时，绘制骨架

      if (context.getCoM(userList[i], com))
      {

        if (showDepthAndSkeleton) {
          stroke(96, 99, 99);
          strokeWeight(1);
          beginShape(LINES);
          vertex(com.x - 15, com.y, com.z);
          vertex(com.x + 15, com.y, com.z);

          vertex(com.x, com.y - 15, com.z);
          vertex(com.x, com.y + 15, com.z);

          vertex(com.x, com.y, com.z - 15);
          vertex(com.x, com.y, com.z + 15);
          endShape();
        }//当需要展示骨架时，绘制重心坐标
        
        for (Brush b : brushes) {
          if (!b.getIsDisappear()&&b.id==userList[i]) {
            b.update(com);
            break;
          }
        }//采用重心点坐标更新被跟踪对象对应的Brush实例的位置数据
        
        minY=min(com.y, minY);//获取所有被跟踪对象的最小的重心y坐标
        minZ=min(minZ, com.z);//获取所有被跟踪对象的最近的重心z坐标
      }
    }
  }    
  popMatrix();
  
  
  
  for (Brush b : brushes) {
    b.updateAlpha();
    if (b.getIsDisappear()) {
      if (b.getIsRemovedAll()) {
        brushes.remove(b);
      }//若该Brush对象中的笔刷单元列表全部被移除了，则移除该Brush实例
    }
  }

  minZ=constrain(minZ, 500, 2048);
  minY=constrain(minY, 0, height);
  //对坐标范围进行约束，以免出现异常值
  
  int soundIndex = int(map(minZ-1, 500, 2048, 0, soundNames.length));
  float indexWidth = map(minZ, 500, 2048, 0.0, 1.0);
  float indexHeight = map(minY, 0, height, 0.0, 1.0); // map as float between 0.0 and 1.0
  if (!soundfiles.get(soundIndex).isPlaying()) {
    soundfiles.get(soundIndex).play();
    reverb.process(soundfiles.get(soundIndex));
    reverb.set(indexWidth, indexWidth, indexHeight); // .set(room, damp, wet)
    println("index :"+soundIndex+" trigger the soundfile :"+soundNames[soundIndex]);
  }
  pushMatrix();
  
  for (Brush b : brushes) { 
    b.paint();
  }
  //绘制brushes中的Brush实例
  
  if (showDepthAndSkeleton) {
    imageMode(CENTER);
    image(context.depthImage(), width/6, height/5, height/10.0/context.depthImage().height*context.depthImage().width, height/10);
  }
  //当需要展示骨架时，绘制深度图于左上角
  
  popMatrix();
}
