void roundRect(float x, float y, float wid, float hgt, float cornerX, float cornerY) {

  ellipseMode(CENTER);
  rectMode(CORNER);

  stroke(0);
  arc(x + cornerX/2, y + cornerY/2, cornerX, cornerY, PI, PI+HALF_PI);
  arc(x + cornerX/2, y + hgt - cornerY/2, cornerX, cornerY, HALF_PI, PI);
  arc(x + wid - cornerX/2, y + hgt - cornerY/2, cornerX, cornerY, 0, HALF_PI);
  arc(x + wid - cornerX/2, y + cornerY/2, cornerX, cornerY, PI+HALF_PI, PI+PI);

  noStroke();
  rect(x + cornerX/2 - 1, y, wid - cornerX + 2, cornerY/2);
  rect(x + cornerX/2 - 1, y + hgt - cornerY/2, wid - cornerX + 2, cornerY/2);
  rect(x, y + cornerY/2 - 1, cornerX/2, hgt - cornerY + 2);
  rect(x + wid - cornerX/2, y + cornerY/2 - 1, cornerX/2, hgt - cornerY + 2);
  rect(x + cornerX/2 - 1, y + cornerY/2 - 1, wid - cornerX + 2, hgt - cornerY + 2);

  stroke(0);
  line(x + cornerX/2, y, x + wid - cornerX/2, y);
  line(x + cornerX/2, y + hgt, x + wid - cornerX/2, y + hgt);
  line(x, y + cornerY/2, x, y + hgt - cornerY/2);
  line(x + wid, y + cornerY/2, x + wid, y + hgt - cornerY/2);
}

void roundRect(float x, float y, float wid, float hgt, float cornerX, float cornerY, color col) {

  ellipseMode(CENTER);
  rectMode(CORNER);

  stroke(col);
  arc(x + cornerX/2, y + cornerY/2, cornerX, cornerY, PI, PI+HALF_PI);
  arc(x + cornerX/2, y + hgt - cornerY/2, cornerX, cornerY, HALF_PI, PI);
  arc(x + wid - cornerX/2, y + hgt - cornerY/2, cornerX, cornerY, 0, HALF_PI);
  arc(x + wid - cornerX/2, y + cornerY/2, cornerX, cornerY, PI+HALF_PI, PI+PI);

  noStroke();
  rect(x + cornerX/2 - 1, y, wid - cornerX + 2, cornerY/2);
  rect(x + cornerX/2 - 1, y + hgt - cornerY/2, wid - cornerX + 2, cornerY/2);
  rect(x, y + cornerY/2 - 1, cornerX/2, hgt - cornerY + 2);
  rect(x + wid - cornerX/2, y + cornerY/2 - 1, cornerX/2, hgt - cornerY + 2);
  rect(x + cornerX/2 - 1, y + cornerY/2 - 1, wid - cornerX + 2, hgt - cornerY + 2);

  stroke(col);
  line(x + cornerX/2, y, x + wid - cornerX/2, y);
  line(x + cornerX/2, y + hgt, x + wid - cornerX/2, y + hgt);
  line(x, y + cornerY/2, x, y + hgt - cornerY/2);
  line(x + wid, y + cornerY/2, x + wid, y + hgt - cornerY/2);
}
