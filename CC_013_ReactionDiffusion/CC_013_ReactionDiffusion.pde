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
int totalInitialSeeds = 20;

float feed = 0.0545;
float k = 0.062;

// plant cells
//float feed = 0.090;
//float k = 0.059;

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


void setup() {
  size(300, 300);
  grid = new Cell[width][height];
  prev = new Cell[width][height];

  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j ++) {
      float a = 1;
      float b = 0;
      grid[i][j] = new Cell(a, b);
      prev[i][j] = new Cell(a, b);
    }
  }
  
  for (int n = 0; n < totalInitialSeeds; n++) {
    int startX = int(random(seedSize, width-seedSize));
    int startY = int(random(seedSize, height-seedSize));

     addSeed(startX, startY, seedSize);
  }
}

void mousePressed(){
  int targX = mouseX; 
  int targY = mouseY;
  
  addSeed(targX, targY, seedSize);
}

void addSeed(int startX, int startY, int seedSize){
 float radius = seedSize / 2;
 int rectX = int(startX - radius);
 int rectY = int(startY - radius);
  
 for (int i = rectX; i < rectX+seedSize; i++) {
      for (int j = rectY; j < rectY+seedSize; j ++) {
        float a = 1;
        float b = 1;
        
        float distFromCenter = dist(rectX + radius, rectY + radius, i, j);
        
        if(distFromCenter <= radius 
            && i >= 0 
            && j >= 0
            && i < width
            && j < height){
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
  for (int i = 1; i < width-1; i++) {
    for (int j = 1; j < height-1; j ++) {

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
      
      //laplaceB += prev[i-1][j-1].b*0.05; // above left 
      //laplaceB += prev[i+1][j-1].b*0.05; // above right
      //laplaceB += prev[i-1][j+1].b*0.05; // below left
      //laplaceB += prev[i+1][j+1].b*0.05; // below right
      
      // slides diagonally to bottom right
      //laplaceB += prev[i-1][j-1].b*0.07; // above left 
      //laplaceB += prev[i+1][j-1].b*0.05; // above right
      //laplaceB += prev[i-1][j+1].b*0.05; // below left
      //laplaceB += prev[i+1][j+1].b*0.03; // below right
      
      // slides left to right
      laplaceB += prev[i-1][j-1].b*0.06;
      laplaceB += prev[i+1][j-1].b*0.04;
      laplaceB += prev[i-1][j+1].b*0.06;
      laplaceB += prev[i+1][j+1].b*0.04;
      
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
  
  addSeed(width/2, height/2, seedSize);

  for (int i = 0; i < 1; i++) {
    update();
    swap();
  }

  loadPixels();
  for (int i = 1; i < width-1; i++) {
    for (int j = 1; j < height-1; j ++) {
      Cell spot = grid[i][j];
      float a = spot.a;
      float b = spot.b;
      int pos = i + j * width;
      pixels[pos] = color((a-b)*255);
    }
  }
  updatePixels();
}
