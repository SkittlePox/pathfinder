class GenMenu {
  AlgHandler hanlder;

  int algCount = 0;

  float x, y, padding = 15, innerPadding = 10;
  int sizeX, sizeY, bh;

  GenMenu(AlgHandler h, float posX, float posY, int sizeX, int sizeY, int buttonHeight) {
    handler = h;

    x = posX;
    y = posY;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    bh = buttonHeight;
  }

  void display() {
    stroke(42, 28, 117);
    fill(50, 178, 50);
    rect(x, y, sizeX, sizeY);
    
    drawH1();
    drawAlgInfo();
  }
  
  void drawH1() {
    rect(x + padding, y + padding*2 + bh, sizeX - padding * 2, bh);
    fill(255);
    text("Species ID: "+ handler.main.id, x + padding, y + padding + bh - innerPadding);
  }
  
  void drawAlgInfo() {
    fill(100, 150, 20);
    rect(x + padding, y + padding*2 + bh, sizeX - padding * 2, bh*3);
    fill(255);
    textSize(24);
    text("Vision- " + handler.main.vision, x + padding + innerPadding, y + bh*2 + padding);
    text("Speed- " + handler.main.speed, x + padding + innerPadding, y + bh*3 + padding);
    text("Cognition- " + handler.main.cognition, x + padding + innerPadding, y + bh*4 + padding);
    textSize(32);
  }

  void drawB1(boolean hover) {
    if (hover) fill(207, 93, 56);
    else fill(249, 160, 34);
    rect(x + padding, y + padding*2 + bh, sizeX - padding * 2, bh);
    fill(255);
    text("Clear", x + padding + innerPadding, y + (padding + bh)*2 - innerPadding);
  }
}