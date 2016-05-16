import java.util.ArrayList;

class AStarAlg extends Alg {
  BinaryHeap open;
  ArrayList<Integer> closed = new ArrayList<Integer>();

  AStarAlg(Board board) {
    this.board = board;
  }

  void init() {
    super.init();
    open = new BinaryHeap(board);
    for (int node : closed) {
      board.grab(node).open = true;
    }
    closed.clear();
    open = new BinaryHeap(board);
    travel = false;
  }

  void go() {  //really listen() for manual keyboard controls
    if (run) {
      if (!travel) {
        calc();
      }
      travel(closed);
    }
  }

  void calc() {  //Main A* alg
    int bNode = board.start.id;
    open.add(bNode, bNode);
    for (int z = 0; z < board.x*board.y/2; z++) {
      bNode = open.getMQ();
      if(bNode == -1) break;
      board.grab(bNode).open = false;
      closed.add(bNode);
      if (bNode == board.end.id) break;
      open.add(board.openNeighbors(bNode), bNode);
      System.out.println(open);
    }
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
    int mq = -1;
    if (heap.size()!=1) {
      mq = heap.remove(1);
      if (heap.size()>1) {
        double c1 = board.grab(heap.get(1)).fScore();  //Successor
        int curPos = 1;
        while ((curPos*2 < heap.size() && (c1 > board.grab(heap.get(curPos*2)).fScore())) || ((curPos*2+1 < heap.size()) && c1 > board.grab(heap.get(curPos*2+1)).fScore())) {
          if (curPos*2 + 1 >= heap.size() || board.grab(heap.get(curPos*2)).fScore() < board.grab(heap.get(curPos*2+1)).fScore()) {
            Collections.swap(heap, curPos, curPos*2);
            curPos *= 2;
          } else {
            Collections.swap(heap, curPos, curPos*2+1);
            curPos = curPos * 2 + 1;
          }
        }
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