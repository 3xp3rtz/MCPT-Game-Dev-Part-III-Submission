//To upgrade towers, click them and their radius will show around them. Click the upgrade button to upgrade the tpower to the next level
PVector upgradeLocation, removeLocation;
int upgradeMenuX1, upgradeMenuY1, upgradeMenuX2, upgradeMenuY2;
float vis;

void initUpgradeMenu() {
  upgradeLocation =  new PVector(width-175, 350);
  removeLocation = new PVector(width-75, 350);
  upgradeMenuX1 = width-250;
  upgradeMenuY1 = 150;
  upgradeMenuX2 = width;
  upgradeMenuY2 = 600;
}

void towerClickCheck() {
  rectMode(CORNER);
  if (!keepMenuUp()) {
    towerClicked = -1;
  }
  for (int i = 0; i < towers.size(); i++) {
    float xPos = towers.get(i).x, yPos = towers.get(i).y;
    if (pointRectCollision(mouseX, mouseY, xPos, yPos, towerSize)) {
      // Drawing the tower range visually
      towerClicked = i;
      break;
    }
  }
}

void drawRange() {
  if (towerClicked != -1) {
    float xPos = towers.get(towerClicked).x, yPos = towers.get(towerClicked).y;
    int[] data = towerData.get(towerClicked);
    fill(127, 80);
    stroke(127);
    strokeWeight(4);
    ellipseMode(RADIUS);

    vis = data[projectileType] == 4 ? 50 : data[towerVision];
    circle(xPos, yPos, vis);
  }
}

boolean keepMenuUp() {
  if (mouseX >= width-250 && mouseX <= width && mouseY >= 150 && mouseY <= 600) return true;
  if ((upgradeLocation.x - 43 <= mouseX && mouseX <= upgradeLocation.x + 43 && upgradeLocation.y - 24 <= mouseY && mouseY <= upgradeLocation.y + 24) && towerClicked != -1) return true;
  if ((removeLocation.x - 35 <= mouseX && mouseX <= removeLocation.x + 35 && removeLocation.y - 24 <= mouseY && mouseY <= removeLocation.y + 24) && towerClicked != -1) return true;
  return false;
}

// method to get damage numbers from the type of tower's projectile
int dmgFromProjectileType(int type, int[] temp) {
  if (type == def) {
    int ret = defdmg;
    if (temp[upgrade] >= 3) {
      ret += temp[upgrade] - 2;
    }
    return ret;
  } else if (type == eight) {
    int ret = eightdmg;
    if (temp[upgrade] >= 4) {
      ret += temp[upgrade] - 3;
    }
    return ret;
  } else if (type == slow) {
    return slowdmg;
  } else if (type == boomerang) {
  }
  return 0;
}

