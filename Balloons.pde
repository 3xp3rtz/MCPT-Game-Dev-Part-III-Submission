/*
Encompasses: Displaying Balloons, Waves & Sending Balloons, Balloon Reaching End of Path
 */

ArrayList<ArrayList<float[]>> levels = new ArrayList<ArrayList<float[]>>();
ArrayList<ArrayList<color[]>> balloonCols = new ArrayList<ArrayList<color[]>>();
ArrayList<float[]> balloons;

final int currPath = 0, distanceTravelled = 1, delay = 2, speed = 3, maxHP = 4, hp = 5, slowed = 6, ID = 7, balloonCol = 8, balloonType = 9;
final int balloonRadius = 25; //Radius of the balloon

final int[] rewardPerBalloon = {15, 20, 30, 40, 50, 10, 10}; // Money earned by popping a balloon
final int baseRewardPerWave = 250; //base money earned per wave

final int redB = 0, blueB = 1, greenB = 2, yellowB = 3, pinkB = 4, whiteB = 5, blackB = 6;

int levelNum = -1;
boolean playingLevel = false, autoPlay = false, ready = false;

final float[] 
    balloonSpeeds = {1, 1.5, 1.75, 2, 2.5, 1.5, 1.5},
    balloonMaxHP = {10, 20, 25, 30, 40, 25, 25};
