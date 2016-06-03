abstract class Alg {
  Board board;
  int id = -1, x, y, endX, endY, steps = 0, visited = 1, iterator = 1, time = millis(), eunits = 0, travelTime = 20;
  int vision = -1, speed = -1, cognition = -1;
  boolean run = false, pause = false, travel = false, pathExists;

  void play() {
    if (!pause) init();
    run = true;
  }

  void kill() {
    steps = 0;
    eunits = 0;
    iterator = 1;
    run = false;
    travel = false;
    pause = false;
  }

  void pause() {
    if (x != endX || y != endY) {
      run = false;
      pause = true;
    }
  }
  
  boolean isRunning() {
    return run;
  }

  void init() {
    steps = 0;
    eunits = 0;
    iterator = 1;
    board.clearAllExceptWalls();
    x = board.start.xi;
    y = board.start.yi;
    endX = board.end.xi;
    endY = board.end.yi;
    pathExists = false;
  }
  
  void travel(ArrayList<Integer> pathF) {
    if (iterator < pathF.size() && millis() > time + travelTime) {  //makes sure iterator doesn't go out of bounds and that x ms has passed
      time = millis();
      x = board.grab(pathF.get(iterator)).xi;  //Updates coordinate values
      y = board.grab(pathF.get(iterator)).yi;

      board.grab(pathF.get(iterator-1)).on = false;  //Handles previous node
      board.grab(pathF.get(iterator-1)).visited = true;
      board.grab(pathF.get(iterator-1)).display();

      if (!board.grab(pathF.get(iterator)).visited) visited++;  //So as to not overcount visited

      board.grab(pathF.get(iterator)).visited = true;  //Handles current node
      board.grab(pathF.get(iterator)).on = true;
      board.grab(pathF.get(iterator)).display();

      steps++;  //Iterates
      iterator++;
    }
    if (iterator == pathF.size() && millis() > time + travelTime) {
      for (int i = 0; i < iterator; i++) {
        board.grab(pathF.get(i)).sealed = true;
        board.grab(pathF.get(i)).display();
      }
      iterator++;
    }
  }

  abstract void go();
}