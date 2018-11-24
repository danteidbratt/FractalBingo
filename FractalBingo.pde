int centerX;
int centerY;

int numOfCorners = 3;

int radius = 256;
int radiusIncrement = 1;
float radiusMultiplier = 2;

float ratio = 0.5;
float ratioIncrement = 0.01;

int dpf = 1000;
int dpfIncrement = 50;
int fallbackDpf = 0;

float orientation;
boolean orientationToggle = false;

boolean running = false;

Dot[] corners;
Dot previousDot;
Dot newDot;

void setup() {
  frameRate(60);
  fullScreen();
  noCursor();
  textSize(20);
  centerX = width / 2;
  centerY = height / 2;
  background(20);
  stroke(255);
  fill(20);
  strokeWeight(1);
  setCorners();
}

void draw() {
  setBackground();
  generateDots();
  drawTextBox();
}

void setBackground() {
  if (!running) {
    background(20);
    noLoop();
  }
}

void generateDots() {
  for (int i = 0; i < dpf; i++) {
    generateDot();
  }
}

void generateDot() {
  newDot = calcNewDot(previousDot, getRandomCorner());
  newDot.place();
  previousDot = newDot;
}

void drawTextBox() {
  fill(20);
  rect(15, 15, 160, 135);
  fill(255);
  text(
    String.format("Ratio: %s\nAxes: %s\nRadius: %s\nDPF: %s", 
    String.format("%.2f", ratio), 
    numOfCorners, 
    radius, 
    dpf), 
    30, 45);
}

void setOrientation() {
  orientation = radians(90 + (orientationToggle ? 180.0 / numOfCorners : 0));
}

void setCorners() {
  Dot[] temp = new Dot[numOfCorners];
  setOrientation();
  float rad = radians(360.0 / numOfCorners);
  for (int i = 0; i < numOfCorners; i++) {
    float angle = i * rad;
    temp[i] = new Dot(
      centerX + cos(angle - orientation) * radius, 
      centerY + sin(angle - orientation) * radius);
  }
  corners = temp;
  previousDot = corners[0];
}

Dot getRandomCorner() {
  return corners[(int) random(numOfCorners)];
}

Dot calcNewDot(Dot previous, Dot corner) {
  float x = (corner.x - previous.x) * ratio;
  float y = (corner.y - previous.y) * ratio;
  return new Dot(previous.x + x, previous.y + y);
}

void pause() {
  int temp = dpf;
  dpf = fallbackDpf;
  fallbackDpf = temp;
}

void keyPressed() {
  if (key == ' ') {
    running = !running;
  } else if (keyCode == UP) {
    ratio += ratioIncrement;
  } else if (keyCode == DOWN) {
    if (ratio > ratioIncrement) {
      ratio -= ratioIncrement;
    }
  } else if (keyCode == LEFT) {
    if (numOfCorners > 3) {
      numOfCorners--;
      setCorners();
    }
  } else if (keyCode == RIGHT) {
    numOfCorners++;
    setCorners();
  } else if (key == 'd') {
    if (radius % radiusMultiplier == 0) {
      radius /= radiusMultiplier;
      setCorners();
    }
  } else if (key == 'm') {
    radius *= radiusMultiplier;
    setCorners();
  } else if (key == '-') {
    if (radius > radiusIncrement) {
      radius -= radiusIncrement;
      setCorners();
    }
  } else if (key == '+') {
    radius += radiusIncrement;
    setCorners();
  } else if (key == '.') {
    if (dpf != 0) {
      dpf += dpfIncrement;
    }
  } else if (key == ',') {
    if (dpf > dpfIncrement) {
      dpf -= dpfIncrement;
    }
  } else if (key == 'o') {
    orientationToggle = !orientationToggle;
    setCorners();
  } else if (key == 'p') {
    pause();
  }
  loop();
}
