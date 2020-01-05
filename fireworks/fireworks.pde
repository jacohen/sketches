ArrayList<Particle> ps = new ArrayList<Particle>();

color [] Colours = {color(248, 42, 99), color(119, 55, 205), color(255, 254, 235), color(145, 171, 255), color(196, 235, 208), color(231,133,93), color(119,203,143)}; 

public class Fuse {
  public float Length = 10.0;
  public float Position = 10.0;
  public Fuse() {
  }
}

class Particle {
  PVector r;
  PVector v;
  PVector a;

  Fuse [] Fuses;

  int NumberOfStages = 4;
  int Stage = 0;

  color [] StageColors;

  Particle() {
    r = new PVector(0.0, 0.0);
    v = new PVector(0.0, 0.0);
    a = new PVector(0.0, 0.0);

    Fuses = new Fuse[NumberOfStages];
    Fuses[0] = new Fuse();
    Fuses[0].Length = 2.0;
    Fuses[0].Position = 2.0;

    Fuses[1] = new Fuse();
    float TakeOffFuse = random(5.0,15.0);
    Fuses[1].Length = TakeOffFuse;
    Fuses[1].Position = TakeOffFuse;

    Fuses[2] = new Fuse();
    Fuses[2].Length = 10.0;
    Fuses[2].Position = 10.0;

    Fuses[3] = new Fuse();
    Fuses[3].Length = 20.0;
    Fuses[3].Position = 20.0;

    StageColors = new color[NumberOfStages];
  }

  void Update() {

    // If the fuse for this stage has burnt out, move to next stage

    if (Fuses[Stage].Position<0.0) {      
      Stage++; 

      if (Stage==1) {
        float v0 = 45.0;
        float a0 = PI/2.5;

        a0 = PI/2+0.1*random(-PI/2, PI/2);

        v.x = v0 * cos(a0);
        v.y = v0 * sin(a0);
      } else
        if (Stage==2) {
          // Setup Stage 2
          //color StageColor = Colours[(int)random(Colours.length)];
          for (int i=0; i<50; i++) {
            Particle pn = new Particle();
            pn.Stage = Stage;

            // Copy forward stage colours (this is stupid)
            for (int j=0; j<NumberOfStages; j++) {
              pn.StageColors[j] = StageColors[j];
            }

            float rangle = random(-PI, PI);
            pn.r.x = r.x;
            pn.r.y = r.y;
            float v0 = random(random(2,10), 10);
            pn.v.x = v.x + v0 * cos (rangle);
            pn.v.y = v.y + v0 * sin (rangle);
            ps.add(pn);
          }
        } else if (Stage==3) {
          // Setup Stage 2
          //color StageColor = Colours[(int)random(Colours.length)];
          for (int i=0; i<25; i++) {
            Particle pn = new Particle();
            pn.Stage = Stage;
            // Copy forward stage colours (this is stupid)
            for (int j=0; j<NumberOfStages; j++) {
              pn.StageColors[j] = StageColors[j];
            }
            float rangle = random(-PI, PI);
            pn.r.x = r.x;
            pn.r.y = r.y;
            float v0 = random(random(2,10), 10);
            pn.v.x = v.x + v0 * cos (rangle);
            pn.v.y = v.y + v0 * sin (rangle);
            ps.add(pn);
          }
        }
      // Remove the current particle
      if (Stage>1)
        ps.remove(this);
    }
  }

  void Draw() {
    noStroke();
    if (Stage==0) {
      fill(90);
      ellipse(r.x, r.y, 10, 10);
    } else if (Stage==1) {
      color StageColor = StageColors[Stage];
      fill(StageColor, 200);
      ellipse(r.x, r.y, 8, 8);
    } else if (Stage==2) {
      //println(red(StageColors[Stage])+","+green(StageColors[Stage])+","+blue(StageColors[Stage]));
      color StageColor = StageColors[Stage];
      fill(StageColor, max(10, 255*Fuses[Stage].Position/Fuses[Stage].Length));
      ellipse(r.x, r.y, 5, 5);
    } else if (Stage==3) {
      color StageColor = StageColors[Stage];
      fill(StageColor, 255*Fuses[Stage].Position/Fuses[Stage].Length);
      ellipse(r.x, r.y, 3, 3);
      //fill(StageColor);
      //ellipse(r.x, r.y, 2, 2);
    }

    //stroke(255, 0, 0);
    // line(r.x, r.y, r.x + v.x, r.y+v.y);
  }
}

color bg = color(0, 6, 33);

float dt = 0.1;

void setup() {
  size(600, 600);
  background(bg);

  for (int i=0; i<10; i++) {
    Particle pn = new Particle();

    pn.r.x = random(-100, 100);
    pn.r.y = 0.0;

    float Fuse = random(5, 80);
    pn.Fuses[0].Length = Fuse;
    pn.Fuses[0].Position = Fuse;

    for (int j=0; j<pn.NumberOfStages; j++) {
      int ci = (int)random(Colours.length);
      pn.StageColors[j] = Colours[ci];
      //println("j/ci:"+j+"/"+ci+"/("+red(pn.StageColors[j])+","+green(pn.StageColors[j])+","+blue(pn.StageColors[j]));
    }
    pn.StageColors[0] = color(100);

    ps.add(pn);
  }
}

void Update() {
  for (int i=0; i<ps.size(); i++) {
    if (ps.get(i).Stage>0) {
      ps.get(i).a.x = 0.0;
      ps.get(i).a.y = -2.0;
    }
  }

  for (int i=0; i<ps.size(); i++) {
    Particle p = ps.get(i);    
    p.r.x += p.v.x*dt + 0.5*p.a.x*dt*dt;
    p.r.y += p.v.y*dt + 0.5*p.a.y*dt*dt;
    p.v.x += p.a.x*dt;
    p.v.y += p.a.y*dt;
    p.Fuses[p.Stage].Position-=dt;
  }

  for (int i=0; i<ps.size(); i++) {
    ps.get(i).Update();
  }
}

void draw() {
  //background(20);
  fill(bg, 5);
  rect(0, 0, width, height);
  translate(0.5*width, height);
  scale(1, -1);

  Update();

  for (int i=0; i<ps.size(); i++) {
    ps.get(i).Draw();
  }
  //translate(-0.5*width,0);
  //ellipse(0,0,5,5);
  saveFrame("fw-####.png");
}