// draw the tower UI - includes the remove option
void drawTowerUI() {
  if (towerClicked != -1) {
    //draw outer box for upgrades
    int[] temp = towerData.get(towerClicked);
    rectMode(CORNER);
    stroke(#add558);
    strokeWeight(1);
    fill(#E7EAB5);
    rect(upgradeMenuX1, upgradeMenuY1, upgradeMenuX2-upgradeMenuX1, upgradeMenuY2-upgradeMenuY1, 3);
    fill(#444941);
    text("Current Level: " + temp[upgrade], width-210, 225);
    fill(towerColours[temp[3]]);
    square(width-200, 400, 150);
    rectMode(CENTER);
    if ((temp[upgrade] - 1) % 3 != 0) {
      noStroke();
      fill(255, 0, 0);
      for (int i = 1; i < (temp[upgrade]-1) % 3 + 1; i++) {
        rect(width-125, 475 + i*150/((temp[upgrade]-1) % 3 + 1) - 75, 150, 25);
      }
    }
    if (((temp[upgrade] - 1) % 6) / 3 > 0) {
      noStroke();
      fill(0);
      ellipseMode(CENTER);
      circle(width-187.5, 475, 25);
    }
    if ((temp[upgrade] - 1) / 6 > 0) {
      fill(#c3ff00);
      ellipseMode(CENTER);
      circle(width-137.5, 475, 25);
    }
    //text("Range: "+ temp[towerVision], width-250, 246);
    //text("damage: "+ (dmgFromProjectileType(temp[projectileType], temp)), 204, 446);
    //strokeWeight(2);
    //stroke(#a8a89d, 200);
    //line(100, 453, 295, 453);
    drawUpgrade();
    drawRemove();
  }
}

//EDIT THIS FOR UI FOR UPGRADES
void drawUpgrade() {
  strokeWeight(0);
  stroke(0);
  fill(#C364FF);
  rectMode(CENTER);
  rect(upgradeLocation.x, upgradeLocation.y, 86, 48, 5);
  textAlign(CENTER, CENTER);
  textSize(16);
  fill(255);
  int[] temp = towerData.get(towerClicked);
  int upgradePrice = (towerPrice[temp[projectileType]] / 2 + (towerPrice[temp[projectileType]])*temp[upgrade]/2);
  text("Upgrade", upgradeLocation.x, upgradeLocation.y-10);
  textSize(18-((""+upgradePrice).length()));
  text("Buy: $" + upgradePrice, upgradeLocation.x, upgradeLocation.y+10);
  textAlign(LEFT, BASELINE);
}

void upgradeCheck() {
  if ((upgradeLocation.x - 43 <= mouseX && mouseX <= upgradeLocation.x + 43 && upgradeLocation.y - 12 <= mouseY && mouseY <= upgradeLocation.y + 12) && towerClicked != -1) {
    int[] temp = towerData.get(towerClicked);
    int upgradeCost = (towerPrice[temp[projectileType]] / 2 + (towerPrice[temp[projectileType]])*temp[upgrade]/2);
    if (currentBalance >= upgradeCost) {
      temp[upgrade]++; 
      currentBalance -= upgradeCost;
      if (temp[projectileType] == def) {
        temp[maxCooldown] = 10 - (int)sqrt(temp[upgrade]); //increases attack speed
      } else if (temp[projectileType] == eight) {
        temp[maxCooldown] = 25 - (int)sqrt(temp[upgrade] * 2); //increases attack speed
        temp[towerVision] += 25;
      } else if (temp[projectileType] == slow) {
        temp[maxCooldown] = 35 - (int)sqrt(temp[upgrade] * 4); //increases attack speed
        temp[towerVision] += 50;
      } else if (temp[projectileType] == boomerang) {
        temp[maxCooldown] -= 3;
        temp[towerVision] += 10;
      } else if (temp[projectileType] == sniper) {
        temp[maxCooldown] -= 5;
      }
      towerData.set(towerClicked, temp);
      //println("tower number: " + (towerClicked + 1) + ", upgrade level: " + temp[upgrade]);
    }
  }
}

void drawRemove() {
  strokeWeight(1);
  stroke(#deac9e);
  fill(#FF6961);
  rectMode(CENTER);
  rect(removeLocation.x, removeLocation.y, 70, 48, 5);
  textAlign(CENTER, CENTER);
  textSize(16);
  fill(#ffffff);
  int[] temp = towerData.get(towerClicked);
  int sellPrice = (temp[upgrade]/3 + 1) * (towerPrice[temp[projectileType]] / 2 + (towerPrice[temp[projectileType]])*temp[upgrade]/3);
  text("Sell for", removeLocation.x, removeLocation.y-10);
  text("$" + sellPrice, removeLocation.x, removeLocation.y+10);
  textAlign(LEFT, BASELINE);
}

void removeCheck() {
  if ((removeLocation.x - 35 <= mouseX && mouseX <= removeLocation.x + 35 && removeLocation.y - 12 <= mouseY && mouseY <= removeLocation.y + 12) && towerClicked != -1) {
    int[] temp = towerData.get(towerClicked);
    currentBalance += (temp[upgrade]/3 + 1) * (towerPrice[temp[projectileType]] / 2 + (towerPrice[temp[projectileType]])*temp[upgrade]/3);
    int temp1 = towerClicked; 
    towerClicked = -1;
    towerData.remove(temp1); 
    towers.remove(temp1);
  }
}
