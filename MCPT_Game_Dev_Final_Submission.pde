import java.util.ArrayList;
import java.util.List;
import java.util.HashSet;

// Program main method
void setup() {
  size(2000, 800);
  loadIcons();
  initDragAndDrop();
  initPath();
  initUpgradeMenu();
  createWaves();
}

void draw() {
  background(#add558);
  drawPath();

  drawAllTowers(); // Draw all the towers that have been placed down before
  handleProjectiles();

  drawCurrentSpikeIcon();
  drawAllSpikes();

  if (playingLevel) {
    drawBalloons();
    handleSlowdown();
    handleSpeedBoost();
    handleCashDrop();
  }

  drawUserCurrencies();

  drawTowerUI();
  drawTowerBar();
  drawSelectedTowers();
  displayPowerups();
  //dragAndDropInstructions();
  drawWaveCount();

  drawRange();
  
  drawExplosions();

  if (health <= 0) {
    drawLostAnimation();
  }
  handleNextLevel();
  //println(unplaced);
  //for (int i = 0; i < towerData.size(); i++) for (int j = 0; j < towerData.get(i).length; j++) println(towerData.get(i)[j]);
}

// Whenever the user drags the mouse, update the x and y values of the tower
void mouseDragged() {
  if (currentlyDragging != notDragging) {
    dragAndDropLocations[currentlyDragging%10] = new PVector(mouseX + difX, mouseY + difY);
  }
  if (spikeHeld) {
    spikeLocation = new PVector(mouseX + difX, mouseY + difY);
  }
}

// Whenever the user initially presses down on the mouse
void mousePressed() {
  //for (int i = 0; i < towerCount; i++) {
  handlePickUp(buttonHovered());
  //}
  if (playingLevel) {
    handleSpikePickUp();
    handleSlowdownPress();
    handleSpeedBoostPress();
    handleCashDropPress();
  }
}

// Whenever the user releases their mouse
void mouseReleased() {
  if (currentlyDragging != notDragging) {
    handleDrop(currentlyDragging%10);
  }
  currentlyDragging = notDragging;

  if (spikeHeld) {
    handleSpikeDrop();
  }
  towerClickCheck();

  //upgrading towers implementation
  upgradeCheck();

  //removing towers implementation
  removeCheck();
  
  // check autoplay press
  handlePlayPress();
}

void keyPressed() {
  if (key == ' ') {
    autoPlay = !autoPlay;
  }
}



/*

 
 
 
 TO DO LIST
 
 --------------------------
 DONE
 --------------------------
 
 - finish path
 - fix boomerang projectile
 - add enemy colours
 - fix tower pickup location
 - autoplay button
 - add wave counter
 - bomb tower
 - explosion damage
 - fully implement boomerang monkey
 - add 2 new towers
 - move upgrade menu
 - add powerup icons
 - add new powerup
 - FIX BOMB TOWER
 - IMPROVE WAVE SYSTEM
 - MAKE BALLOONS DEPENDENT ON TYPE
 - child balloons (balloons spawn on death)
 - implement upgrades for each tower
     - def           DONE
     - tack          DONE
     - slow          DONE
     - boomerang     DONE
     - sniper        DONE
     - bomb          DONE
 - fix tower bar slots
 - name tower on upgrade ui
 - auto generated waves
 
 
  
+------------------------+
|         TO DO          |
+------------------------+

 - balance towers/waves
 
 */
