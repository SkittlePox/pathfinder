class MazeGen {
  Board board;
  Space[][] subMap;

  MazeGen(Board b) {
    board = b;
    subMap = new Space[b.y/2][b.x/2];
  }

  void makeRand() {
    for (int i = 0; i < board.x; i++) {
      for (int j = 0; j < board.y; j++) {
        if ((int)(Math.random()*3) == 1) {
          board.grab(i, j).touch(0);
        }
      }
    }
  }

  void makeBacktrack() {
    board.clearAll();
    for (int i = 0; i < board.x; i++) {
      for (int j = 0; j < board.y; j++) {
        if (i%2==0 && j%2==0) {
          subMap[i/2][j/2] = new Space(board.grab(i, j), j/2, i/2);
          board.grab(i, j).touch(1);
        } else board.grab(i, j).touch(0);
      }
    }

    Space start = subMap[(int)(Math.random()*board.y/2)][(int)(Math.random()*board.x/2)];
    start.cell.touch(2);
    board.start = start.cell;
    start.visited = true;
    ArrayList<Space> seq = new ArrayList<Space>();
    seq.add(start);
    carve(seq);
    
    Space end = subMap[(int)(Math.random()*board.y/2)][(int)(Math.random()*board.x/2)];
    while(Math.sqrt((start.x-end.x)*(start.x-end.x) + (start.y-end.y)*(start.y-end.y)) < subMap.length/2) {
      end = subMap[(int)(Math.random()*board.y/2)][(int)(Math.random()*board.x/2)];
    }
    end.cell.touch(3);
    board.end = end.cell;
  }

  void carve(ArrayList<Space> sequence) {
    if (sequence.size() == 0) {
      return;
    }
    Space current = sequence.get(sequence.size()-1);
    ArrayList<Space> ns = neighbors(current.x, current.y);
    if (ns.size() > 0) {
      Space next = ns.get((int)(Math.random() * ns.size()));
      sequence.add(next);
      next.visited = true;
      board.grab(current.x+next.x, current.y+next.y).touch(1);
      carve(sequence);
    } else {
      sequence.remove(sequence.size()-1);
      carve(sequence);
    }
  }

  ArrayList<Space> neighbors(int x, int y) {
    ArrayList<Space> ns = new ArrayList<Space>();
    for (int n = -1; n <= 1; n+=2) {
      if (x+n >= 0 && x+n < subMap[0].length && !subMap[y][x+n].visited) ns.add(subMap[y][x+n]);
      if (y+n >= 0 && y+n < subMap.length && !subMap[y+n][x].visited) ns.add(subMap[y+n][x]);
    }
    return ns;
  }
}

class Space {
  Cell cell;
  int x, y;
  boolean visited = false;
  Space(Cell c, int X, int Y) {
    cell = c;
    x = X;
    y = Y;
  }

  public String toString() {
    return cell.toString();
  }
}