final color[]
    balloonColours = {#ff2e2e, #2eadff, #2eff3d, #ffeb2e, #ff8bfd, #ffffff, #000000};


final int[] spawnChildren = {whiteB, blackB};
final ArrayList<float[]> childrenSpawned = new ArrayList<float[]>();

void initBalloonChildren() {
  childrenSpawned.add(new float[] {pinkB, 5, 5});
  childrenSpawned.add(new float[] {pinkB, 5, 5});
}

void createWaves() {
  createLevels(15);

  // (level balloons are for, number of balloons, first balloon delay, delay between the sequence of balloons, speed, hp, colour)
  // level, num of balloons, first delay, spacing, balloon type
  createBalloons(0, 5,  0,   15, redB);
  
  createBalloons(1, 15, 0,   5,  redB);
  
  createBalloons(2, 10, 0,   10, blueB);
  
  createBalloons(3, 10, 0,   20, blueB);
  createBalloons(3, 20, 100, 5,  redB);
  
  createBalloons(4, 10, 0,   20, greenB);
  
  createBalloons(5, 15, 0,   10, greenB);

  createBalloons(5, 30, 100, 5,  blueB);
  
  for (int i = 6; i < 15; i++) {
    for (int j = 0; j < random(1, 5); j++) {
      createBalloons(i, (int)random(1, 7)*5, j*100, (int)random(1,5), (int)random((i-2)/3, 7));
    }
  }

}

void createLevels(int num) {
  for (int i = 0; i < num; i++) {
    levels.add(new ArrayList<float[]>());
    balloonCols.add(new ArrayList<color[]>());
  }
}

void createBalloons(int level, int numBalloons, float delay, float delayInBetween, int balType) {
  for (int i = 0; i < numBalloons; i++) {
    levels.get(level).add(new float[]{
      (int)random(0, numPaths),      // path
      0,                             // distance travelled
      delay + i * delayInBetween,    // delay
      balloonSpeeds[balType],        // speed of balloon
      balloonMaxHP[balType],         // max health of balloon
      balloonMaxHP[balType],         // current health of balloon
      0,                             // slowed state
      levels.get(level).size(),      // balloon ID
      balloonColours[balType],       // colour of balloon
      balType
    });
    balloonCols.get(level).add(new color[] {
      balloonColours[balType]
    });
  }
}

void createBalloons(int level, float pathNum, int numBalloons, float delay, float delayInBetween, int balType, float distTrav) {
  for (int i = 0; i < numBalloons; i++) {
    levels.get(level).add(new float[]{
      pathNum, 
      distTrav-(i*delayInBetween), 
      delay, 
      balloonSpeeds[balType], 
      balloonMaxHP[balType], 
      balloonMaxHP[balType], 
      0, 
      levels.get(level).size(), 
      balloonColours[balType],
      balType
    });
    balloonCols.get(level).add(new color[] {
      balloonColours[balType]
    });
  }
}


void createCustomBalloons(int level, float pathNum, int numBalloons, float delay, float delayInBetween, float speed, float hp, color col, float distTrav) {
  for (int i = 0; i < numBalloons; i++) {
    levels.get(level).add(new float[]{pathNum, distTrav-(i*delayInBetween), delay, speed, hp, hp, 0, levels.get(level).size(), col});
  }
}


void createCustomBalloons(int level, int numBalloons, float delay, float delayInBetween, float speed, float hp, color col) {
  for (int i = 0; i < numBalloons; i++) {
    
    levels.get(level).add(new float[]{
      (int)random(0, numPaths),      // path
      0,                             // distance travelled
      delay + i * delayInBetween,    // delay
      speed,                         // speed of balloon
      hp,                            // max health of balloon
      hp,                            // current health of balloon
      0,                             // slowed state
      levels.get(level).size(),      // balloon ID
      col                            // colour of balloon
    });
  }
}


// Displays and moves balloons
void updatePositions(float[] balloon) {
  // Only when balloonProps[2] is 0 (the delay) will the balloons start moving.
  if (balloon[delay] < 0) {
    PVector position = getLocation((int)balloon[currPath], balloon[distanceTravelled]);
    float travelSpeed = balloon[speed] * slowdownAmount; // Slow down the balloon if the slowdown powerup is engaged
    balloon[distanceTravelled] += travelSpeed; //Increases the balloon's total steps by the speed

    //Drawing of ballon
    ellipseMode(CENTER);
    strokeWeight(0);
    stroke(0);
    fill(0);

    //draw healthbar outline
    stroke(0, 0, 0);
    strokeWeight(0);
    rectMode(CORNER);
    fill(#830000);
    final float hbLength = 35, hbWidth = 6;
    rect(position.x - hbLength / 2, position.y - (balloonRadius), hbLength, hbWidth);

    //draw mini healthbar
    noStroke();
    fill(#FF3131);
    rect(position.x - hbLength / 2, position.y - (balloonRadius), max(hbLength * (balloon[hp] / balloon[maxHP]), 0), hbWidth); //the healthbar that changes based on hp
    ArrayList<color[]> balCols = balloonCols.get(levelNum);
    fill(balCols.get((int)balloon[ID])[0]);
    if (balloon[slowed] == 1) {
      fill(balCols.get((int)balloon[ID])[0], 127);
    }
    circle(position.x, position.y, balloonRadius);
  } else {
    balloon[delay]--;
  }
}

void drawBalloons() {
  balloons = levels.get(levelNum);
  for (int i = 0; i < balloons.size(); i++) {
    float[] balloon = balloons.get(i);
    updatePositions(balloon);

    PVector position = getLocation((int)balloon[currPath], balloon[distanceTravelled]);
    if (balloonSpikeCollision(position)) {
      handleBalloonPop((int)balloon[balloonType]);
      balloons.remove(i);
      i--;
      continue;
    }
    if (balloon[hp] <= 0) {
      handleBalloonPop((int)balloon[balloonType]);
      balloons.remove(i);
      
      /* child balloons */
      for (int check = 0; check < spawnChildren.length; check++) {
        if (spawnChildren[check] == balloon[balloonType]) {
          float[] arr = childrenSpawned.get(check);
          createBalloons(levelNum, balloon[currPath], (int)arr[2], 0, arr[1], (int)arr[0], balloon[distanceTravelled]);
          continue;
        }
      }
      
      i--;
      continue;
    }
    if (balloon[distanceTravelled] >= pathLengths[(int)balloon[currPath]]) {
      balloons.remove(i); // Removing the balloon from the list
      health--; // Lost a life.
      i--; // Must decrease this counter variable, since the "next" balloon would be skipped
      // When you remove a balloon from the list, all the indexes of the balloons "higher-up" in the list will decrement by 1
    }
  }
  if (balloons.size() == 0 && playingLevel) {
    playingLevel = false;
    handleWaveReward(levelNum + 1);
  }
}

void drawUserCurrencies() {
  noStroke();
  rectMode(CORNER);
  fill(206, 172, 0);
  rect(width-700, height-150, 675, 135);
  textAlign(LEFT, BASELINE);

  drawHealthBar();
  drawBalanceDisplay();
}




// ------- HP SYSTEM --------
/*
  Health-related variables:
 int health: The player's total health.
 This number decreases if balloons pass the end of the path (offscreen), currentely 11 since there are 11 balloons.
 PImage heart: the heart icon to display with the healthbar.
 */
int health = 11;  //variable to track user's health
PImage heart, moneyBag, snowIcon, cashDropIcon, speedBoostIcon;

void loadIcons() {
  heart = loadImage("heart.png");
  spikeIcon = loadImage("spikes.png");
  moneyBag = loadImage("moneyBag.png");
  snowIcon = loadImage("snowIcon.png");
  cashDropIcon = loadImage("cashDropIcon.png");
  speedBoostIcon = loadImage("speedBoostIcon.png");
}


//method to draw a healthbar at the bottom right of the screen
void drawHealthBar() {

  //draw healthbar outline
  stroke(0);
  strokeWeight(0);
  fill(#830000);
  rectMode(CORNER);
  rect(width-280, height-100, 220, 30);
  int trueHealth = max(health, 0);

  //draw healthbar
  noStroke();
  fill(#FF3131);
  rect(width-280, height-100, trueHealth*20, 30); //the healthbar that changes based on hp
  rectMode(CENTER);
  noFill();

  //write text
  stroke(0);
  textSize(18);
  fill(255, 255, 255);
  text("Health:   "+trueHealth, width-225, height-80);

  //put the heart.png image on screen
  imageMode(CENTER);
  image(heart, width-280, height-85, 45, 42);
  noFill();
}

//Next level Button
boolean pointRectCollision(float x1, float y1, float x2, float y2, float sizeX, float sizeY) {
  //            --X Distance--               --Y Distance--
  return (abs(x2 - x1) <= sizeX / 2) && (abs(y2 - y1) <= sizeY / 2);
}

void drawWaveCount() {
  fill(255, 127);
  stroke(#9775E8);
  strokeWeight(5);
  rectMode(CENTER);
  rect(width-200, 30, 150, 50);
  fill(0);
  textSize(30);
  textAlign(CENTER, TOP);
  text("Wave " + (levelNum+1), width-200, 20);
}

void handlePlayPress() {
  if (buttonHovered() == 101) autoPlay = !autoPlay;
  ready = buttonHovered() == 100 ? true : false;
}

void handleNextLevel() {
  if (!playingLevel && (ready || autoPlay) && levelNum < levels.size()-1) {
    playingLevel = true;
    levelNum++;
  }
}
