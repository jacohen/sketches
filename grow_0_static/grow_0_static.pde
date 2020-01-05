
class Strand {

  int Npoints = 16;
  PVector [] r;
  PVector [] t;
  float dl = 10.0;
  float k; // curvature
  PVector w;

  Strand() {

    r = new PVector[Npoints];
    t = new PVector[Npoints];

    // Init
    for (int i=0; i<Npoints; i++) {
      r[i] = new PVector();
      t[i] = new PVector();
    }

    w = new PVector();
    // w = new PVector();
    k = 0.05*(random(1.0)-0.5);

    float angle = 0.1*random(-PI, PI) + PI/2.0;
    r[0] = new PVector(0.5*random(-width,width), 0.0f);

    t[0] = new PVector(cos(angle), sin(angle));
    t[0].mult(dl);

    for (int i=0; i<(Npoints-1); i++) {
      t[i+1] = t[i].add(w.cross(t[i]));
      //println(t[i].mag());
      r[i+1] = r[i].copy().add(t[i]);
      w.z+=k;
    }
  }

  void Draw() {
    for (int i=0; i<(Npoints-1); i++) {  
      fill(0);
      noStroke();
      //ellipse(r[i].x, r[i].y, 5, 5);

      stroke(0);
      float frac = ((float)i)/((float)Npoints);
      strokeWeight(4.0*(1.0 - frac));
      line(r[i].x, r[i].y, r[i+1].x, r[i+1].y);
    }
  }
}

int Nstrands = 128;
Strand [] Strands = new Strand[Nstrands];

void setup() {
  size(600, 600);
  background(255);

  for (int i=0; i<Nstrands; i++) {
    Strands[i] = new Strand();
  }
}

void draw() {
  background(255);
  
  fill(0);
  rect(0,height/2,width,height);

  translate(width/2, height/2);
  scale(1, -1);

  for (int i=0; i<Nstrands; i++) {
    Strands[i].Draw();
  }
  
  saveFrame("grow.png");
  noLoop();
}
