class KeyboardAlg extends Alg {

  KeyboardAlg(Board board) {
    this.board = board;
  }

  void go() {  //reallx listen() for manual keyboard controls
    if (run && (y != endX || x != endY)) {
      if (key==CODED) {
        if (keyCode == LEFT && x != 0 && !board.grab(y, x-1).wall) {
          board.grab(y, x).on = false;
          board.grab(y, x).visited = true;
          board.grab(y, x).display();
          x--;
          if (!board.grab(y, x).visited) visited++;
          board.grab(y, x).visited = true;
          board.grab(y, x).on = true;
          board.grab(y, x).display();
          steps++;
        } else if (keyCode == RIGHT && x != board.x-1 && !board.grab(y, x+1).wall) {
          board.grab(y, x).on = false;
          board.grab(y, x).visited = true;
          board.grab(y, x).display();
          x++;
          if (!board.grab(y, x).visited) visited++;
          board.grab(y, x).visited = true;
          board.grab(y, x).on = true;
          board.grab(y, x).display();
          steps++;
        } else if (keyCode == UP && y != 0 && !board.grab(y-1, x).wall) {
          board.grab(y, x).on = false;
          board.grab(y, x).visited = true;
          board.grab(y, x).display();
          y--;
          if (!board.grab(y, x).visited) visited++;
          board.grab(y, x).visited = true;
          board.grab(y, x).on = true;
          board.grab(y, x).display();
          steps++;
        } else if (keyCode == DOWN && y != board.y-1 && !board.grab(y+1, x).wall) {
          board.grab(y, x).on = false;
          board.grab(y, x).visited = true;
          board.grab(y, x).display();
          y++;
          if (!board.grab(y, x).visited) visited++;
          board.grab(y, x).visited = true;
          board.grab(y, x).on = true;
          board.grab(y, x).display();
          steps++;
        }
      }
    }
  }
}