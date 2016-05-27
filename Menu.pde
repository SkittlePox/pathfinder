class Menu {
  float x, y, padding = 15, innerPadding = 10;
  int sizeX, sizeY, time;
  int bh; //height of all buttons
  Board board;
  Alg alg;
  MazeGen maze;

  Menu(Board board, Alg algorithm, MazeGen m, float posX, float posY, int sizeX, int sizeY, int buttonHeight) {
    x = posX;
    y = posY;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.board = board;
    alg = algorithm;
    maze = m;
    bh = buttonHeight;
    time = millis();
  }

  void display() {
    textSize(32);
    stroke(42, 28, 117);
    fill(77, 200, 242);
    rect(x, y, sizeX, sizeY);

    drawB1(false);
    drawB2(false);
    drawB3(false);
    drawB4(false);
    drawB5(false);
    drawB6(false);
    drawB7(false);
    drawB8(false);
    drawAlgStatus();
  }

  void drawAlgStatus() {
    fill(255);
    rect(x + padding, y + bh * 4 + padding * 5, sizeX - padding*2, bh);
    fill(0);
    //textSize(24);
    text("Steps: " + alg.steps(), x + padding + innerPadding, y + (bh + padding) * 5 - innerPadding*1.5);
    textSize(32);
  }

  void drawB1(boolean hover) {
    if (hover) fill(207, 93, 56);
    else fill(249, 160, 34);
    rect(x + padding, y + padding, sizeX - padding * 2, bh);
    fill(255);
    text("Clear", x + padding + innerPadding, y + padding + bh - innerPadding);
  }

  void drawB2(boolean hover) {
    if (hover) fill(50);
    else fill(0);
    rect(x + padding, y + bh + padding * 2, sizeX / 2 - padding, bh);
    fill(255);
    text("Draw", x + padding + innerPadding, y + bh * 2 + padding * 2 - innerPadding);
  }

  void drawB3(boolean hover) {
    if (hover) fill(205);
    else fill(255);
    rect(x + sizeX / 2, y + bh + padding * 2, sizeX / 2 - padding, bh);
    fill(0);
    text("Erase", x + innerPadding + sizeX / 2, y + bh * 2 + padding * 2 - innerPadding);
  }

  void drawB4(boolean hover) {
    if (hover) fill(0, 0, 255);
    else fill(0, 0, 205);
    rect(x + padding, y + bh * 2 + padding * 3, sizeX / 2 - padding, bh);
    fill(255);
    text("Start", x + padding + innerPadding, y + bh * 3 + padding * 3 - innerPadding);
  }

  void drawB5(boolean hover) {
    if (hover) fill(0, 255, 0);
    else fill(0, 205, 0);
    rect(x + sizeX / 2, y + bh*2 + padding * 3, sizeX / 2 - padding, bh);
    fill(255);
    text("End", x + innerPadding + sizeX / 2, y + (bh + padding) * 3 - innerPadding);
  }

  void drawB6(boolean hover) {
    if (hover) fill(31, 191, 105);
    else fill(31, 107, 58);
    rect(x + padding, y + bh * 3 + padding * 4, sizeX / 2 - padding, bh);
    fill(255);
    text("Play", x + padding + innerPadding, y + (bh + padding) * 4 - innerPadding);
  }

  void drawB7(boolean hover) {
    if (hover) fill(82, 81, 86);
    else fill(161, 160, 166);
    rect(x + sizeX / 2, y + bh*3 + padding * 4, sizeX / 2 - padding, bh);
    fill(255);
    text("Pause", x + innerPadding + sizeX / 2, y + (bh + padding) * 4 - innerPadding);
  }
  
  void drawB8(boolean hover) {
    if (hover) fill(0, 240, 240);
    else fill(0, 255, 255);
    rect(x + padding, y + bh * 5 + padding * 6, sizeX - padding*2, bh);
    fill(0);
    text("RCB Maze!", x + padding + innerPadding, y + (bh + padding) * 6 - innerPadding*1.5);
  }

  void listen() {  //Checks for click
    if (mouseX > x + padding && mouseX < x + sizeX - padding && mouseY > y + padding && mouseY < y + padding + bh) { //First Button
      drawB1(true);
      if (mousePressed) {
        board.clearAll();
        board.drawWall();
        alg.kill();
      }
    } else drawB1(false);

    if (mouseX > x + padding && mouseX < x + sizeX/2 && mouseY > y + bh + padding*2 && mouseY < y + (bh + padding) * 2) { //Second Button
      drawB2(true);
      if (mousePressed) {
        if (alg.isRunning()) {
          board.clearAllExceptWalls();
          alg.kill();
        }
        board.drawWall();
      }
    } else drawB2(false);

    if (mouseX > x + sizeX/2 && mouseX < x + sizeX-padding && mouseY > y + bh + padding*2 && mouseY < y + (bh + padding) * 2) { //Third Button
      drawB3(true);
      if (mousePressed) {
        if (alg.isRunning()) {
          board.clearAllExceptWalls();
          alg.kill();
        }
        board.drawFree();
      }
    } else drawB3(false);

    if (mouseX > x + padding && mouseX < x + sizeX/2 && mouseY > y + bh*2 + padding*3 && mouseY < y + (bh + padding) * 3) { //Fourth Button
      drawB4(true);
      if (mousePressed) {
        if (alg.isRunning()) {
          board.clearAllExceptWalls();
          alg.kill();
        }
        board.selectStart();
      }
    } else drawB4(false);

    if (mouseX > x + sizeX/2 && mouseX < x + sizeX-padding && mouseY > y + bh*2 + padding*3 && mouseY < y + (bh + padding) * 3) { //Fifth Button
      drawB5(true);
      if (mousePressed) {
        if (alg.isRunning()) {
          board.clearAllExceptWalls();
          alg.kill();
        }
        board.selectEnd();
      }
    } else drawB5(false);

    if (mouseX > x + padding && mouseX < x + sizeX/2 && mouseY > y + bh*3 + padding*4 && mouseY < y + (bh + padding) * 4) { //Sixth Button
      drawB6(true);
      if (mousePressed && millis() > time + 500) {
        time = millis();
        if (board.start != null && board.end != null) alg.play();
      }
    } else drawB6(false);

    if (mouseX > x + sizeX/2 && mouseX < x + sizeX-padding && mouseY > y + bh*3 + padding*4 && mouseY < y + (bh + padding) * 4) { //Seventh Button
      drawB7(true);
      if (mousePressed) {
        alg.pause();
      }
    } else drawB7(false);
    
    if (mouseX > x + padding && mouseX < x + sizeX && mouseY > y + bh*5 + padding*6 && mouseY < y + (bh + padding) * 6) { //Eight Button
      drawB8(true);
      if (mousePressed && millis() > time + 500) {
        time = millis();
        if (alg.isRunning()) {
          board.clearAllExceptWalls();
          alg.kill();
        }
        maze.makeBacktrack();
      }
    } else drawB8(false);
  }
}