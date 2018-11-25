int centerX;
int centerY;

float ratio = 0.97;
int axes = 50;
float radius = 60;
float radiusMultiplier = 1.045;
int dpf = 1000;

float ratioIncrement = 0.01;
int dpfIncrement = 50;
int fallbackDpf = 0;
float orientation;
boolean orientationToggle = false;

boolean running = false;
color defaultColor = color(255);
color currentColor = defaultColor;

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
  stroke(currentColor);
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
  stroke(defaultColor);
  fill(20);
  rect(15, 15, 190, 165);
  fill(255);
  text(
    String.format("Ratio: %s\nAxes: %s\nRadius: %.1f\nMultiplier: %.3f\nDensity: %s", 
    String.format("%.3f", ratio), 
    axes, 
    radius, 
    radiusMultiplier, 
    dpf), 
    30, 45);
  stroke(currentColor);
}

void setOrientation() {
  orientation = radians(90 + (orientationToggle ? 180.0 / axes : 0));
}

void setCorners() {
  Dot[] temp = new Dot[axes];
  setOrientation();
  float rad = radians(360.0 / axes);
  for (int i = 0; i < axes; i++) {
    float angle = i * rad;
    temp[i] = new Dot(
      centerX + cos(angle - orientation) * radius, 
      centerY + sin(angle - orientation) * radius);
  }
  corners = temp;
  previousDot = corners[0];
}

Dot getRandomCorner() {
  return corners[(int) random(axes)];
}

Dot calcNewDot(Dot previous, Dot corner) {
  float x = (corner.x - previous.x) * ratio;
  float y = (corner.y - previous.y) * ratio;
  return new Dot(previous.x + x, previous.y + y);
}

color randomColor() {
  return color(randomRGB(), randomRGB(), randomRGB());
}

int randomRGB() {
  return (int) random(256);
}

void keyPressed() {
  if (key == ' ') {
    running = !running;
  } else if (keyCode == UP) {
    addRatio();
  } else if (keyCode == DOWN) {
    subtractRatio();
  } else if (keyCode == LEFT) {
    subtractCorner();
  } else if (keyCode == RIGHT) {
    addCorner();
  } else if (key == 'l') {
    addRadiusMultiplier();
  } else if (key == 'k') {
    subtractRadiusMultiplier();
  } else if (key == 'n') {
    divideRadius();
  } else if (key == 'm') {
    multiplyRadius();
  } else if (key == '-') {
    subtractRadius();
  } else if (key == '+') {
    addRadius();
  } else if (key == '.') {
    addDensity();
  } else if (key == ',') {
    subtractDensity();
  } else if (key == 'o') {
    toggleOrientation();
  } else if (key == 'p') {
    pause();
  } else if (key == 'c') {
    setRandomColor();
  } else if (key == 'w') {
    setDefaultColor();
  } else if (key == 'x') {
    runScript();
  } else {
    return;
  }
  loop();
}

void addCorner() {
  axes++;
  setCorners();
}

void subtractCorner() {
  if (axes > 3) {
    axes--;
    setCorners();
  }
}

void addRatio() {
  ratio += ratioIncrement;
}

void subtractRatio() {
  if (ratio > ratioIncrement) {
    ratio -= ratioIncrement;
  }
}

void addRadius() {
  radius++;
  setCorners();
}

void subtractRadius() {
  if (radius > 1) {
    radius--;
    setCorners();
  }
}

void multiplyRadius() {
  radius *= radiusMultiplier;
  setCorners();
}

void divideRadius() {
  radius /= radiusMultiplier;
  setCorners();
}

void addRadiusMultiplier() {
  radiusMultiplier += 0.01;
}

void subtractRadiusMultiplier() {
  radiusMultiplier -= 0.01;
}

void addDensity() {
  if (dpf != 0) {
    dpf += dpfIncrement;
  }
}

void subtractDensity() {
  if (dpf > dpfIncrement) {
    dpf -= dpfIncrement;
  }
}

void toggleOrientation() {
  orientationToggle = !orientationToggle;
  setCorners();
}

void pause() {
  int temp = dpf;
  dpf = fallbackDpf;
  fallbackDpf = temp;
}

void setRandomColor() {
  currentColor = randomColor();
  stroke(currentColor);
}

void setDefaultColor() {
  currentColor = color(255);
  stroke(currentColor);
}

void runScript() {
  if (axes > 3) {
    pause();
    toggleOrientation();
    multiplyRadius();
    // setRandomColor();
    subtractCorner();
    pause();
    redraw();
  }
}
