/** All powerups including
 *  - Path spikes
 *  - Slow Time
 *  - Damage/Speed boost for towers
 */

int powerupCount[] = {5, 3, 3, 5}; // Amount of each powerup remaining
final int spikes = 0, slowdown = 1, speedboost = 2, cashdrop = 3;
final int spikePierce = 3; // Amount of balloons the cluster of spikes will pop before disappearing

final int slowdownLength = 7; // Amount of time that a slowdown session lasts for in seconds
final int speedBoostLength = 7; // Amount of time that a speed boost session lasts for in seconds

float slowdownAmount = 1; // The factor to multiply all balloon speeds by
int slowdownRemaining = 0;
final PVector slowdownLocation = new PVector(100, 650);

float speedBoostAmount = 1; // Factor to multiply all tower cooldowns by
int speedBoostRemaining = 0;
final PVector speedBoostLocation = new PVector(150, 650); 

float cashDropCooldown = 0;
final PVector cashDropLocation = new PVector(200, 650); 


PImage spikeIcon; // Image for path spikes
PVector spikeLocation = new PVector(50, 650); // Location of spike for drag and drop
ArrayList<PVector> spikeLocations;
ArrayList<Integer> spikeData;

final PVector originalSpikeLocation = new PVector(50, 650);

boolean spikeHeld = false;

/** Reimplementation of Drag and Drop for path spikes **/
boolean withinSpikeBounds() {
  return pointRectCollision(mouseX, mouseY, spikeLocation.x, spikeLocation.y, 45);
}

boolean spikeTrashDrop() {
  PVector location = spikeLocation;
  if (location.x >= trashX1 && location.x <= trashX2 && location.y >= trashY1 && location.y <= trashY2) return true;
  return false;
}

void handleSpikePickUp() {
  if (withinSpikeBounds() && powerupCount[spikes] > 0) {
    spikeHeld = true;

    PVector location = spikeLocation;
    difX = (int) location.x - mouseX; // Calculate the offset values (the mouse pointer may not be in the direct centre of the tower)
    difY = (int) location.y - mouseY;
  }
}

void handleSpikeDrop() {
  if (spikeTrashDrop()) {
    spikeLocation = originalSpikeLocation;
    //println("Spike object in trash.");
  } else if (legalSpikeDrop()) {
    powerupCount[spikes]--; // Decrease remaining spikes by 1

    spikeLocations.add(spikeLocation.copy());
    spikeData.add(spikePierce);
    spikeLocation = originalSpikeLocation;
    //println("Spike Dropped on Path");
  }
  spikeHeld = false;
}

void drawSpikeIcon(PVector location, color colour) {
  ellipseMode(RADIUS);
  fill(colour);
  circle(location.x, location.y, 20);

  imageMode(CENTER);
  image(spikeIcon, location.x, location.y);
}

void drawSpikeIcon(PVector location) {
  imageMode(CENTER);
  image(spikeIcon, location.x, location.y);
}

void drawAllSpikes() {
  for (int i = 0; i < spikeLocations.size(); i++) {
    if (spikeData.get(i) <= 0) {
      spikeData.remove(i);
      spikeLocations.remove(i);
      i--;
    } else {
      drawSpikeIcon(spikeLocations.get(i));
    }
  }
}

