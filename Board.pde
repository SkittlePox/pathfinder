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
          grid[i][x].parent = -1;
          grid[i][x].sealed = false;
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
        grid[i][x].parent = -1;
        grid[i][x].sealed = false;
        grid[i][x].marked = false;
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
    boolean n = false, e = false, s = false, w = false;

    for (int i = -1; i <= 1; i+=2) {
      if (tempX+i >= 0 && tempX+i < x && !grab(tempX+i, tempY).wall) {
        if (grab(tempX+i, tempY).open) neighbors.add(grab(tempX+i, tempY).id);
        if (i == -1) w = true;
        if (i == 1) e = true;
      }
      if (tempY+i >= 0 && tempY+i < y && !grab(tempX, tempY+i).wall) {
        if (grab(tempX, tempY+i).open) neighbors.add(grab(tempX, tempY+i).id);
        if (i == -1) n = true;
        if (i == 1) s = true;
      }
    }

    if (n) {
      if (w && !grab(tempX-1, tempY-1).wall && grab(tempX-1, tempY-1).open) {
        neighbors.add(grab(tempX-1, tempY-1).id);
      }
      if (e && !grab(tempX+1, tempY-1).wall && grab(tempX+1, tempY-1).open) {
        neighbors.add(grab(tempX+1, tempY-1).id);
      }
    }
    if (s) {
      if (w && !grab(tempX-1, tempY+1).wall && grab(tempX-1, tempY+1).open) {
        neighbors.add(grab(tempX-1, tempY+1).id);
      }
      if (e && !grab(tempX+1, tempY+1).wall && grab(tempX+1, tempY+1).open) {
        neighbors.add(grab(tempX+1, tempY+1).id);
      }
    }

    return neighbors;
  }
  
  ArrayList<Integer> visibleOpenNeighbors(int id, int r) {  //Plus formation only!!!
    ArrayList<Integer> neighbors = new ArrayList<Integer>();
    int tempX = grab(id).yi, tempY = grab(id).xi;
    int count = 1;

    for (int i = -1; i < 2; i+=2) {
      while (tempY-(i* count) >= 0 && tempY-(i* count) < board.y && count <= r) {
        if (!grab(tempX, tempY-(i*count)).wall && grab(tempX, tempY-(i*count)).open) {
          neighbors.add(grab(tempX, tempY-(i*count)).id);
        } else break;
        count++;
      }
      count = 1;
      while (tempX-(i*count) >= 0 && tempX-(i*count) < board.x && count <= r) {
        if (!grab(tempX-(i*count), tempY).wall && grab(tempX-(i*count), tempY).open) {
          neighbors.add(grab(tempX-(i*count), tempY).id);
        } else break;
        count++;
      }
      count = 1;
    }

    return neighbors;
  }
}

class Cell {
  float x, y;
  int xi, yi, size, id, parent;  //xi and yi are board indices
  double f;
  boolean visited = false, wall = false, start = false, end = false, on = false, open = true, sealed = false, marked = false;

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
    if (end) fill(0, 255, 0);
    else if (on) fill(255, 204, 0);
    else if (wall) fill(0);
    else if (start) fill(0, 0, 255);
    else if (marked) fill(208, 80, 208);
    else if (sealed) fill(50, 160, 50);
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
      if (mouseButton == RIGHT) {
        draw = 1;
      }
      if (draw == 0) {
        wall = true;
        start = false;
        end = false;
        open = false;
        visited = false;
        marked = false;
      } else if (draw == 1) {
        wall = false;
        start = false;
        end = false;
        open = true;
        visited = false;
        marked = false;
      } else if (draw == 2) {
        wall = false;
        end = false;
        start = true;
        open = true;
        visited = false;
        marked = false;
        newStatus = 1;
      } else if (draw == 3) {
        wall = false;
        start = false;
        end = true;
        open = true;
        visited = false;
        marked = false;
        newStatus = 2;
      } else if (draw == 4) {
        wall = false;
        open = true;
        visited = false;
        marked = true;
      }
      display();
    }
    return newStatus;
  }

  void touch(int draw) {
    if (draw == 0) {
      wall = true;
      start = false;
      end = false;
      open = false;
      visited = false;
      marked = false;
    } else if (draw == 1) {
      wall = false;
      start = false;
      end = false;
      open = true;
      marked = false;
      visited = false;
    } else if (draw == 2) {
      wall = false;
      end = false;
      start = true;
      open = true;
      visited = false;
      marked = false;
    } else if (draw == 3) {
      wall = false;
      start = false;
      end = true;
      open = true;
      visited = false;
      marked = false;
    } else if (draw == 4) {
      wall = false;
      open = true;
      visited = false;
      marked = true;
    }
    display();
  }

  public String toString() {
    return "" + id;
  }
}