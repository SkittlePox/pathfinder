Board board;
Menu menu;
Alg manual, astar;
int gridX = 25, gridY = 25, px = 25, offset = (700 - gridY * px) / 2;  //px is side of each cell, offset is space to the left of board

void setup() {
  fill(255, 227, 159);
  stroke(255, 227, 159);
  size(1050, 700);
  rect(0, 0, width, height);
  board = new Board(gridX, gridY, px, offset);
  manual = new KeyboardAlg(board);
  astar = new AStarAlg(board);
  menu = new Menu(board, astar, gridY * px + 700 - gridY * px, (700 - gridY * px) / 2, 300, 600, 50);
  menu.display();
  board.display();
}

void draw() {
  board.listen();
  menu.listen();
  menu.drawAlgStatus();
  astar.go();
}

void keyPressed() {
  //manual.go();
}