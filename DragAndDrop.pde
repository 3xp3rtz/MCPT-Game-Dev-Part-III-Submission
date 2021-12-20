/*
Encompasses: Displaying Towers, Drag & Drop, Discarding Towers, Rotating Towers, Tower Validity Checking
 */
// -------- CODE FOR DRAG & DROP ----------------------


final color startButtonCol = color(17, 216, 42), 
  startButtonColPressed = color(132, 222, 143), 
  towerBarCol = color(160), 
  autoPlayButtonCol = color(37, 255, 23), 
  autoPlayButtonColPressed = color(115, 255, 106), 
  towerSlotBackground = color(175, 213, 216), 
  towerSlotBackgroundSelected = color(135, 175, 175);

int currentlyDragging = -1; // -1 = not holding any tower, 0 = within default, 1 = within eight, 2 = within slow
int unplaced = -1;
final int notDragging = -1;
final int def = 0, eight = 1, slow = 2, boomerang = 3, sniper = 4, bomb = 5;
final int towerCount = 6;
int difX, difY, count, towerClicked = -1;

boolean[] held = {false, false, false, false, false, false};
int[] towerPrice = {250, 450, 300, 1000, 300, 600};
color[] towerColours = {#7b9d32, #ff86dd, #86faff, #fff41a, #43892f, #666666};


PVector[] originalLocations = {
  new PVector(200/3.0, 200/3.0), 
  new PVector(550/3.0, 200/3.0), 
  new PVector(200/3.0, 550/3.0), 
  new PVector(550/3.0, 550/3.0), 
  new PVector(200/3.0, 300.0),
  new PVector(550/3.0, 300.0)};
// Constant, "copy" array to store where the towers are supposed to be

PVector[] dragAndDropLocations = {
  new PVector(200/3.0, 200/3.0), 
  new PVector(550/3.0, 200/3.0), 
  new PVector(200/3.0, 550/3.0), 
  new PVector(550/3.0, 550/3.0), 
  new PVector(200/3.0, 300.0),
  new PVector(550/3.0, 300.0)};
// Where the currently dragged towers are



ArrayList<PVector> towers; // Towers that are placed down


final int towerSize = 25;
final color towerErrorColour = #E30707; // Colour to display when user purchases tower without sufficient funds
//final color 
//these variables are the trash bin coordinates
int trashX1, trashY1, trashX2, trashY2;

void initDragAndDrop() {
  difX = 0;
  difY = 0;

  trashX1 = 0;
  trashY1 = 0;
  trashX2 = 250;
  trashY2 = height;

  count = 0;
  towers = new ArrayList<PVector>();
  towerData = new ArrayList<int[]>();
  spikeLocations = new ArrayList<PVector>();
  spikeData = new ArrayList<Integer>();
}



void drawTowerSlots() {
  for (int i = 0; i < 8; i++) {
    fill(buttonHovered() == i ? towerSlotBackgroundSelected : towerSlotBackground);
    if (i >= towerPrice.length) fill(138, 166, 166);
    roundRect(((i%2)+1)*100/6.0 + (i%2)*100, (((int)i/2)+1)*100/6.0 + ((int)i/2)*100, 100, 100, 20, 20);
  }
}

void drawTowerBar() {
  rectMode(CORNER);
  strokeWeight(2);
  stroke(0);
  fill(towerBarCol);
  rect(0, 0, 250, height);

  // start/auto play button
  fill(!playingLevel ? startButtonCol: color(startButtonColPressed, 127));
  roundRect(100.0/3, height-100, 75, 75, 25, 25);
  
  fill(!autoPlay ? autoPlayButtonCol: autoPlayButtonColPressed);
  roundRect(400.0/3, height-100, 75, 75, 25, 25, autoPlay ? color(255, 127) : 0);
  
  drawTowerSlots();

  fill(0);
  textAlign(CENTER, TOP);
  textSize(18);
  text("NEXT", 213.5/3, height-242.5/3);
  text("WAVE", 213.5/3, height-182.5/3);
  text("AUTO", 514.5/3, height-212.5/3);
}



// Use point to rectangle collision detection to check for mouse being within bounds of pick-up box
boolean pointRectCollision(float x1, float y1, float x2, float y2, float size) {
  //            --X Distance--               --Y Distance--
  return (abs(x2 - x1) <= size / 2) && (abs(y2 - y1) <= size / 2);
}

int buttonHovered() {
  for (int i = 0; i < towerPrice.length; i++) if (mouseX > ((i%2)+1)*100/6.0 + (i%2)*100 && mouseX < ((i%2)+1)*100/6.0 + ((i%2)+1)*100 && mouseY > (((int)i/2)+1)*100/6.0 + ((int)i/2)*100 && mouseY < (((int)i/2)+1)*100/6.0 + (((int)i/2)+1)*100) return i;
  for (int i = 0; i < towerPrice.length; i++) if (withinBounds(i)) return 10+i;
  for (int i = 0; i < 2; i++) if (mouseX > (100 + 300*i)/3.0 && mouseX < (100 + 300*i)/3.0 + 75 && mouseY > height-100 && mouseY < height-25) return i+100;
  return -1;
}

boolean withinBounds(int towerID) {
  PVector towerLocation = dragAndDropLocations[towerID];
  return pointRectCollision(mouseX, mouseY, towerLocation.x, towerLocation.y, towerSize);
}

//check if you drop in trash
boolean trashDrop(int towerID) {
  PVector location = dragAndDropLocations[towerID%10];
  if (location.x >= trashX1 && location.x <= trashX2 && location.y >= trashY1 && location.y <= trashY2) return true;
  return false;
}

// -------Methods Used for further interaction-------
void handleDrop(int towerID) { // Will be called whenever a tower is placed down
  // Instructions to check for valid drop area will go here
  if (trashDrop(towerID)) {
    dragAndDropLocations[towerID] = originalLocations[towerID];
    held[towerID] = false;
    unplaced = -1;
    //println("Dropped object in trash.");
  } else if (legalDrop(towerID)) {
    towers.add(dragAndDropLocations[towerID].copy());
    towerData.add(makeTowerData(towerID%10));
    dragAndDropLocations[towerID] = originalLocations[towerID];
    held[towerID] = false;
    unplaced = -1;
    purchaseTower(towerPrice[towerID]);
    //println("Dropped for the " + (++count) + "th time.");
    towerClicked = towers.size()-1;
  }
}

// Will be called whenever a tower is picked up
void handlePickUp(int pickedUpTowerID) {
  if (pickedUpTowerID == -1 || pickedUpTowerID >= 100) return;
  if (unplaced == -1 || pickedUpTowerID == unplaced) {
    if (pickedUpTowerID >= 10) {
      unplaced = (pickedUpTowerID%10)+10;
      currentlyDragging = pickedUpTowerID;
      held[currentlyDragging-10] = true;
      PVector location = dragAndDropLocations[pickedUpTowerID-10];
      difX = (int) location.x - mouseX; // Calculate the offset values (the mouse pointer may not be in the direct centre of the tower)
      difY = (int) location.y - mouseY;
    } else if (hasSufficientFunds(towerPrice[pickedUpTowerID])) {
      unplaced = (pickedUpTowerID%10)+10;
      currentlyDragging = pickedUpTowerID;
      held[currentlyDragging] = true;
      //PVector location = dragAndDropLocations[pickedUpTowerID];
      PVector location = new PVector(mouseX, mouseY);
      difX = (int) location.x - mouseX; // Calculate the offset values (the mouse pointer may not be in the direct centre of the tower)
      difY = (int) location.y - mouseY;
    } else unplaced = -1;
  }
  //println("Object picked up.");
}

//void dragAndDropInstructions() {
//  fill(#4C6710);
//  textSize(12);
//  text("Mouse X: " + mouseX + "\nMouse Y: " + mouseY + "\nMouse held: " + mousePressed + "\nTower Held: " + currentlyDragging + "\ntowerClicked: " + towerClicked, width-200, 20);
//}


// -------- CODE FOR PATH COLLISION DETECTION ---------

float pointDistToLine(PVector start, PVector end, PVector point) {
  // Code from https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
  float l2 = (start.x - end.x) * (start.x - end.x) + (start.y - end.y) * (start.y - end.y);  // i.e. |w-v|^2 -  avoid a sqrt
  if (l2 == 0.0) return dist(end.x, end.y, point.x, point.y);   // v == w case
  float t = max(0, min(1, PVector.sub(point, start).dot(PVector.sub(end, start)) / l2));
  PVector projection = PVector.add(start, PVector.mult(PVector.sub(end, start), t));  // Projection falls on the segment
  return dist(point.x, point.y, projection.x, projection.y);
}

float pointDistToArc(PVector start, PVector center, PVector end, PVector arcData, PVector point) {
  if (abs(arcData.y) < radians(360)) {
    float[] towerAngles = new float[2];
    towerAngles[0] = atan2(point.y-center.y, point.x-center.x) - arcData.x;

    if (towerAngles[0] < 0) {
      towerAngles[1] = towerAngles[0] + radians(360);
    } else if (towerAngles[0] > 0) {
      towerAngles[1] = towerAngles[0] - radians(360);
    } else {
      towerAngles[1] = 0;
    }

    for (float towerAngle : towerAngles) {
      float t = towerAngle/arcData.y;
      if (t >= 0 && t <= 1) {
        return abs(dist(point.x, point.y, center.x, center.y)-arcData.z);
      }
    }
  }
  return min(dist(point.x, point.y, start.x, start.y), dist(point.x, point.y, end.x, end.y));
}

float shortestDist(PVector point) {
  float answer = Float.MAX_VALUE;
  float distance = Float.MAX_VALUE;
  for (int j = 0; j < paths.size(); j++) {
    pathSegments = paths.get(j);
    for (int i = 0; i < pathSegments.size(); i++) {
      ArrayList<PVector> pathSegment = pathSegments.get(i);
      if (pathSegment.size() == 2) {
        PVector startPoint = pathSegment.get(start);
        PVector endPoint = pathSegment.get(end);
        distance = pointDistToLine(startPoint, endPoint, point);
      } else {
        PVector centerPoint = pathSegment.get(centerArc);
        PVector arcData = pathSegment.get(arcValues);
        if (dist(point.x, point.y, centerPoint.x, centerPoint.y) < arcData.z + 30) {
          PVector startPoint = pathSegment.get(startArc);
          PVector endPoint = pathSegment.get(endArc);
          distance = pointDistToArc(startPoint, centerPoint, endPoint, arcData, point);
        }
      }
      answer = min(answer, distance);
    }
  }
  return answer;
}

// Will return if a drop is legal by looking at the shortest distance between the rectangle center and the path.
boolean legalDrop(int towerID) {
  PVector heldLocation = dragAndDropLocations[towerID%10];
  // checking if this tower overlaps any of the already placed towers
  for (int i = 0; i < towers.size(); i++) {
    PVector towerLocation = towers.get(i);
    if (pointRectCollision(heldLocation.x, heldLocation.y, towerLocation.x, towerLocation.y, towerSize)) return false;
  }
  return shortestDist(heldLocation) > PATH_RADIUS;
}


// Checks if the location of the spike is on the path
boolean legalSpikeDrop() {
  PVector heldLocation = spikeLocation;
  return shortestDist(heldLocation) <= PATH_RADIUS;
}
