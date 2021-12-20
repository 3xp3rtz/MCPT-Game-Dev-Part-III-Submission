/*
Encompasses: Displaying Balloons, Waves & Sending Balloons, Balloon Reaching End of Path
 */

ArrayList<ArrayList<float[]>> levels = new ArrayList<ArrayList<float[]>>();
ArrayList<float[]> balloons;
final int currPath = 0, distanceTravelled = 1, delay = 2, speed = 3, maxHP = 4, hp = 5, slowed = 6, ID = 7, rColVal = 8, gColVal = 9, bColVal = 10;
final int balloonRadius = 25; //Radius of the balloon

int levelNum = -1;
boolean playingLevel = false, autoPlay = false, ready = false;

void createWaves() {
  createLevels(5);


  // (level balloons are for, number of balloons, first balloon delay, delay between the sequence of balloons, speed, hp, colour)
  createBalloons(0, 5,   0, 20, 1,   20,    255, 61,  83  );
  createBalloons(1, 5,   0, 20, 2,   50,    255, 241, 77  );
  createBalloons(2, 1,   0, 0,  0.6, 100,   77,  255, 120 );
  createBalloons(3, 100, 0, 20, 1,   30,    77,  173, 255 );
  createBalloons(4, 25,  0, 5,  3,   10000, 0,   0,   0   );
}

void createLevels(int num) {
  for (int i = 0; i < num; i++) {
    levels.add(new ArrayList<float[]>());
  }
}

void createBalloons(int level, int numBalloons, float delay, float delayInBetween, float speed, float hp, float rVal, float gVal, float bVal) {
  for (int i = 0; i < numBalloons; i++) {
    levels.get(level).add(new float[]{(int)random(0, numPaths), 0, delay + i * delayInBetween, speed, hp, hp, 0, levels.get(level).size(), rVal, gVal, bVal});
  }
}

void createBalloons(int level, float pathNum, int numBalloons, float delay, float delayInBetween, float speed, float hp, float rVal, float gVal, float bVal, float distTrav) {
  for (int i = 0; i < numBalloons; i++) {
    levels.get(level).add(new float[]{pathNum, distTrav-(i*delayInBetween), delay, speed, hp, hp, 0, levels.get(level).size(), rVal, gVal, bVal});
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

    fill(color(balloon[rColVal], balloon[gColVal], balloon[bColVal]));
    if (balloon[slowed] == 1) {
      fill(#C19D40);
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
      handleBalloonPop();
      balloons.remove(i);
      i--;
      continue;
    }
    if (balloon[hp] <= 0) {
      handleBalloonPop();
      balloons.remove(i);
      
      /* child balloons */
      if (balloon[maxHP] >= 100) {
        createBalloons(levelNum, balloon[currPath], 5, 0, 10, 1.5, 30, 77, 173, 255, balloon[distanceTravelled]);
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
