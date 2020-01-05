void setup() {
  size(600,600);
  background(255);
}

PVector ButterflyCurve(float t) {
  float a = exp(cos(t))-2.0*cos(4.0*t)-pow(sin(t/12.0),5.0);
  return new PVector(sin(t)*a, cos(t)*a);
}

float dt = 0.02;
float tmax = 12.0*PI;
float R = 80.0f;
float phi = 0.0;
void draw() {
  background(255);

  translate(width/2, height/2+50);
  scale(1.0,-1.0);
  
  strokeWeight(1.0);
  stroke(80);
  for (float t = 0.0; t<tmax;t+=dt) {
    PVector r = PVector.mult(ButterflyCurve(t+phi),R);
    PVector rn = PVector.mult(ButterflyCurve(t+dt+phi),R);
    
    line(r.x, r.y, rn.x, rn.y);   
  }
  
  phi+=0.1;
  //saveFrame("buttterfly_curve-####.png");
  //noLoop();
}
