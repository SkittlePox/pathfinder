import controlP5.*;

Board board;
Menu menu;
Alg manual, astar, s1;
AlgHandler handler;
MazeGen maze;
int gridX = 50, gridY = 50, px = 15, offset = 20;  //px is side of each cell, offset is space to the left of board

void setup() {
  fill(255, 227, 159);
  stroke(255, 227, 159);
  size(1350, 800);
  rect(0, 0, width, height);
  board = new Board(gridX, gridY, px, offset);
  maze = new MazeGen(board);
  manual = new KeyboardAlg(board);
  astar = new AStarAlg(board);
  s1 = new Species(board, 20, 20, 20);
  handler = new AlgHandler();
  handler.algs.add(s1);
  handler.algs.add(astar);
  handler.main = s1;
  menu = new Menu(board, handler, maze, gridX * px + offset*2, offset, 250, gridY*px, 50);
  menu.display();
  board.display();
  board.readMaze("maze.txt");
}

void draw() {
  board.listen();
  menu.listen();
  menu.drawAlgStatus();
  handler.go();
}

void keyPressed() {
  //manual.go();
}