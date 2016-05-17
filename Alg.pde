abstract class Alg {
  Board board;
  int x, y, endX, endY, steps = 0, visited = 1, iterator = 1, time = millis();
  boolean run = false, pause = false, travel = false, pathExists;

  void play() {
    if (!pause) init();
    run = true;
  }

  void kill() {
    steps = 0;
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

  int steps() {
    return steps;
  }
  boolean isRunning() {
    return run;
  }

  void init() {
    steps = 0;
    iterator = 1;
    board.clearAllExceptWalls();
    x = board.start.xi;
    y = board.start.yi;
    endX = board.end.xi;
    endY = board.end.yi;
    pathExists = false;
  }

  abstract void go();
}