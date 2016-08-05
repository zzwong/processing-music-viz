/**
 * Used https://github.com/blyk/Music-Visualization/blob/master/MusicViz.pde 
 * for inspiration and for maths 
 */


/* 
 * To install minim: Sketch > Import Library > Add Library... > [Type in "Minim"] > Install
 */
import ddf.minim.analysis.*;
import ddf.minim.*;

BeatDetect  beat = new BeatDetect();
Minim       minim;
AudioPlayer song;
Objects     a;
int         i;
//int         r = 150;
int h = 720;
float         r = h/7.2; // for smaller res
                     // size of the waveform circle (rectangle thing)
boolean     g = true;    // used to flip stroke color to increment or decrement

void settings(){
  //size(1280, 720, P3D);
  size(1280, 720, P3D);
}
void setup()
{
  //size(1920, 1080, P3D);

  // instanstiate Minim object to be able to load audio files 
  minim = new Minim(this);

  // Loads audio file 
  // Use buffer size of 2048 since it has to be in power of 2^n, also to fit horizontal
  // screen
  song = minim.loadFile("jingle.mp3", 2048);
  // full song here: 
  //song = minim.loadFile("Cotton Candy.mp3", 2048);
  // Loop file indefinitely
  song.loop();

  // instantiate the object that draws 3d things
  a = new Objects (width/2, height/2);
}


void draw()
{
  //background(0);

  // flash random color on beat
  beat.detect( song.mix );  
  if ( beat.isOnset() ) {
    background(random(156,255), random(255), random(255));
  }

  stroke(255); // white waveform 

  // draw waveforms by connecting neighbor values w/ a line.
  // scale the values by large number because values in buffer are normalized to a value
  // between -1 and 1. 
  // show that animation is based on audio input by showing the waveform
  int bsize = song.bufferSize();
  for (int i = 0; i < song.bufferSize() - 1; i++)
  {
    //line(i, 50 + song.left.get(i)*50, i+1, 50 + song.left.get(i+1)*50);
    //line(i, 150 + song.right.get(i)*50, i+1, 150 + song.right.get(i+1)*50);
    //line(i, 1100 + song.mix.get(i)*80, i+1, 1100 + song.mix.get(i+1)*80);
    line(i, height-(height/11) + song.mix.get(i)*80, i+1, height-(height/11) + song.mix.get(i+1)*80);
  }
  
  translate(width/2, height/2);
  stroke(0); // black
  
  /* draw circular waveform w/ rectangles */
  
  // use sin and cos functions to place objects in a circle
  // initial x and y placed in a circle
  // x2 and y2 determined by value at the buffer index
  // effect created is a circular wave form displayed with rectangles
  for(int j = 0; j < bsize -1; j+=40){
    float x = (r)*cos(j*2*PI/bsize);
    float y = (r)*sin(j*2*PI/bsize);
    float x2 = (r + song.left.get(j)*100)*cos(j*2*PI/bsize);
    float y2 = (r + song.right.get(j)*100)*sin(j*2*PI/bsize);    
    rect(x, y, x2, y2);
  }
  


  /* draw the spheres & boxes */
  
  // black to white gradient effect when drawing spheres/boxes
  if(g){
    if(i == 255) {
      g = !g; 
    }
    i++;
  } else {
    if(i == 30){
      g = !g;
    }
    i--;
  }
  stroke(i);
  
  // make stroke size fatter
  strokeWeight(1.3);
  if (beat.isOnset()) {
    a.flip = 0;
    a.dir = !a.dir;                    // on beat, change direction boxes move
    a.draw();                          // spheres 
  } else{      
     translate(width/3, 0, 0);         // move pen to the right
    a.flip = 1;   
    a.draw();                          // box right    
     translate(-(2*width)/3, 0,0);     // move pen to the left
    a.draw();                          // box left
  }
}


// to exit easily  
void keyPressed() {
  if (key==' ')exit();  
}


// 3d object class
class Objects {

  float x;
  float y;
  int flip = 0;         // to determine whether cubes or spheres are drawn
  float yRot = 0;
  float zRot = 0;
  float xRot = 0;
  boolean dir;          // to determine which direction the cubes will rotate

  Objects(float tempX, float tempY) {
    x = tempX;
    y = tempY;       
  }

  void draw() { 
    // draw spheres
    if(flip == 0){
      rotateY(random(PI)); 
      rotateZ(random(PI));
      //noFill();
      lights();
      sphereDetail((int)random(60));
      //sphere(random(50,147));
      sphere(random(r/2,r-1)); // smaller res
    } 
    // draw boxes and rotate them
    else {
     pushMatrix();
     if(a.dir){
       rotateY(yRot);
       rotateZ(zRot);
       rotateX(xRot);
     } else {
       rotateY(-yRot);
       rotateZ(-zRot);
       rotateX(-xRot);
     }
     // increment/decrement rotation values for cool 3d movement
     xRot =+ .002;
     zRot-=.01;
     yRot+=.009;     
     noFill();
     sphereDetail(40);
     box(width/8); // for 1280 x 720          
     if(yRot >= 2*PI || xRot >= 2*PI || zRot <= -2*PI){
       yRot = 0;  
       xRot = 0;
       zRot = 0;
     }
     popMatrix();
    }
  }
  
  
  
}