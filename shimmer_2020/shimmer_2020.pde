PImage Img;

color bg = color(19, 14, 13);
color g0 = color(106, 55, 19);
color g1 = color(255, 219, 126);

color gd0 = color(64, 36, 20);
color gd1 = color(106, 55, 19);
color gl0 = color(226, 164, 90);
color gl1 = color(250, 249, 248);

int N = 21;
float [][] s = new float[21][21];

void setup() {
  size(600, 600);
  background(0);
  Img = loadImage("2020.png");  
  Img.loadPixels();
  frameRate(25);

  for (int i=0; i<N; i++) { 
    for (int j=0; j<N; j++) {
      s[i][j] = random(0.0, 1.0);
    }
  }
}

float t = 0.0;
float dt = 0.1;

void draw() {
  background(bg);

  float c = ((float)width)/((float)N);
  float r = 0.8;
  noStroke();
  //stroke(255);
  noFill();
  translate(r*c/2, r*c/2);

  for (int i=0; i<N; i++) { 
    for (int j=0; j<N; j++) { 
      float fade = 0.5*(1.0+sin(t+2.0*PI*s[i][j]));

      if (Img.pixels[i + j*N]==color(0))
        fill(lerpColor(gd0, gd1, fade));
      else 
        fill(lerpColor(gl0, gl1, fade));
        
      ellipse(c*i, c*j, (r-0.5+0.5*fade)*c, r*c);
      fill(0);
      ellipse(c*i, c*j-8, (r-0.5+0.5*fade)*5, (r-0.5+0.5*fade)*5);
    }
  }

  t += dt; 
  //saveFrame("sq-####.png");
}
