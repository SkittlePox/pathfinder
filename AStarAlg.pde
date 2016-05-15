import java.util.ArrayList;

class AStarAlg extends Alg {
  BinaryHeap open;
  ArrayList<Integer> closed = new ArrayList<Integer>();
  ArrayList<Integer> path = new ArrayList<Integer>();

  AStarAlg(Board board) {
    this.board = board;
  }

  void init() {
    super.init();
    open = new BinaryHeap(board);
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
    int bNode = board.start.id;
    open.add(bNode, bNode);
    //while (x != endX || y != endY) {
    for(int s = 0; s < 10; s++) {
      //Implement A* here
      open.add(board.openNeighbors(board.grab(x, y).id), bNode);
    }
    System.out.println(open);
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
  int end;
  ArrayList<Integer> heap = new ArrayList<Integer>();

  BinaryHeap(Board board) {
    heap.add(-1);
    end = board.end.id;
    this.board = board;
  }

  void add(int n, int b) {
    if (!heap.contains(n)) {
      heap.add(n);
      board.grab(n).calcFScore(b, end);
      int curPos = heap.size()-1;
      while (curPos/2 != 0 && board.grab(heap.get(curPos/2)).fScore() > board.grab(n).fScore()) {
        Collections.swap(heap, curPos/2, curPos);
        curPos /= 2;
      }
    }
  }

  int getMQ() {  //Most Qualified
    int mq = heap.remove(1);
    double c1 = board.grab(heap.get(1)).fScore();  //Successor
    int curPos = 1;
    while ((heap.get(curPos*2) != null || heap.get(curPos*2+1) != null) && (c1 > board.grab(heap.get(curPos*2)).fScore() || c1 > board.grab(heap.get(curPos*2+1)).fScore())) {
      if (heap.get(curPos*2 + 1) == null || board.grab(heap.get(curPos*2)).fScore() < board.grab(heap.get(curPos*2+1)).fScore()) {
        Collections.swap(heap, curPos, curPos*2);
        curPos *= 2;
      } else {
        Collections.swap(heap, curPos, curPos*2+1);
        curPos = curPos * 2 + 1;
      }
    }
    return mq;
  }

  void add(ArrayList<Integer> ns, int b) {
    for (Integer n : ns) add(n, b);
  }

  ArrayList<Integer> getHeap() {
    return new ArrayList<Integer>(heap.subList(1, heap.size()));
  }

  String toString() {
    return getHeap().toString();
  }
}