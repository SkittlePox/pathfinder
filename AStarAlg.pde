import java.util.ArrayList;

class AStarAlg extends Alg {
  BinaryHeap open;
  ArrayList<Integer> closed = new ArrayList<Integer>();
  ArrayList<Integer> path = new ArrayList<Integer>();

  AStarAlg(Board board) {
    this.board = board;
    open = new BinaryHeap(board);
    open.add(-1);
    //for (int i = 0; i < 625; i++) path.add(i);
  }

  void init() {
    super.init();
    open.clear();
    path.clear();
    closed.clear();
  }

  void go() {  //really listen() for manual keyboard controls
    if (run) {
      if (!travel) calc();
      else travel(path);
    }
  }

  void calc() {  //Main A* alg
    //path.add(board.start.id);
    open.add(board.start.id);
    //while (x != endX || y != endY) {
    open.add(board.openNeighbors(board.grab(x, y).id));
    //}
    travel = true;
  }

  void travel(ArrayList<Integer> pathF) {
    if (iterator < pathF.size() && millis() > time + 20) {  //makes sure iterator doesn't go out of bounds and that x ms has passed
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
  }
}

import java.util.Collections;

class BinaryHeap {
  Board board;
  ArrayList<Integer> heap = new ArrayList<Integer>();

  BinaryHeap(Board board) {
    heap.add(-1);
    this.board = board;
  }

  void add(int n) {
    heap.add(n);
    int curPos = heap.size()-1;
    while (board.grab(heap.get(curPos/2)).fScore() > board.grab(n).fScore()) {
      Collections.swap(heap, curPos/2, curPos);
      curPos /= 2;
    }
  }

  int getMQ() {  //Most Qualified
    int mq = heap.remove(1);
    int c1 = heap.get(1);  //Successor
    int curPos = 1;
    while ((heap.get(curPos*2) != null || heap.get(curPos*2+1) != null) && (c1 > heap.get(curPos*2) || c1 > heap.get(curPos*2+1))) {
      if (heap.get(curPos*2 + 1) == null || heap.get(curPos*2) < heap.get(curPos*2+1)) {
        Collections.swap(heap, curPos, curPos*2);
        curPos *= 2;
      } else {
        Collections.swap(heap, curPos, curPos*2+1);
        curPos = curPos * 2 + 1;
      }
    }
    return mq;
  }

  void add(ArrayList<Integer> ns) {
    for (Integer n : ns) add(n);
  }

  void clear() {
    heap.clear();
    heap.add(-1);
  }

  ArrayList<Integer> getHeap() {
    return new ArrayList<Integer>(heap.subList(1, heap.size()));
  }

  String toString() {
    return getHeap().toString();
  }
}