int framesSinceLost = 0;
void drawLostAnimation() {
  framesSinceLost++;

  float alpha = 166 * framesSinceLost / 80;
  if (alpha > 166) alpha = 166;
  fill(127, alpha);
  rectMode(CORNER);
  noStroke();
  rect(0, 0, width, height);

  float textAlpha = 255 * (framesSinceLost - 80) / 80;
  if (textAlpha > 255); 
  textAlpha = 255;
  fill(255, textAlpha);
  textSize(70);
  //       800, 500
  //text("YOU LOST...", 265, 260);

  text("YOU LOST...", 865, 410);
}
