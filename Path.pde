/*
Encompasses: The Path for Balloons, Balloon Movement
 */

// ------- CODE FOR THE PATH
ArrayList<ArrayList<ArrayList<PVector>>> paths = new ArrayList<ArrayList<ArrayList<PVector>>>();
ArrayList<ArrayList<PVector>> pathSegments;

final int start = 0, end = 1;
final int startArc = 0, centerArc = 1, endArc = 2, arcValues = 3;
final int numPaths = 6;
final int PATH_RADIUS = 15;
float[] pathLengths = new float[numPaths];

void initPoints() {
  for (int i = 0; i < numPaths; i++)
    paths.add(new ArrayList<ArrayList<PVector>>());

  /* ----- PATH 1 ---- */
  addDirectedLine(0, 250, 90, 360, 0);
  addArc(0, -1, -1, 450, 150, radians(55));
  addArc(0, -1, -1, 650, -100, -radians(10));
  addArc(0, -1, -1, 450, 150, -radians(53));
  addArc(0, -1, -1, 650, 400, radians(43.9));
  addDirectedLine(0, -1, -1, 300, 0);
  addArc(0, -1, -1, 1034, 200, radians(55));
  addArc(0, -1, -1, 1234, -50, -radians(10));
  addArc(0, -1, -1, 1034, 200, -radians(56));
  addArc(0, -1, -1, 1234, 450, radians(45.6));
  addDirectedLine(0, -1, -1, 200, 0);
  //////////////////////////////    DONE    ///////////////////////////////


  /* ----- PATH 2 ----- */
  addDirectedLine(1, 250, 360, 150, 0);
  addDirectedLine(1, -1, -1, 150, -HALF_PI);
  addDirectedLine(1, -1, -1, 210, 0);
  addArc(1, -1, -1, 450, 150, -radians(55));
  addArc(1, -1, -1, 650, 400, radians(10));
  addArc(1, -1, -1, 450, 150, radians(53));
  addArc(1, -1, -1, 650, -100, -radians(43.9));
  addDirectedLine(1, -1, -1, 100, 0);
  addDirectedLine(1, -1, -1, 250, HALF_PI);
  addDirectedLine(1, -1, -1, 50, 0);
  addDirectedLine(1, -1, -1, 125, HALF_PI);
  addDirectedLine(1, -1, -1, 100, 0);
  addSmoothArc(1, -82.5, -HALF_PI);
  addDirectedLine(1, -1, -1, 150, 0);
  addArc(1, -1, -1, 1250, 490, radians(60));
  addArc(1, -1, -1, 1400, 220, -radians(48));
  addDirectedLine(1, -1, -1, 50, 0);



  /* ----- PATH 3 ----- */
  addDirectedLine(2, 250, 90, 260, 0);
  addDirectedLine(2, -1, -1, 500, HALF_PI);
  addDirectedLine(2, -1, -1, 75, 0);
  addDirectedLine(2, -1, -1, 150, HALF_PI);
  addDirectedLine(2, -1, -1, 100, 0);
  addSmoothArc(2, -90, -HALF_PI);
  addDirectedLine(2, -1, -1, 500, 0);
  addDirectedLine(2, -1, -1, 110, -HALF_PI);
  addDirectedLine(2, -1, -1, 100, 0);
  addArc(2, -1, -1, 1250, 490, -radians(60));
  addArc(2, -1, -1, 1400, 760, radians(48));
  addDirectedLine(2, -1, -1, 50, 0);



  /* ----- PATH 4 ----- */
  addDirectedLine(3, 250, 360, 150, 0);
  addDirectedLine(3, -1, -1, 350, HALF_PI);
  addDirectedLine(3, -1, -1, 185, 0);
  addDirectedLine(3, -1, -1, 150, -HALF_PI);
  addDirectedLine(3, -1, -1, 100, 0);
  addSmoothArc(3, 90, HALF_PI);
  addDirectedLine(3, -1, -1, 500, 0);
  addDirectedLine(3, -1, -1, 110, -HALF_PI);
  addDirectedLine(3, -1, -1, 100, 0);
  addArc(3, -1, -1, 1250, 490, -radians(60));
  addArc(3, -1, -1, 1400, 760, radians(48));
  addDirectedLine(3, -1, -1, 50, 0);



  /* ----- PATH 5 ----- */
  addDirectedLine(4, 250, 485, 794, 0);
  addDirectedLine(4, -1, -1, 125, -HALF_PI);
  addDirectedLine(4, -1, -1, 100, 0);
  addSmoothArc(4, 82.5, HALF_PI);
  addDirectedLine(4, -1, -1, 150, 0);
  addArc(4, -1, -1, 1250, 490, radians(60));
  addArc(4, -1, -1, 1400, 220, -radians(48));
  addDirectedLine(4, -1, -1, 50, 0);



  /* ----- PATH 6 ----- */
  addDirectedLine(5, 250, 485, 644, 0);
  addDirectedLine(5, -1, -1, 225, -HALF_PI);
  addDirectedLine(5, -1, -1, 300, 0);
  addArc(5, -1, -1, 1034, 200, -radians(55));
  addArc(5, -1, -1, 1234, 450, radians(10));
  addArc(5, -1, -1, 1034, 200, radians(56));
  addArc(5, -1, -1, 1234, -50, -radians(45.6));
  addDirectedLine(5, -1, -1, 100, 0);
  ////////////////////////////////////    DONE   ////////////////////////////////////
}

