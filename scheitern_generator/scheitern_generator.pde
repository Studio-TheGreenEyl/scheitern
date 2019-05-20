import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

// globals
int FPS = 30; // fps
int countInterval;
String[] input;

// bubbles
ArrayList<Bubble> bubbles = new ArrayList<Bubble>();
IntList onDisplay; 
IntList leaving; 
int interval = 0;
long timestamp;
int index = 0;
int lineWeight = 4;
boolean bubblesInitialized = false;


// state machine
int state = 0;
boolean stateFinished = false;
boolean doNext = false;

// animation variables
int bubbleInterval = 30; //15; //500;
float animationLength = 2.2; // in seconds

// typography
PFont font;
PFont font2;
int fontSize = 40;
int specificWidth = 1900;
int textWidth = 1200;
float lineSpacing = 2.5;
float textLeading = 2.5;
int margin = 15;
int theFrames=0;

boolean recordVideo = true;

PImage gradient;

void setup() {
  size(1920, 1080); // endformat
  
  specificWidth = width-margin*2;
   
  onDisplay = new IntList();
  leaving = new IntList();
    
  timestamp = theFrames;
  font = loadFont("fonts/NeueWeimarGrotesk-Regular-40.vlw");
  font2 = loadFont("fonts/NeueWeimarGrotesk-Regular-20.vlw");
  textFont(font, fontSize);
  textLeading(fontSize+textLeading);
  bubblesInitialized = false;
  
  
  Ani.init(this);
  Ani.setDefaultTimeMode(Ani.FRAMES);
  
  gradient = loadImage("gradient.png");
  theFrames = 0;
}

void draw() {
  background(0);
  
  // end of program
  
  
  stateMachine();
  //image(gradient, 0,0);
  if(stateFinished) println("\n[!!!] FORWARDING STATE\n");
  
  if (recordVideo){
    saveFrame("export/Scheitern_"+nf(theFrames,6)+".tga");
    theFrames++;
    if(recordVideo) {
      push();
      stroke(255,0,0);
      noFill();
      rect(2,2,width-5,height-5);
      pop();
    }
  }
}
