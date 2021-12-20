/*
Encompasses: Displaying Towers & Tower Data (for projectiles)
 */

String[] towerName = {"Dart", "Tack", "Glue", "Boomerang", "Sniper", "Bomb"};

final int cooldownRemaining = 0, maxCooldown = 1, towerVision = 2, projectileType = 3, upgrade = 4;

ArrayList<int[]> towerData;
int[] towerVisions = {200, 150, 250, 125, 10000, 175};
int[] makeTowerData(int towerID) {
  if (towerID == def) {
    return new int[] {
      10, // Cooldown between next projectile
      10, // Max cooldown
      towerVisions[def], // Tower Vision
      def, // Projectile ID
      1
    };
  } else if (towerID == eight) {
    return new int[] {
      25, // Cooldown between next projectile
      25, // Max cooldown
      towerVisions[eight], // Tower Vision
      eight, // Projectile ID
      1
    };
  } else if (towerID == slow) {
    return new int[] {
      35, 
      35, 
      towerVisions[slow], // Tower Vision
      slow, 
      1
    };
  } else if (towerID == boomerang) {
    return new int[] {
      0, 
      20, 
      towerVisions[boomerang], 
      boomerang, 
      1
    };
  } else if (towerID == sniper) {
    return new int[] {
      5, 
      100, 
      towerVisions[sniper], 
      sniper, 
      1
    };
  } else if (towerID == bomb) {
    return new int[] {
      50,
      50,
      towerVisions[bomb],
      bomb,
      1
    };
  }
  return new int[] {}; //filler since we need to return something
}

// --------------------------------------------------

// Draw a simple tower at a specified location
void drawTowerIcon(float xPos, float yPos, color colour, int upgrade) {
  strokeWeight(0);
  stroke(0);
  fill(colour);
  rectMode(CENTER);
  square(xPos, yPos, towerSize); // Draw a simple rectangle as the tower
  if ((upgrade - 1) % 3 != 0) {
    fill(255, 0, 0);
    for (int i = 1; i < (upgrade-1) % 3 + 1; i++) {
      rect(xPos, yPos + i*towerSize/((upgrade-1) % 3 + 1) - towerSize/2, towerSize, 5);
    }
  }
  if (((upgrade - 1) % 6) / 3 > 0) {
    fill(0);
    ellipseMode(CENTER);
    circle(xPos-10, yPos, 5);
  }
  if ((upgrade - 1) / 6 > 0) {
    fill(#c3ff00);
    ellipseMode(CENTER);
    circle(xPos+10, yPos, 5);
  }
}

// Draws a tower that rotates to face the targetLocation
void drawTowerWithRotation(float xPos, float yPos, color colour, PVector targetLocation, int upgrade) {
  pushMatrix();
  translate(xPos, yPos);

  // Angle calculation
  float slope = (targetLocation.y - yPos) / (targetLocation.x - xPos);
  float angle = atan(slope);

  rotate(angle);

  strokeWeight(0);
  fill(colour);
  rectMode(CENTER);
  rect(0, 0, towerSize, towerSize); // Draw a simple rectangle as the tower
  if ((upgrade - 1) % 3 != 0) {
    fill(255, 0, 0);
    for (int i = 1; i < (upgrade-1) % 3 + 1; i++) {
      rect(0, i*towerSize/((upgrade-1) % 3 + 1) - towerSize/2, towerSize, 5);
    }
  }
  if (((upgrade - 1) % 6) / 3 > 0) {
    fill(0);
    ellipseMode(CENTER);
    circle(-10, 0, 5);
  }
  if ((upgrade - 1) / 6 > 0) {
    fill(#c3ff00);
    ellipseMode(CENTER);
    circle(10, 0, 5);
  }

  popMatrix();
}

void drawAllTowers() {
  for (int i = 0; i < towers.size(); i++) {
    float xPos = towers.get(i).x, yPos = towers.get(i).y;
    int[] data = towerData.get(i);
    int towerType = data[projectileType];

    PVector track = null;
    if (playingLevel) {
      track = track(towers.get(i), data[towerVision]);
    }

    if (track == null) {
      drawTowerIcon(xPos, yPos, towerColours[towerType], data[upgrade]);
    } else {
      drawTowerWithRotation(xPos, yPos, towerColours[towerType], new PVector(track.x, track.y), data[upgrade]);
    }

    if (pointRectCollision(mouseX, mouseY, xPos, yPos, towerSize)) {
      // Drawing the tower range visually 
      fill(127, 80);
      stroke(127);
      strokeWeight(4);
      ellipseMode(RADIUS);
      vis = data[projectileType] == 4 ? 50 : data[towerVision];
      circle(xPos, yPos, vis);
    }
    fill(#4C6710);
    textSize(12);
    text("Tower " + (i+1), xPos - 30, yPos - 20);
  }
}

void drawSelectedTowers() {
  // Draws the tower you're dragging
  // Changing the color if it is an illegal drop to red
  // Loops through the towerIDs and checks each if any of them are currently being dragged
  // Note that more than one tower can be dragged at a time
  for (int towerID = 0; towerID < towerCount; towerID++) {
    if (held[towerID]) {
      PVector location = dragAndDropLocations[towerID];
      if (!legalDrop(towerID)) {
        drawTowerIcon(location.x, location.y, #FF0000, 0);
      } else {
        drawTowerIcon(location.x, location.y, towerColours[towerID], 0);
      }
      // Drawing the tower range of the selected towers 
      fill(127, 80);
      stroke(127);
      strokeWeight(4);
      ellipseMode(RADIUS);
      circle(location.x, location.y, towerID == 4 ? 50 : towerVisions[towerID]);
    }
  }
  // Draws the default towers
  for (int towerType = 0; towerType < towerCount; towerType++) {
    PVector location = originalLocations[towerType];
    if (!hasSufficientFunds(towerPrice[towerType]) && buttonHovered() == towerType) {
      drawTowerIcon(location.x, location.y, towerErrorColour, 0);
    } else drawTowerIcon(location.x, location.y, towerColours[towerType], 0);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    // displays the prices of towers
    text("$" + towerPrice[towerType], location.x, location.y + 25);
    // displays the tower name
    text("" + towerName[towerType], location.x, location.y - 25);
  }
}