void addLine(int pathNum, float startX, float startY, float endX, float endY) {
  pathSegments = paths.get(pathNum);
  pathSegments.add(new ArrayList<PVector>());

  //If the line should continue from the existing path
  if (startX == -1 && startY == -1) {
    ArrayList<PVector> pathSegment = pathSegments.get(pathSegments.size()-2);
    //If the previous path segment was a line
    if (pathSegment.size() == 2) {
      startX = pathSegment.get(end).x;
      startY = pathSegment.get(end).y;
    }
    //If the previous path segment was an arc
    else {
      startX = pathSegment.get(endArc).x;
      startY = pathSegment.get(endArc).y;
    }
  }

  pathSegments.get(pathSegments.size()-1).add(new PVector(startX, startY));
  pathSegments.get(pathSegments.size()-1).add(new PVector(endX, endY));
}

void addArc(int pathNum, float x, float y, float centerX, float centerY, float displacementAngle) {
  pathSegments = paths.get(pathNum);
  pathSegments.add(new ArrayList<PVector>());

  //If the line should continue from the existing path
  if (x == -1 && y == -1) {
    ArrayList<PVector> pathSegment = pathSegments.get(pathSegments.size()-2);
    //If the previous path segment was a line
    if (pathSegment.size() == 2) {
      x = pathSegment.get(end).x;
      y = pathSegment.get(end).y;
    }
    //If the previous path segment was an arc
    else {
      x = pathSegment.get(endArc).x;
      y = pathSegment.get(endArc).y;
    }
  }

  float startingAngle = atan2(y-centerY, x-centerX); //Starting angle
  float radius = dist(x, y, centerX, centerY); //radius of the arc
  float finalAngle = startingAngle + displacementAngle; //Angle that will determine where the end coordinates are for the arc

  pathSegments.get(pathSegments.size()-1).add(new PVector(x, y));
  pathSegments.get(pathSegments.size()-1).add(new PVector(centerX, centerY));
  pathSegments.get(pathSegments.size()-1).add(new PVector(centerX+radius*cos(finalAngle), centerY+radius*sin(finalAngle)));
  pathSegments.get(pathSegments.size()-1).add(new PVector(startingAngle, displacementAngle, radius));
  paths.set(pathNum, pathSegments);
}

