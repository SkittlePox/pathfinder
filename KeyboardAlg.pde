class KeyboardAlg extends Alg {

  KeyboardAlg(Board board) {
    this.board = board;
  }

  void go() {  //really listen() for manual keyboard controls
    if (run && (x != endX || y != endY)) {
      if (key==CODED) {
        if (keyCode == UP && y != 0 && !board.grab(x, y-1).wall) {
          board.grab(x, y).on = false;
          board.grab(x, y).visited = true;
          board.grab(x, y).display();
          y--;
          if (!board.grab(x, y).visited) visited++;
          board.grab(x, y).visited = true;
          board.grab(x, y).on = true;
          board.grab(x, y).display();
          steps++;
        } else if (keyCode == DOWN && y != board.y-1 && !board.grab(x, y+1).wall) {
          board.grab(x, y).on = false;
          board.grab(x, y).visited = true;
          board.grab(x, y).display();
          y++;
          if (!board.grab(x, y).visited) visited++;
          board.grab(x, y).visited = true;
          board.grab(x, y).on = true;
          board.grab(x, y).display();
          steps++;
        } else if (keyCode == LEFT && x != 0 && !board.grab(x-1, y).wall) {
          board.grab(x, y).on = false;
          board.grab(x, y).visited = true;
          board.grab(x, y).display();
          x--;
          if (!board.grab(x, y).visited) visited++;
          board.grab(x, y).visited = true;
          board.grab(x, y).on = true;
          board.grab(x, y).display();
          steps++;
        } else if (keyCode == RIGHT && x != board.x-1 && !board.grab(x+1, y).wall) {
          board.grab(x, y).on = false;
          board.grab(x, y).visited = true;
          board.grab(x, y).display();
          x++;
          if (!board.grab(x, y).visited) visited++;
          board.grab(x, y).visited = true;
          board.grab(x, y).on = true;
          board.grab(x, y).display();
          steps++;
        }
      }
    }
  }
}