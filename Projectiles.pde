// -------------- TEMPLATE CODE BEGINS ---------------- (Participants will NOT need to code anything below this line)

ArrayList<PVector> center = new ArrayList<PVector>(), velocity = new ArrayList<PVector>(); // Stores the location of each projectile and how fast it should move each frame
ArrayList<float[]> projectileData = new ArrayList<float[]>(); // Stores additional projectile data (unrelated to motion)
ArrayList<HashSet<Integer>> balloonsHit = new ArrayList<HashSet<Integer>>(); // Stores a list of balloons that each projectile has hit, so it doesn't hit the same balloon twice 
// For Participants: The HashSet data structure is like an ArrayList, but can tell you whether it contains a value or not very quickly
// The downside of HashSets is that there is no order or indexes, so you can't use it like a normal list
// Think of it like throwing items into an unorganized bin 

final int damage = 0, pierce = 1, angle = 2, currDistTravelled = 3, maxDistTravelled = 4, thickness = 5, dmgType = 6; // Constants to make accessing the projectileData array more convenient
final int projectileRadius = 11;

//changed values to help upgrades
float slowPercent = 0.7;

// Adds a new projectile
void createProjectile(PVector centre, PVector vel, float damage, int pierce, float maxDistTravelled, float thickness, int dmgType, int upgrade) {
  balloonsHit.add(new HashSet<Integer>()); // Adds an empty set to the balloonsHit structure - this represents the current projectile, not having hit any balloons yet.
  center.add(centre); // Adds the starting location of the projectile as the current location
  velocity.add(vel); // Adds the velocity of the projectile to the list
  float angle = atan2(vel.y, vel.x);
  projectileData.add(new float[]{damage, pierce, angle, 0, maxDistTravelled, thickness, dmgType, upgrade});
}

// Checks the distance from a point to a projectile using the pointDistToLine() method coded earlier
float distToProjectile(int projectileID, PVector point) {
  float[] data = projectileData.get(projectileID);
  float wid = cos(data[angle]), hgt = sin(data[angle]);
  PVector displacement = new PVector(wid, hgt).mult(projectileRadius);
  PVector start = PVector.add(center.get(projectileID), displacement), end = PVector.sub(center.get(projectileID), displacement);
  return pointDistToLine(start, end, point);
}

// Checks if a projectile is ready to be removed (is it off screen? has it already reached its maximum pierce? has it exceeded the maximum distance it needs to travel?)
public boolean dead(int projectileID) {
  float[] data = projectileData.get(projectileID);
  return offScreen(projectileID) || data[pierce] == 0 || data[currDistTravelled] > data[maxDistTravelled];
}

// Checks if a projectile is off-screen 
public boolean offScreen(int projectileID) {
  return center.get(projectileID).x < 0 || center.get(projectileID).x > width || center.get(projectileID).y < 0 || center.get(projectileID).y > height;
}

