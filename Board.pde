class Board {
  Cell[][] grid;
  ArrayList<Cell> cells;
  Cell start, end;
  int pxsize, offset;
  int x, y;
  int draw = 0;

  Board(int x, int y, int size, int offset) {
    grid = new Cell[x][y];
    cells = new ArrayList<Cell>();
    this.x = x;
    this.y = y;
    pxsize = size;
    this.offset = offset;

    int id = 0;
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        grid[i][j] = new Cell(j * pxsize + offset, i * pxsize + offset, pxsize, j, i, id);
        cells.add(grid[i][j]);
        id++;
      }
    }
  }

  double nodeDist(int a, int b) {
    return Math.sqrt(Math.abs(grab(a).xi-grab(b).xi)*Math.abs(grab(a).xi-grab(b).xi) + Math.abs(grab(a).yi-grab(b).yi)*Math.abs(grab(a).yi-grab(b).yi));
  }

  void drawWall() {
    draw = 0;
  }

  void drawFree() {
    draw = 1;
  }

  void selectStart() {
    draw = 2;
  }

  void selectEnd() {
    draw = 3;
  }

  void listen() {
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        int status = grid[i][j].listen(draw);
        if (status == 1) {
          if (start == null) {
            start = grid[i][j];
          } else if (grid[i][j] != start) {
            start.start = false;
            start.display();
            start = grid[i][j];
          }
        } else if (status == 2) {
          if (end == null) {
            end = grid[i][j];
          } else if (grid[i][j] != end) {
            end.end = false;
            end.display();
            end = grid[i][j];
          }
        }
      }
    }
    if (start != null && !start.start) start = null;
    if (end != null && !end.end) end = null;
  }

  void display() {
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        grid[j][i].display();
      }
    }
  }

  void clearAllExceptWalls() {
    for (int i = 0; i < board.x; i++) {
      for (int x = 0; x < board.y; x++) {
        if (!grid[i][x].wall) {
          grid[i][x].visited = false;
          grid[i][x].open = true;
          grid[i][x].on = false;
        }
      }
    }
    display();
  }

  void clearAll() {
    for (int i = 0; i < board.x; i++) {
      for (int x = 0; x < board.y; x++) {
        grid[i][x].wall = false;
        grid[i][x].open = true;
        grid[i][x].visited = false;
        grid[i][x].on = false;
      }
    }
    display();
  }

  Cell grab(int ix, int iy) {
    return grid[ix][iy];
  }

  Cell grab(int id) {
    return cells.get(id);
  }

  ArrayList<Integer> openNeighbors(int id) {
    ArrayList<Integer> neighbors = new ArrayList<Integer>();
    int tempX = grab(id).yi, tempY = grab(id).xi;
    for (int i = tempX-1; i <= tempX+1; i++) {
      for (int j = tempY-1; j <= tempY+1; j++) {
        if (j>=0 && j<y && i>=0 && i<x) {
          if ((j != tempY || i != tempX) && grab(i, j).open && !grab(i, j).wall && grab(i, j).open) {
            neighbors.add(grab(i, j).id);
          }
        }
      }
    }
    return neighbors;
  }
}

class Cell {
  float x, y;
  int xi, yi, size, id, parent;  //xi and yi are board indices
  double f;
  boolean visited = false, wall = false, start = false, end = false, on = false, open = true;

  Cell(float x, float y, int px, int xi, int yi, int i) {
    this.x = x;
    this.y = y;
    this.xi = xi;
    this.yi = yi;
    id = i;
    size = px;
    parent = -1;
  }

  double calcFScore(int b, int e) {
    f = board.nodeDist(id, b) + board.nodeDist(id, e);
    return f;
  }

  double fScore() {
    return f;
  }

  void display() {
    stroke(0);
    if (on) fill(255, 204, 0);
    else if (wall) fill(0);
    else if (end) fill(0, 255, 0);
    else if (start) fill(0, 0, 255);
    else if (visited) fill(255, 255, 0);
    else fill(255);
    rect(x, y, size, size);
    //textSize(12);
    //fill(127);
    //text(id, x, y + size);
    //textSize(32);
  }

  int listen(int draw) {
    int newStatus = 0;
    if (mouseX > x && mouseX < x + size && mouseY > y && mouseY < y + size && mousePressed) {
      if (draw == 0) {
        wall = true;
        start = false;
        end = false;
        open = false;
      } else if (draw == 1) {
        wall = false;
        start = false;
        end = false;
        open = true;
      } else if (draw == 2) {
        wall = false;
        end = false;
        start = true;
        open = true;
        newStatus = 1;
      } else if (draw == 3) {
        wall = false;
        start = false;
        end = true;
        open = true;
        newStatus = 2;
      }
      display();
    }
    return newStatus;
  }
}