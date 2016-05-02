class Board {
 Cell[][] grid;
 Cell start, end;
 int pxsize, offset;
 int x, y;
 int draw = 0;

 Board(int x, int y, int size, int offset) {
  grid = new Cell[x][y];
  this.x = x;
  this.y = y;
  pxsize = size;
  this.offset = offset;

  for (int i = 0; i < grid.length; i++) {
   for (int j = 0; j < grid[i].length; j++) {
    grid[i][j] = new Cell(i * pxsize + offset, j * pxsize + offset, pxsize);
   }
  }
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
    if(status == 1) {
      if(start == null) {
        start = grid[i][j];
      }
      else if(grid[i][j] != start) {
       start.start = false;
       start.display();
       start = grid[i][j];
     }
    } else if(status == 2) {
      if(end == null) {
        end = grid[i][j];
      }
      else if(grid[i][j] != end) {
       end.end = false;
       end.display();
       end = grid[i][j];
     }
    }
   }
  }
  if(start != null && !start.start) start = null;
  if(end != null && !end.end) end = null;
 }
 
 void display() {
  for (int i = 0; i < grid.length; i++) {
   for (int j = 0; j < grid[i].length; j++) {
    grid[i][j].display();
   }
  }
 }

 Cell grab(int ix, int iy) {
  return grid[ix][iy];
 }
}

class Cell {
 float x, y;
 int size;
 boolean visited = false, wall = false, start = false, end = false;

 Cell(float x, float y, int px) {
  this.x = x;
  this.y = y;
  size = px;
 }

 void display() {
  stroke(0);
  if (visited) fill(255, 255, 0);
  else if (wall) fill(0);
  else if (start) fill(0,0,255);
  else if (end) fill(0,255,0);
  else fill(255);
  rect(x, y, size, size);
 }

 int listen(int draw) {
  int newStatus = 0;
  if (mouseX > x && mouseX < x + size && mouseY > y && mouseY < y + size && mousePressed) {
    if(draw == 0) {
      wall = true;
      start = false;
      end = false;
    }
    else if(draw == 1) {
      wall = false;
      start = false;
      end = false;
    }
    else if(draw == 2) {
      wall = false;
      end = false;
      start = true;
      newStatus = 1;
    }
    else if(draw == 3) {
      wall = false;
      start = false;
      end = true;
      newStatus = 2;
    }
    display();
  }
  return newStatus;
 }
}