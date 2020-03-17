// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for this video: https://youtu.be/BV9ny785UNc
// https://thecodingtrain.com/CodingChallenges/013-reactiondiffusion-p5.html

// Written entirely based on
// http://www.karlsims.com/rd.html

// online emulator
//http://mrob.com/pub/comp/xmorphia/ogl/index.html

// Also, for reference
// http://hg.postspectacular.com/toxiclibs/src/44d9932dbc9f9c69a170643e2d459f449562b750/src.sim/toxi/sim/grayscott/GrayScott.java?at=default

//http://groups.csail.mit.edu/mac/projects/amorphous/GrayScott/

Cell[][] grid;
Cell[][] prev;
float dA = 1.0;
float dB = 0.5;

int seedSize = 39;
int totalInitialSeeds = 0;

float feed = 0.110;
float k = 0.0523;

// animal cells
//float feed = 0.110;
//float k = 0.0523;

// plant cells
//float feed = 0.090;
//float k = 0.057;
// or
//float feed = 0.090;
//float k = 0.059;
// or
//float feed = 0.102;
//float k = 0.055;

// mazes (kappa)
//float feed = 0.029;
//float k = 0.057;

// coral pattern
//float feed = 0.0545;
//float k = 0.062;

// mitosis pattern -- seed size must be about 40 or more
//float feed = 0.0367;
//float k = 0.0649;

// Jennie - perpetual movement one
//float feed = 0.0141;
//float k = 0.0468;

// long worms
//float feed = 0.0541;
//float k = 0.065;

int diffusionWidth = 300;
int diffusionHeight = 300;

PImage diffusionImg = createImage(diffusionWidth, diffusionHeight, RGB);

void setup() {
  size(600, 600);
  
  noStroke();
  
  grid = new Cell[diffusionWidth][diffusionHeight];
  prev = new Cell[diffusionWidth][diffusionHeight];

  for (int i = 0; i < diffusionWidth; i++) {
    for (int j = 0; j < diffusionHeight; j ++) {
      float a = 1;
      float b = 0;
      grid[i][j] = new Cell(a, b);
      prev[i][j] = new Cell(a, b);
    }
  }
  
  for (int n = 0; n < totalInitialSeeds; n++) {
    int startX = int(random(seedSize, diffusionWidth-seedSize));
    int startY = int(random(seedSize, diffusionHeight-seedSize));

     addSeed(startX, startY);
  }
}

void mousePressed(){
  int targX = mouseX; 
  int targY = mouseY;
  
  addSeed(targX, targY);
}

// basic constructor
void addSeed(int startX, int startY){
 addSeed(startX, startY, seedSize, 1, 1);
}
// overloaded with more controls
void addSeed(int startX, int startY, int seedSize, float aValue, float bValue){
 float radius = seedSize / 2;
 int rectX = int(startX - radius);
 int rectY = int(startY - radius);
  
 for (int i = rectX; i < rectX+seedSize; i++) {
      for (int j = rectY; j < rectY+seedSize; j ++) {
        float a = aValue;
        float b = bValue;
        
        float distFromCenter = dist(rectX + radius, rectY + radius, i, j);
        
        if(distFromCenter <= radius 
            && i >= 0 
            && j >= 0
            && i < diffusionWidth
            && j < diffusionHeight){
          grid[i][j] = new Cell(a, b);
          prev[i][j] = new Cell(a, b);
        }
      }
    }
}

class Cell {
  float a;
  float b;

  Cell(float a_, float b_) {
    a = a_;
    b = b_;
  }
}


void update() {
  for (int i = 1; i < diffusionWidth-1; i++) {
    for (int j = 1; j < diffusionHeight-1; j ++) {

      Cell spot = prev[i][j];
      Cell newspot = grid[i][j];

      float a = spot.a;
      float b = spot.b;

      float laplaceA = 0;
      laplaceA += a*-1;
      laplaceA += prev[i+1][j].a*0.2; // right
      laplaceA += prev[i-1][j].a*0.2;
      laplaceA += prev[i][j+1].a*0.2;
      laplaceA += prev[i][j-1].a*0.2;
      
      laplaceA += prev[i-1][j-1].a*0.05; // above left 
      laplaceA += prev[i+1][j-1].a*0.05; // above right 
      laplaceA += prev[i-1][j+1].a*0.05; // below left
      laplaceA += prev[i+1][j+1].a*0.05; // below right 

      float laplaceB = 0;
      laplaceB += b*-1;
      
      laplaceB += prev[i+1][j].b*0.2; // right
      laplaceB += prev[i-1][j].b*0.2; // left
      laplaceB += prev[i][j+1].b*0.2; // below
      laplaceB += prev[i][j-1].b*0.2; // above
      
      laplaceB += prev[i-1][j-1].b*0.05; // above left 
      laplaceB += prev[i+1][j-1].b*0.05; // above right
      laplaceB += prev[i-1][j+1].b*0.05; // below left
      laplaceB += prev[i+1][j+1].b*0.05; // below right
      
      // slides diagonally to bottom right
      //laplaceB += prev[i-1][j-1].b*0.07; // above left 
      //laplaceB += prev[i+1][j-1].b*0.05; // above right
      //laplaceB += prev[i-1][j+1].b*0.05; // below left
      //laplaceB += prev[i+1][j+1].b*0.03; // below right
      
      // slides left to right
      //laplaceB += prev[i-1][j-1].b*0.06;
      //laplaceB += prev[i+1][j-1].b*0.04;
      //laplaceB += prev[i-1][j+1].b*0.06;
      //laplaceB += prev[i+1][j+1].b*0.04;
      
      // slides down the screen
      //laplaceB += prev[i-1][j-1].b*0.06;
      //laplaceB += prev[i+1][j-1].b*0.06;
      //laplaceB += prev[i-1][j+1].b*0.04;
      //laplaceB += prev[i+1][j+1].b*0.04;

      newspot.a = a + (dA*laplaceA - a*b*b + feed*(1-a))*1;
      newspot.b = b + (dB*laplaceB + a*b*b - (k+feed)*b)*1;

      newspot.a = constrain(newspot.a, 0, 1);
      newspot.b = constrain(newspot.b, 0, 1);
    }
  }
}

void swap() {
  Cell[][] temp = prev;
  prev = grid;
  grid = temp;
}

void draw() {
  //println(frameRate);
  //addSeed(width/2, height/2, seedSize, 1,1.1);

  for (int i = 0; i < 2; i++) {
    update();
    swap();
  }

  diffusionImg.loadPixels();
  for (int i = 1; i < diffusionWidth-1; i++) {
    for (int j = 1; j < diffusionHeight-1; j ++) {
      Cell spot = grid[i][j];
      float a = spot.a;
      float b = spot.b;
      int pos = i + j * diffusionWidth;
      diffusionImg.pixels[pos] = color((a-b)*255);
    }
  }
  diffusionImg.updatePixels();
  
  image(diffusionImg, 0, 0);
  
  // reflect right
  pushMatrix();
  scale(-1.0, 1.0);
  image(diffusionImg, -diffusionWidth*2, 0);
  popMatrix();
  
  // reflect below right
  pushMatrix();
  scale(1.0, -1.0);
  image(diffusionImg, 0, -diffusionHeight*2);
  popMatrix();
  
  // reflect below right
  pushMatrix();
  scale(-1.0, -1.0);
  image(diffusionImg, -diffusionWidth*2, -diffusionHeight*2);
  popMatrix();
  
  
  saveFrame("frames/tiles-######.tif");
}
