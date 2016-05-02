class Menu {
 float x, y, padding = 30, innerPadding = 10;
 int sizeX, sizeY;
 int bh; //height of all buttons
 Board board;

 Menu(Board board, float posX, float posY, int sizeX, int sizeY, int buttonHeight) {
  x = posX;
  y = posY;
  this.sizeX = sizeX;
  this.sizeY = sizeY;
  this.board = board;
  bh = buttonHeight;
 }

 void display() {
  textSize(32);
  stroke(0);
  fill(170);
  rect(x, y, sizeX, sizeY);

  drawB1(false);
  drawB2(false);
  drawB3(false);
  drawB4(false);
  drawB5(false);
 }

 void drawB1(boolean hover) {
  if (hover) fill(70);
  else fill(100);
  rect(x + padding, y + padding, sizeX - padding * 2, bh);
  fill(255);
  text("Clear", x + padding + innerPadding, y + padding + bh - innerPadding);
 }

 void drawB2(boolean hover) {
  if (hover) fill(0);
  else fill(50);
  rect(x + padding, y + bh + padding * 2, sizeX / 2 - padding, bh);
  fill(255);
  text("Draw", x + padding + innerPadding, y + bh * 2 + padding * 2 - innerPadding);
 }
 
 void drawB3(boolean hover) {
  if (hover) fill(255);
  else fill(205);
  rect(x + sizeX / 2, y + bh + padding * 2, sizeX / 2 - padding, bh);
  fill(0);
  text("Erase", x + innerPadding + sizeX / 2, y + bh * 2 + padding * 2 - innerPadding);
 }
 
 void drawB4(boolean hover) {
  if (hover) fill(0,0,255);
  else fill(0,0,205);
  rect(x + padding, y + bh * 2 + padding * 3, sizeX / 2 - padding, bh);
  fill(255);
  text("Start", x + padding + innerPadding, y + bh * 3 + padding * 3 - innerPadding);
 }
 
 void drawB5(boolean hover) {
  if (hover) fill(0,255,0);
  else fill(0,205,0);
  rect(x + sizeX / 2, y + bh*2 + padding * 3, sizeX / 2 - padding, bh);
  fill(255);
  text("End", x + innerPadding + sizeX / 2, y + (bh + padding) * 3 - innerPadding);
 }

 void listen() {
  if (mouseX > x + padding && mouseX < x + sizeX - padding && mouseY > y + padding && mouseY < y + padding + bh) { //First Button
   drawB1(true);
   if (mousePressed) {
    for (int i = 0; i < board.x; i++) {
     for (int x = 0; x < board.y; x++) {
      board.grab(i, x).wall = false;
      board.grab(i, x).visited = false;
     }
    }
    board.display();
    board.drawWall();
   }
  } else drawB1(false);
  
  if (mouseX > x + padding && mouseX < x + sizeX/2 && mouseY > y + bh + padding*2 && mouseY < y + (bh + padding) * 2) { //Second Button
   drawB2(true);
   if (mousePressed) {
    board.drawWall();
   }
  } else drawB2(false);
  
  if (mouseX > x + sizeX/2 && mouseX < x + sizeX-padding && mouseY > y + bh + padding*2 && mouseY < y + (bh + padding) * 2) { //Third Button
   drawB3(true);
   if (mousePressed) {
    board.drawFree();
   }
  } else drawB3(false);
  
  if (mouseX > x + padding && mouseX < x + sizeX/2 && mouseY > y + bh*2 + padding*3 && mouseY < y + (bh + padding) * 3) { //Fourth Button
   drawB4(true);
   if (mousePressed) {
    board.selectStart();
   }
  } else drawB4(false);
  
  if (mouseX > x + sizeX/2 && mouseX < x + sizeX-padding && mouseY > y + bh*2 + padding*3 && mouseY < y + (bh + padding) * 3) { //Fifth Button
   drawB5(true);
   if (mousePressed) {
    board.selectEnd();
   }
  } else drawB5(false);
 }
}