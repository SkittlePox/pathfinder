class Species extends Alg{
  SimpleAStar astar;
  ArrayList<Integer> path;
  int vision, speed, cognition, id;
  double units = 0;

  Species(Board board, int v, int s, int c, int ID) {
    this.board = board;
    vision = v;
    speed = s;
    cognition = c;
    id = ID;
    if (v+s+c > 60) {
      vision = 20;
      speed = 20;
      cognition = 20;
    }
    astar = new SimpleAStar(board);
    path = new ArrayList<Integer>();
  }
  
  void go() {
    if (run) {
      if (!travel) {
        calc();
      }
      if (pathExists) {
        travel(path);
      }
    }
  }
  
  void calc() {
    endX = board.end.xi;
    endY = board.end.yi;
    x = board.start.xi;
    y = board.start.yi;
    for(int i = 0; i < 100; i++) {
      //route calc code
      //units+= 1*some constant
    }
  }
}