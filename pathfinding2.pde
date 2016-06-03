Board board;
Menu menu;
GenMenu gmenu;
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
  //s1 = new Species(board, 5, 5, 5);

  handler = new AlgHandler(astar);
  //handler.add(s1);
  //handler.add(astar);
  //handler.main = s1;
  createCreatures();

  menu = new Menu(board, handler, maze, gridX * px + offset*2, offset, 250, gridY*px, 50);
  gmenu = new GenMenu(handler, gridX * px + offset*3 + 250, offset, 250, gridY*px, 50);
  menu.display();
  board.display();
}

void createCreatures() {
  for(int i = 0; i < 10; i++) {
    int v = (int)(Math.random() * 16);
    int s = (int)(Math.random() * (16-v));
    int c = 15-(v+s);
    Species sp = new Species(board, v, s, c);
    sp.id = i;
    handler.add(sp);
  }
}

void draw() {
  board.listen();
  menu.listen();
  menu.drawAlgStatus();
  gmenu.display();
  handler.go();
}

void keyPressed() {
  //manual.go();
}