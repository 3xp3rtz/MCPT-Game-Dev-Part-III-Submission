/** Currency system for tower defense
 *  - Rewards player for popping balloon
 *  - Keeps track of balance
 *  - Checks for sufficient funds when purchasing tower
 */

// Current amount of money owned by the player
int currentBalance = 1500; // Give the user $1500 of starting balance
final int rewardPerBalloon = 15; // Money earned by popping a balloon
final int baseRewardPerWave = 10; //base money earned per wave

void handleBalloonPop() {
  // Reward the player for popping the balloon
  increaseBalance(rewardPerBalloon * (levelNum + 1));
}


void increaseBalance(int amount) {
  currentBalance += amount; // Increase the current balance by the amount given
}

//method to give user money for completing a wave
void handleWaveReward(int waveNum) {
  increaseBalance(baseRewardPerWave * waveNum);
}

/** Checks to see if there is sufficient balance for purchasing a certain item
 *  Parameter "cost" is the cost of the tower to be purchased
 */
boolean hasSufficientFunds(int cost) {
  if (currentBalance < cost) {
    return false; // Not enough money to purchase the tower
  } else {
    return true; // Enough money to purchase the tower
  }
}

/** Purchases a tower
 *  Parameter "cost" is the cost of the tower to be purchased
 */
void purchaseTower(int cost) {
  currentBalance -= cost;
}

// Checks to see if the user is attempting to purchase/pick up a tower but has insufficient funds
boolean attemptingToPurchaseTowerWithoutFunds(int towerID) {
  if (towerID == -1 || towerID >= 100 || towerID >= 10) return false;
  return (currentlyDragging == buttonHovered() && !hasSufficientFunds(towerPrice[towerID]) ? true : false);
}

// Displays the user's current balance on the screen
void drawBalanceDisplay() {

  // If the user is attempting to purchase a tower without funds, warn them with red display text
  rectMode(CORNER);
  fill(43, 214, 76);
  rect(width-680, height-125, 345, 85);
  fill(57, 255, 94);
  rect(width-665, height-110, 315, 55);

  imageMode(CENTER);
  image(moneyBag, width-640, height-85, 80, 80);

  fill (mousePressed && attemptingToPurchaseTowerWithoutFunds(buttonHovered()) ? towerErrorColour : 0);
  PFont balanceFont = loadFont("LucidaSans-Demi-20.vlw");
  textFont(balanceFont);
  text("Current Balance: $" + currentBalance, width-610, height-75);
}
