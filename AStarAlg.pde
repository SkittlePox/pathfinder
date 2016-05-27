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
    for (int node : closed) {
      board.grab(node).open = true;
    }
    closed.clear();
    path.clear();
    open = new BinaryHeap(board);
    open.end = board.end.id;
    travel = false;
  }

  void go() {  //really listen() for manual keyboard controls
    if (run) {
      if (!travel) {
        calc();
      }
      if (pathExists) {
        travel(path);
      }
    }
  }

  void calc() {  //Main A* alg
    int bNode = board.start.id;
    open.add(bNode, bNode);
    for (int z = 0; z < board.x*board.y; z++) {
      bNode = open.getMQ();
      if (bNode == -1) break;
      board.grab(bNode).open = false;
      closed.add(bNode);
      if (bNode == board.end.id) break;
      open.add(board.openNeighbors(bNode), bNode);
    }

    int curNode = board.end.id;
    if (board.end.parent != -1) {
      while (curNode != board.start.id) {
        path.add(0, curNode);
        curNode = board.grab(curNode).parent;
      }
      pathExists = true;
    }

    travel = true;
  }
}

import java.util.Collections;

class BinaryHeap {
  Board board;
  int end;
  ArrayList<Integer> heap = new ArrayList<Integer>();

  BinaryHeap(Board board) {
    heap.add(-1);
    this.board = board;
  }

  void add(int n, int b) {
    if (!heap.contains(n)) {
      heap.add(n);
      board.grab(n).calcFScore(b, end);
      board.grab(n).parent = b;
      int curPos = heap.size()-1;
      while (curPos/2 != 0 && board.grab(heap.get(curPos/2)).fScore() > board.grab(n).fScore()) {
        Collections.swap(heap, curPos/2, curPos);
        curPos /= 2;
      }
    } else {
      double preScore = board.grab(n).fScore();
      if (board.grab(n).calcFScore(b, end) < preScore) {
        board.grab(n).parent = b;
        int curPos = heap.indexOf(n);
        double c1 = board.grab(n).fScore();

        while (curPos != 1 && board.grab(heap.get(curPos/2)).fScore() > c1) {
          Collections.swap(heap, curPos, curPos/2);
        }
      } else {
        board.grab(n).f = preScore;
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

  public String toString() {
    return getHeap().toString();
  }
}

class SimpleAStar {
  BinaryHeap open;
  Board board;
  ArrayList<Integer> closed = new ArrayList<Integer>();
  ArrayList<Integer> path = new ArrayList<Integer>();

  SimpleAStar(Board board) {
    this.board = board;
  }

  ArrayList<Integer> calc(Cell start, Cell end) {
    open = new BinaryHeap(board);
    open.end = end.id;
    for (int node : closed) {
      board.grab(node).open = true;
    }
    closed.clear();
    path.clear();

    int bNode = start.id;
    open.add(bNode, bNode);
    for (int z = 0; z < board.x*board.y; z++) {
      bNode = open.getMQ();
      if (bNode == -1) break;
      board.grab(bNode).open = false;
      closed.add(bNode);
      if (bNode == end.id) break;
      open.add(board.openNeighbors(bNode), bNode);
    }

    int curNode = end.id;
    if (end.parent != -1) {
      while (curNode != start.id) {
        path.add(0, curNode);
        curNode = board.grab(curNode).parent;
      }
    }

    return path;
  }
}

class testAlg extends Alg {
  SimpleAStar aStar;
  ArrayList<Integer> path = new ArrayList<Integer>();

  testAlg(Board board) {
    this.board = board;
  }

  void go() {
    if (run) {
      if (!travel) {
        aStar = new SimpleAStar(board);
        path = aStar.calc(board.start, board.end);
        travel = true;
      } else {
        if (path.size() > 0) travel(path);
      }
    }
  }
}