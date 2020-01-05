
// A growing strand/path
class Strand {
  ArrayList<PVector> rs = new ArrayList<PVector>();
  ArrayList<PVector> ts = new ArrayList<PVector>();

  float l = 0.0; // Current length
  float L = 200.0; // Maximum length

  float l_s = 10.0; // Length of each segment

  float dl = 1.0; // Growth increment

  float k; // curvature
  PVector w;

  color DrawColor = color(0);
  float LineThickness = 1.0;
  float GrowthSpeed = 1.0;
  
  // Changing these changes the shape of the plant
  float CurvatureAmount = 0.1;
  float InitialAngleVariation = 0.1;
  
  // Base thickness/placement
  float InitialPositionSpread = 0.05;
    
    
  Strand(float InitialAngle, color Color, float Thickness, float GrowthSpeed, float MaxLength) {
    DrawColor = Color;
    LineThickness = Thickness;
    dl = GrowthSpeed;
    L = MaxLength;

    // Setup angular rotation (curvature along path)
    w = new PVector(0.0, 0.0, 0.0);
    k = CurvatureAmount*(random(1.0)-0.5);
    w.z = k;

    // Initial position and tangent    
    PVector r, t;
    float angle = InitialAngleVariation*random(-PI, PI) + InitialAngle;
    r = new PVector(InitialPositionSpread*random(-width, width), 0.0f);

    // Tangent
    t = new PVector(cos(angle), sin(angle));
    t.mult(l_s);

    rs.add(r);
    ts.add(t);
  }

  void Grow() {
    // increase the length
    if (l<L)
      l += dl;
    // deal with the consequences
    int n = (int)(l/l_s); // number of segments required for this length
    //float ln = l%l_s; // length on the segment

    //println("l: " + l + " n: " + n + " N:" + rs.size());
    if (n==rs.size()) {
      PVector rn = rs.get(rs.size()-1).copy();
      // Step tanget and position foward
      PVector tn = ts.get(ts.size()-1).copy();
      tn.add(w.cross(tn));
      rn.add(tn);
      //println("rn: " + rn + " tn: " + tn + " w: " + w);
      // Add to array list
      rs.add(rn);
      ts.add(tn);
    }
  }

  void Draw() {
    int n = (int)(l/l_s); // number of segments required for this length
    float ln = l%l_s; // length on the segment 
    float scale = ln/l_s;
    for (int i=0; i<(rs.size()); i++) {  
      //fill(0);
      //noStroke();
      //ellipse(r[i].x, r[i].y, 5, 5);
      //float frac = (float)i/(float)rs.size();
      stroke(DrawColor);
      strokeWeight(LineThickness*(rs.size()-i));

      if (i<n) {
        PVector p0 = rs.get(i).copy();
        PVector p1 = rs.get(i).copy().add(ts.get(i));
        //PVector p1 = rs.get(i).copy();
        line(p0.x, p0.y, p1.x, p1.y);
      } else {
        PVector p0 = rs.get(i).copy();
        //PVector p1 = rs.get(i).copy().add(ts.get(i));

        PVector t = ts.get(i).copy();        
        t.mult(scale);
        //println("scale: " +scale);

        PVector p1 = p0.copy();
        p1.add(t);

        line(p0.x, p0.y, p1.x, p1.y);
      }
    }
  }
}


ArrayList<Strand> Strands = new ArrayList<Strand>();

void setup() {
  size(1000, 1000);
  background(255);

  int N_top = 64;
  //float top_growth_speed =  0.4 + random(0.5);
  float max_length = random(200, 300);
  for (int i=0; i<N_top; i++) {
    Strands.add( new Strand(PI/2, color(random(30)), 0.6, 0.4 + random(0.5), random(300, 500)) );
  }
  int N_bottom = 64;
  //float bottom_growth_speed =  0.2 + random(0.2);
  //bottom_growth_speed = top_growth_speed;
  for (int i=0; i<N_bottom; i++) {
    Strands.add( new Strand(-PI/2, color(255), 0.1, 0.4 + random(0.5), random(200, 400)) );
  }

  frameRate(60);
}

void draw() {
  background(255);

  fill(0);
  rect(0, height/2, width, height);

  translate(width/2, height/2);
  scale(1, -1);

  for (int i=0; i<Strands.size(); i++) {
    Strands.get(i).Grow();
    Strands.get(i).Draw();
  }

  //saveFrame("grow_dynamic-####.png");
  //noLoop();
}