void addSmoothArc(int pathNum, float distanceAway, float displacementAngle) {
  pathSegments = paths.get(pathNum);
  PVector endPoint;
  PVector directionVector;
  ArrayList<PVector> pathSegment = pathSegments.get(pathSegments.size()-1);

  if (pathSegment.size() == 2) {
    PVector startPoint = pathSegment.get(start);
    endPoint = pathSegment.get(end);

    float scaleFactor = dist(startPoint.x, startPoint.y, endPoint.x, endPoint.y);

    directionVector = new PVector(-(endPoint.y-startPoint.y)*distanceAway/scaleFactor, (endPoint.x-startPoint.x)*distanceAway/scaleFactor);
  } else {
    PVector centerPoint = pathSegment.get(centerArc);
    endPoint = pathSegment.get(endArc);

    float scaleFactor = dist(centerPoint.x, centerPoint.y, endPoint.x, endPoint.y) * pathSegment.get(arcValues).y/abs(pathSegment.get(arcValues).y);

    directionVector = new PVector((centerPoint.x-endPoint.x)*distanceAway/scaleFactor, (centerPoint.y-endPoint.y)*distanceAway/scaleFactor);
  }

  addArc(pathNum, -1, -1, endPoint.x+directionVector.x, endPoint.y+directionVector.y, displacementAngle);
}

void addSmoothLine(int pathNum, int steps) {
  pathSegments = paths.get(pathNum);
  ArrayList<PVector> pathSegment = pathSegments.get(pathSegments.size()-1);
  PVector centerPoint = pathSegment.get(centerArc);
  PVector endPoint = pathSegment.get(endArc);

  float scaleFactor = dist(centerPoint.x, centerPoint.y, endPoint.x, endPoint.y) * pathSegment.get(arcValues).y/abs(pathSegment.get(arcValues).y);
  PVector directionVector = new PVector(-(endPoint.y-centerPoint.y)/scaleFactor, (endPoint.x-centerPoint.x)/scaleFactor);
  directionVector = PVector.mult(directionVector, steps);

  addLine(pathNum, -1, -1, endPoint.x+directionVector.x, endPoint.y+directionVector.y);
}

void addDirectedLine(int pathNum, float startX, float startY, float radius, float direction) {
  pathSegments = paths.get(pathNum);
  pathSegments.add(new ArrayList<PVector>());

  //If the line should continue from the existing path
  if (startX == -1 && startY == -1) {
    ArrayList<PVector> pathSegment = pathSegments.get(pathSegments.size()-2);
    //If the previous path segment was a line
    if (pathSegment.size() == 2) {
      startX = pathSegment.get(end).x;
      startY = pathSegment.get(end).y;
    }
    //If the previous path segment was an arc
    else {
      startX = pathSegment.get(endArc).x;
      startY = pathSegment.get(endArc).y;
    }
  }

  float endX = startX + cos(direction)*radius;
  float endY = startY + sin(direction)*radius;

  pathSegments.get(pathSegments.size()-1).add(new PVector(startX, startY));
  pathSegments.get(pathSegments.size()-1).add(new PVector(endX, endY));
  paths.set(pathNum, pathSegments);
}

void addSuddenArc(int pathNum, float distanceAway, float angle) {
  pathSegments = paths.get(pathNum);
  ArrayList<PVector> pathSegment = pathSegments.get(pathSegments.size()-1);

  PVector lineStart = pathSegment.get(start);
  PVector lineEnd = pathSegment.get(end);

  float scaleFactor = dist(lineStart.x, lineStart.y, lineEnd.x, lineEnd.y);
  float xDisplacement = lineEnd.x-lineStart.x;
  float yDisplacement = lineEnd.y-lineStart.y;

  addArc(pathNum, -1, -1, lineEnd.x+xDisplacement/scaleFactor*distanceAway, lineEnd.y+yDisplacement/scaleFactor*distanceAway, angle);
}


void initPath() {  
  initPoints();
  for (int j = 0; j < paths.size(); j++) {
    pathSegments = paths.get(j);
    for (int i = 0; i < pathSegments.size(); i++) {
      ArrayList<PVector> pathSegment = pathSegments.get(i); 
      PVector point1 = pathSegment.get(0);
      PVector point2 = pathSegment.get(1);

      if (pathSegment.size() == 4) {
        pathLengths[j] += abs(pathSegment.get(arcValues).y * pathSegment.get(arcValues).z);
      } else {
        pathLengths[j] += dist(point1.x, point1.y, point2.x, point2.y);
      }
    }
  }
}

