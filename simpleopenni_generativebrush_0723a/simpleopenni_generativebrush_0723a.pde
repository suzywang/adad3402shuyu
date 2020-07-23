/* --------------------------------------------------------------------------
 * SimpleOpenNI User3d Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect 2 library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / Zhdk / http://iad.zhdk.ch/
 * date:  12/12/2012 (m/d/y)
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;
import processing.sound.*;

import java.io.FilenameFilter;
// See: https://docs.oracle.com/javase/6/docs/api/java/io/File.html
// See: https://docs.oracle.com/javase/6/docs/api/java/io/FilenameFilter.html

String[] soundNames;
ArrayList<SoundFile> soundfiles = new ArrayList<SoundFile>();
Reverb reverb;





SimpleOpenNI context;
float        zoomF =0.5f;
float        rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
// the data from openni comes upside down
float        rotY = radians(0);
boolean      autoCalib=true;

PVector      bodyCenter = new PVector();
PVector handLeft=new PVector();
PVector handRight=new PVector();

PVector      bodyDir = new PVector();
PVector      com = new PVector();                                   
PVector      com2d = new PVector();                                   
color[]       userClr = new color[]{ color(255, 0, 0), 
  color(0, 255, 0), 
  color(0, 0, 255), 
  color(255, 255, 0), 
  color(255, 0, 255), 
  color(0, 255, 255)
};

ArrayList<Brush> brushes =new ArrayList();
boolean showDepth=true;

float minZ=10000;
float minY=10000;



void setup()
{
  size(1000, 500, P3D);  // strange, get drawing error in the cameraFrustum if i use P3D, in opengl there is no problem
  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }

  // disable mirror
  context.setMirror(true);

  // enable depthMap generation 
  context.enableDepth();

  // enable skeleton generation for all joints
  context.enableUser();

  stroke(255, 255, 255);
  smooth();  
  perspective(radians(45), 
    float(width)/float(height), 
    10, 150000);

  String path = sketchPath("data/audio");
  soundNames = listFileNames(path);
  printArray(soundNames);
  reverb = new Reverb(this); // initate reverb processing object
  for (int i = 0; i < soundNames.length; i ++) {
    soundfiles.add(new SoundFile(this, "audio/"+soundNames[i]));
  }
}

void draw()
{
  // update the cam
  background(0, 0, 0);
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
  for (int i=0; i<userList.length; i++)
  {
    
    
    if (context.isTrackingSkeleton(userList[i])){
      //drawSkeleton(userList[i]);

      setHand(userList[i]);

    for (Brush b : brushes) {
      if (b.id==userList[i]) {
        b.update(handRight, handLeft, 0.5*handRight.z+0.5*handLeft.z);
        //b.update(handRight,handLeft);
        minY=min(0.5*b.y0+0.5*b.y1, minY);
        break;
      }
    }
    // draw the center of mass
    if (context.getCoM(userList[i], com))
    {
      /*stroke(100,255,0);
       strokeWeight(1);
       beginShape(LINES);
       vertex(com.x - 15,com.y,com.z);
       vertex(com.x + 15,com.y,com.z);
       
       vertex(com.x,com.y - 15,com.z);
       vertex(com.x,com.y + 15,com.z);
       
       vertex(com.x,com.y,com.z - 15);
       vertex(com.x,com.y,com.z + 15);
       endShape();
       */
      minZ=min(minZ, com.z);
    }
    }
  }    
  popMatrix();

  minZ=constrain(minZ, 500, 2048);
  minY=constrain(minY, 0, height);
  
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
    if(showDepth){
   image(context.depthImage(),width/6,height/5,height/10.0/context.depthImage().height*context.depthImage().width,height/10);
  }
  popMatrix();
}