// Displays a projectile and handles movement & collision via their respective methods
void drawProjectile(int projectileID) {
  float[] data = projectileData.get(projectileID);

  if (projectileData.get(projectileID)[dmgType] == boomerang) {
    pushMatrix();
    translate(center.get(projectileID).x, center.get(projectileID).y);
    rotate(data[angle]);
    noStroke();
    fill(#ffc42e);
    for (int i = 0; i < 6; i++) {
      triangle(0, -20, 5, 0, -5, 0);
      rotate(PI/3);
    }
    popMatrix();
  } else if (projectileData.get(projectileID)[dmgType] == bomb) {
    fill(#3d3d3d);
    stroke(#5f5f5f, 127);
    strokeWeight(2);
    circle(center.get(projectileID).x, center.get(projectileID).y, data[thickness]);
  } else {
    stroke(255);
    strokeWeight(data[thickness]);
    float wid = cos(data[angle]), hgt = sin(data[angle]);
    PVector displacement = new PVector(wid, hgt).mult(projectileRadius);
    PVector start = PVector.add(center.get(projectileID), displacement), end = PVector.sub(center.get(projectileID), displacement);
    line(start.x, start.y, end.x, end.y);
  }
  handleProjectileMovement(projectileID);
  handleCollision(projectileID);
}

// Updates projectile locations
void handleProjectileMovement(int projectileID) {
  PVector nextLocation = PVector.add(center.get(projectileID), velocity.get(projectileID)); // Adds the velocity to the current position
  center.set(projectileID, nextLocation); // Updates the current position

  float[] data = projectileData.get(projectileID);
  data[currDistTravelled] += velocity.get(projectileID).mag(); // Tracks the current distance travelled, so that if it exceeds the maximum projectile range, it disappears
}



PVector closestBalloon (PVector loc, int projectileID) {
  PVector closeBalloon = new PVector();
  boolean found = false;
  float diff = Float.MAX_VALUE, prev = 200;
  balloons = levels.get(levelNum);
  for (float[] balloon : balloons) {
    if (balloon[delay] <= 0 && !balloonsHit.get(projectileID).contains((int) balloon[ID])) {
      diff = dist(loc.x, loc.y, getLocation((int)balloon[currPath], balloon[distanceTravelled]).x, getLocation((int)balloon[currPath], balloon[distanceTravelled]).y);
      if (diff < prev) {
        closeBalloon = getLocation((int)balloon[currPath], balloon[distanceTravelled]);
        found = true;
      }
    }
    prev = min(diff, prev);
  }
  fill(255, 0, 0);
  return found ? closeBalloon : new PVector(-1000, -1000);
}

// Gets the vector distance from one point to another
PVector distanceFrom (float x1, float y1, float x2, float y2) {
  return new PVector (x2-x1, y2-y1);
}

// Checks collision with balloons
void handleCollision(int projectileID) {
  float[] data = projectileData.get(projectileID);
  balloons = levels.get(levelNum);
  for (float[] balloon : balloons) {
    if (balloon[delay] > 0) continue; // If the balloon hasn't entered yet, don't count it
    PVector position = getLocation((int)balloon[currPath], balloon[distanceTravelled]);
    if (distToProjectile(projectileID, position) <= balloonRadius / 2 + data[thickness] / 2) {
      if (data[pierce] == 0 || balloonsHit.get(projectileID).contains((int) balloon[ID])) continue; // Already hit the balloon / already used up its max pierce
      data[pierce]--; // Lowers the pierce by 1 after hitting the balloon
      balloonsHit.get(projectileID).add((int) balloon[ID]); // Adds the projectile to the set of already hit balloons
      if (data[dmgType] == 3 && data[data.length-1] >= 3) {
        // PVector test = pointDistToLine(data[], getLocation(balloon[distanceTravelled]));
        // float ang = atan2(distToProjectile(projectileID, getLocation(balloon[distanceTravelled]))); 
        
        PVector cen = center.get(projectileID);
        if (closestBalloon(cen, projectileID).x == -1000 && closestBalloon(cen, projectileID).y == -1000);
        else velocity.set(projectileID, distanceFrom(cen.x, cen.y, closestBalloon(cen, projectileID).x, closestBalloon(cen, projectileID).y).normalize().mult(10));
        
        //float ang = atan2(cen.y-getLocation(balloon[currDistTravelled]).y, cen.x-getLocation(balloon[currDistTravelled]).x);
        //projectileData.set(projectileID, new float[]{data[damage], data[pierce], ang, data[currDistTravelled], data[maxDistTravelled], data[thickness], data[dmgType]});
      }
      hitBalloon(projectileID, balloon);
    }
  }
  if (data[dmgType] == 3) {
    float[] temp = projectileData.get(projectileID);
    temp[angle] += 0.5;
    temp[angle] %= 360;
    projectileData.set(projectileID, temp);
  }
}
// -------------- TEMPLATE CODE ENDS ---------------- (Participants will NOT need to code anything above this line)

// Code that is called when a projectile hits a balloon
void hitBalloon(int projectileID, float[] balloonData) {
  float[] data = projectileData.get(projectileID);

  balloonData[hp] -= data[damage]; // Deals damage

  if (data[dmgType] == slow && balloonData[slowed] == 0) { // Slows down the balloon
    float slowNum = slowPercent;
    if (data[upgrade] >= 2) {
      slowNum -= 0.2;
    }
    balloonData[speed] *= slowNum;
    balloonData[slowed] = 1;
  }
}

// special sniper damage
void hitBalloon(float[] balloonData, int towerID) {
  //float[] data = projectileData.get(projectileID);
  balloonData[hp] -= sniperdmg + towerData.get(towerID)[upgrade]*5; // Deals damage
}

void hitBalloon(float[] balloonData, float dam) {
  //float[] data = projectileData.get(projectileID);
  balloonData[hp] -= dam; // Deals damage
}


// Tracks the tower that is closest to the end, within the vision of the tower
PVector track(PVector towerLocation, int vision) {
  float minDist = Float.MAX_VALUE;
  PVector location = null;
  for (float[] balloon : levels.get(levelNum)) {
    PVector balloonLocation = getLocation((int)balloon[currPath], balloon[distanceTravelled]);
    // Checks if the tower can see the balloon
    if (dist(balloonLocation.x, balloonLocation.y, towerLocation.x, towerLocation.y) <= vision) {
      // If the balloon has travelled further than the previously stored one, it is now the new fastest
      if (pathLengths[(int)balloon[currPath]] - balloon[distanceTravelled] < minDist) {
        location = balloonLocation;
        minDist = pathLengths[(int)balloon[currPath]] - balloon[distanceTravelled];
      }
    }
  }
  return location;
}

// Handles all projectile creation
void handleProjectiles() {
  if (playingLevel) {
    for (int i = 0; i < towers.size(); i++) {
      PVector location = towers.get(i), balloon;
      int[] data = towerData.get(i);
      data[cooldownRemaining]--;

      if (data[projectileType] == sniper) {
        float[] farthestBalloon = levels.get(levelNum).get(0);
        float prev = pathLengths[(int)farthestBalloon[currPath]] - farthestBalloon[distanceTravelled];
        for (float[] temp : levels.get(levelNum)) farthestBalloon = pathLengths[(int)farthestBalloon[currPath]] - temp[distanceTravelled] < prev ? temp : farthestBalloon;
        balloon = getLocation((int)farthestBalloon[currPath], farthestBalloon[distanceTravelled]);
      } else balloon = track(location, data[towerVision]);

      // Cooldown is 0 and there is a balloon that the tower tracks shoots a projectile
      if (data[cooldownRemaining] <= 0 && balloon != null) {
        data[cooldownRemaining] = (int)(data[maxCooldown] * speedBoostAmount); // Resets the cooldown

        PVector toMouse = new PVector(balloon.x - location.x, balloon.y - location.y);

        if (data[projectileType] == def) {
          int speed = 24, damage = defdmg, pierce = 1, thickness = 2, maxTravelDist = 500;
          if (data[upgrade] >= 3) {
            damage = defdmg + data[upgrade] - 2;
          }
          PVector unitVector = PVector.div(toMouse, toMouse.mag());

          PVector velocity = PVector.mult(unitVector, speed);
          createProjectile(location, velocity, damage, pierce, maxTravelDist, thickness, def, 0);
          // Default type
        } else if (data[projectileType] == eight) {
          // Spread in 8
          int curShots = shots + (data[upgrade] / 3) * 4 + (data[upgrade] / 6) * (data[upgrade] / 6) * 2;
          //if (data[upgrade] >= 3) {
          //  curShots = shots + 8;
          //}

          for (int j = 0; j < curShots; j++) {
            int speed = 18 + (data[upgrade] / 2), damage = eightdmg, pierce = 2, thickness = 2, maxTravelDist = 150 + data[upgrade] * 25;
            float angle = (PI * 2) * j / curShots;
            PVector unitVector = PVector.div(toMouse, toMouse.mag());
            if (data[upgrade] >= 4) {
              damage = eightdmg + data[upgrade] - 3;
            }
            PVector velocity = PVector.mult(unitVector, speed).rotate(angle);
            createProjectile(location, velocity, damage, pierce, maxTravelDist, thickness, eight, 0);
          }
          
        } else if (data[projectileType] == slow) {
          //glue gunner - slows balloons
          final int speed = 15 + data[upgrade], damage = slowdmg + data[upgrade]-1, pierce = 6 + data[upgrade], thickness = 4, maxTravelDist = 220 + data[upgrade]*30; //slow-ish speed, low damage, high pierce, low range
          PVector unitVector = PVector.div(toMouse, toMouse.mag());

          PVector velocity = PVector.mult(unitVector, speed);
          createProjectile(location, velocity, damage, pierce, maxTravelDist, thickness, slow, 0);
          
        } else if (data[projectileType] == boomerang) {
          // bouncing boomerang monkey - boomerang attack hits consecutive balloons
          final int speed = 10 + data[upgrade], damage = boomerangdmg + data[upgrade] - 1, pierce = 5 + (data[upgrade]-1)*2, thickness = 8, maxTravelDist = 250 + (data[upgrade]-1)*25;
          PVector unitVector = PVector.div(toMouse, toMouse.mag());
          PVector velocity = PVector.mult(unitVector, speed);
          createProjectile(location, velocity, damage, pierce, maxTravelDist, thickness, boomerang, data[upgrade]);
        
        } else if (data[projectileType] == sniper) {
          float[] farthestBalloon = levels.get(levelNum).get(0);
          float prev = pathLengths[(int)farthestBalloon[currPath]] - farthestBalloon[distanceTravelled];
          for (float[] temp : levels.get(levelNum)) farthestBalloon = pathLengths[(int)farthestBalloon[currPath]] - temp[distanceTravelled] < prev ? temp : farthestBalloon;
          balloon = getLocation((int)farthestBalloon[currPath], farthestBalloon[distanceTravelled]);
          for (int rep = 0; rep < 1 + ((data[upgrade]-1) % 2) * 2; rep++) {
            hitBalloon(farthestBalloon, i);
          }
          
        } else if (data[projectileType] == bomb) {
          // bomb tower - exploding shots
          final int speed = 10 + data[upgrade], damage = bombdmg + data[upgrade]*2, pierce = 1, thickness = 15 + data[upgrade]*5, maxTravelDist = 300; // slow speed, high damage, exploding shot, low range
          PVector unitVector = PVector.div(toMouse, toMouse.mag());

          PVector velocity = PVector.mult(unitVector, speed);
          createProjectile(location, velocity, damage, pierce, maxTravelDist, thickness, bomb, 0);
        }
      }
    }
    // Displays projectiles and removes those which need to be removed
    for (int projectileID = 0; projectileID < projectileData.size(); projectileID++) {
      drawProjectile(projectileID);
      if (dead(projectileID)) {
        float[] data = projectileData.get(projectileID);
        if (data[dmgType] == bomb) createExplosion(projectileID, center.get(projectileID), data[damage] + ((data[7]-1)*2), ((data[7]-1)*0.5) + 100);
        projectileData.remove(projectileID);
        center.remove(projectileID);
        velocity.remove(projectileID);
        balloonsHit.remove(projectileID);
        projectileID--;
      }
    }
  }
}

ArrayList<float[]> explosions = new ArrayList<float[]>();

void createExplosion(float projectileID, PVector loc, float dmg, float blastRadius) {
  balloons = levels.get(levelNum);
  for (float[] balloon : balloons) {
    PVector balloonLoc = getLocation((int)balloon[currPath], balloon[distanceTravelled]);
    if (dist(balloonLoc.x, balloonLoc.y, loc.x, loc.y) <= blastRadius/2) {
      if (balloonsHit.get((int)projectileID).contains(balloon[ID])) continue;
      balloonsHit.get((int)projectileID).add((int)balloon[ID]);
      hitBalloon(balloon, dmg);
    }
  }
  explosions.add(new float[] {loc.x, loc.y, blastRadius, blastRadius});
  //drawExplosion(loc, blastRadius);
}

void drawExplosions() {
  for (int i = 0; i < explosions.size(); i++) {
    float[] explosion = explosions.get(i);
    drawExplosion(new PVector(explosion[0], explosion[1]), explosion[2], explosion[3]);
    explosion[2] -= 10;
    if (explosion[2] <= 0) {
      explosions.remove(explosion);
      i--;
    }
  }
}

void drawExplosion(PVector origin, float rad, float maxRad) {
  ellipseMode(CENTER);
  strokeWeight(5);
  noFill();
  stroke(#ffc80f, rad*(255/maxRad));
  circle(origin.x, origin.y, maxRad-rad);
}