void drawCurrentSpikeIcon() {
  drawSpikeIcon(spikeLocation, legalSpikeDrop() || spikeLocation.equals(originalSpikeLocation) ? #FFFFFF : #F00000);
}

boolean balloonSpikeCollision(PVector position) {
  for (int i = 0; i < spikeLocations.size(); i++) {
    PVector spikeLocation = spikeLocations.get(i);
    if (dist(position.x, position.y, spikeLocation.x, spikeLocation.y) <= PATH_RADIUS) {
      spikeData.set(i, spikeData.get(i) - 1);
      return true; // // Spike has popped the balloon!
    }
  }
  return false;
}

void displayPowerups() {
  color displayColour;


  /** Slowdown */
  if (mousePressed && withinSlowdownBounds() && powerupCount[slowdown] <= 0 && slowdownRemaining <= 0) {
    displayColour = #F00000; // Display using red error colour
  } else if (slowdownRemaining > 0) {
    displayColour = #81E5FF; // Display blue colour for slowdown in progress
  } else {
    displayColour = #FFFFFF; // Display using white colour
  }

  fill(displayColour);
  ellipseMode(RADIUS);

  circle(slowdownLocation.x, slowdownLocation.y, 20);
  imageMode(CENTER);
  image(snowIcon, slowdownLocation.x+1, slowdownLocation.y+1, 35, 35);



  /** Speed Boosts */
  if (mousePressed && withinSpeedBoostBounds() && powerupCount[speedboost] <= 0 && speedBoostRemaining <= 0) {
    displayColour = #F00000; // Display using red error colour
  } else if (speedBoostRemaining > 0) {
    displayColour = #81E5FF; // Display blue colour for slowdown in progress
  } else {
    displayColour = #FFFFFF; // Display using white colour
  }
  fill(displayColour);
  circle(speedBoostLocation.x, speedBoostLocation.y, 20);
  imageMode(CENTER);
  image(speedBoostIcon, speedBoostLocation.x+1, speedBoostLocation.y+1, 30, 30);


  /** Cash Drop **/
  if (mousePressed && withinCashDropBounds() && powerupCount[cashdrop] <= 0) {
    displayColour = #F00000; // Display using red error colour
  } else if (cashDropCooldown > 0) {
    displayColour = #81E5FF; // Display blue colour for cashdrop
  } else {
    displayColour = #FFFFFF; // Display using white colour
  }

  fill(displayColour);
  ellipseMode(RADIUS);

  circle(cashDropLocation.x, cashDropLocation.y, 20);
  imageMode(CENTER);
  image(cashDropIcon, cashDropLocation.x+1, cashDropLocation.y+1, 30, 30);



  /** Spikes */
  if (mousePressed && withinSpikeBounds() && powerupCount[spikes] <= 0) {
    displayColour = #F00000; // Display using red error colour
  } else {
    displayColour = #FFFFFF; // Display using white colour
  }

  fill(displayColour);


  drawSpikeIcon(originalSpikeLocation, displayColour);
  PFont powerupNums = loadFont("Calibri-Bold-20.vlw");
  textFont(powerupNums);
  fill(0);
  text("" + powerupCount[spikes], 60, 640);
  text(/*"Slowdowns remaining:*/ "" + powerupCount[slowdown], slowdownLocation.x+10, slowdownLocation.y-10);
  text(/*"Speed Boosts remaining: */"" + powerupCount[speedboost], speedBoostLocation.x+10, speedBoostLocation.y-10);
  text(/*"Speed Boosts remaining: */"" + powerupCount[cashdrop], cashDropLocation.x+10, cashDropLocation.y-10);
}

boolean withinSlowdownBounds() {
  return pointRectCollision(mouseX, mouseY, slowdownLocation.x, slowdownLocation.y, 45);
}

void handleSlowdownPress() {
  if (withinSlowdownBounds() && powerupCount[slowdown] > 0 && slowdownAmount == 1) {
    powerupCount[slowdown]--;
    slowdownAmount = 0.5;
    slowdownRemaining = slowdownLength * 60;
  }
}

void handleSlowdown() {
  if (slowdownRemaining > 0) {
    slowdownRemaining--;

    if (slowdownRemaining == 0) {
      slowdownAmount = 1; // Revert to original speed
    }
  }
}

/** Speed Boost Powerup */

boolean withinSpeedBoostBounds() {
  return pointRectCollision(mouseX, mouseY, speedBoostLocation.x, speedBoostLocation.y, 45);
}

void handleSpeedBoostPress() {
  if (withinSpeedBoostBounds() && powerupCount[speedboost] > 0 && speedBoostAmount == 1) {
    powerupCount[speedboost]--;
    speedBoostAmount = 0.4;
    speedBoostRemaining = speedBoostLength * 60;
  }
}

void handleSpeedBoost() {
  if (speedBoostRemaining > 0) {
    speedBoostRemaining--;

    if (speedBoostRemaining == 0) {
      speedBoostAmount = 1; // Revert to original speed
    }
  }
}

/** Cash Drop Powerup */

boolean withinCashDropBounds() {
  return pointRectCollision(mouseX, mouseY, cashDropLocation.x, cashDropLocation.y, 45);
}

void handleCashDropPress() {
  if (withinCashDropBounds() && powerupCount[cashdrop] > 0 && cashDropCooldown == 0) {
    powerupCount[cashdrop]--;
    currentBalance += 1500;
    cashDropCooldown += 1000;
  }
}

void handleCashDrop() {
  if (cashDropCooldown > 0) {
    cashDropCooldown--;
  }
}
