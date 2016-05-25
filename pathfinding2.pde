Board board;
Menu menu;
Alg manual, astar;
MazeGen maze;
int gridX = 50, gridY = 50, px = 14, offset = 40;  //px is side of each cell, offset is space to the left of board

void setup() {
  fill(255, 227, 159);
  stroke(255, 227, 159);
  size(1250, 800);
  rect(0, 0, width, height);
  board = new Board(gridX, gridY, px, offset);
  maze = new MazeGen(board);
  manual = new KeyboardAlg(board);
  astar = new AStarAlg(board);
  menu = new Menu(board, astar, maze, gridY * px + 800 - gridY * px, (800 - gridY * px) / 2, 300, 600, 50);
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