void drawPath() {
  noFill();
  stroke(#4C6710);
  strokeWeight(PATH_RADIUS * 2 + 1);
  ellipseMode(CENTER);
  for (int j = 0; j < paths.size(); j++) {
    pathSegments = paths.get(j);
    for (int i = 0; i < pathSegments.size(); i++) {
      ArrayList<PVector> pathSegment = pathSegments.get(i);
      PVector point2 = pathSegment.get(end);
      if (pathSegment.size() == 2) {
        PVector point1 = pathSegment.get(start);
        line(point1.x, point1.y, point2.x, point2.y);
      } else {
        PVector arcData = pathSegment.get(arcValues);
        float angle1;
        float angle2;
        if (arcData.y <= 0) {
          angle1 = arcData.x+arcData.y;
          angle2 = arcData.x;
        } else {
          angle2 = arcData.x+arcData.y;
          angle1 = arcData.x;
        }
        arc(point2.x, point2.y, arcData.z*2, arcData.z*2, angle1, angle2);
      }
    }

    stroke(#7b9d32);
    strokeWeight(PATH_RADIUS * 2);
    for (int i = 0; i < pathSegments.size(); i++) {
      ArrayList<PVector> pathSegment = pathSegments.get(i);
      PVector point2 = pathSegment.get(end);
      if (pathSegment.size() == 2) {
        PVector point1 = pathSegment.get(start);
        line(point1.x, point1.y, point2.x, point2.y);
      } else {
        PVector arcData = pathSegment.get(arcValues);
        float angle1;
        float angle2;
        if (arcData.y <= 0) {
          angle1 = arcData.x+arcData.y;
          angle2 = arcData.x;
        } else {
          angle2 = arcData.x+arcData.y;
          angle1 = arcData.x;
        }
        arc(point2.x, point2.y, arcData.z*2, arcData.z*2, angle1, angle2);
      }
    }
  }
}

//HashMap<Float, PVector> dp = new HashMap<Float, PVector>();
// GIVEN TO PARTICIPANTS BY DEFAULT
PVector getLocation(int pathNum, float travelDistance)
{
  //PVector memoized = dp.get(travelDistance);

  //if (memoized != null) {
  //  return memoized;
  //}

  //float originalDist = travelDistance;

  float distance;
  PVector point1;
  PVector point2;

  pathSegments = paths.get(pathNum);
  for (int i = 0; i < pathSegments.size(); i++) {
    ArrayList<PVector> pathSegment = pathSegments.get(i);
    point1 = pathSegment.get(0);
    point2 = pathSegment.get(1);
    distance = dist(point1.x, point1.y, point2.x, point2.y);

    if (pathSegment.size() == 4) {
      distance = abs(pathSegment.get(arcValues).y * pathSegment.get(arcValues).z);
    }
    if (distance <= EPSILON || travelDistance >= distance) {
      travelDistance -= distance;
    } else {
      // In between two pathSegments
      float x;
      float y;

      if (pathSegment.size() == 2) {
        float xDist = point2.x - point1.x;
        float yDist = point2.y - point1.y;
        float travelProgress = travelDistance / distance;
        x = point1.x + xDist * travelProgress;
        y = point1.y + yDist * travelProgress;
      } else {
        PVector arcData = pathSegment.get(arcValues);
        //initial angle  //radius
        float angle = arcData.x + ((1/arcData.z) * travelDistance * arcData.y/abs(arcData.y));

        x = point2.x + arcData.z*cos(angle);
        y = point2.y + arcData.z*sin(angle);
      }
      //dp.put(originalDist, new PVector(x, y));
      return new PVector(x, y);
    }
  }
  // At end of path
  ArrayList<PVector> lastPathSegment = pathSegments.get(pathSegments.size()-1);
  if (lastPathSegment.size() == 2) {
    //dp.put(originalDist, lastPathSegment.get(end));
    return lastPathSegment.get(end);
  } else {
    //dp.put(originalDist, lastPathSegment.get(endArc));
    return lastPathSegment.get(endArc);
  }
}
