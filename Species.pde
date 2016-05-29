class Species extends Alg {
  SimpleAStar astar;
  ArrayList<Integer> path, possibles;
  int vision, speed, cognition, id = -1, count = 1, mIndex = 1;
  double units = 0, propConstant = 0.5;

  Species(Board board, int v, int s, int c) {
    this.board = board;
    vision = v;
    speed = s;
    cognition = c;
    if (v+s+c > 60) {
      vision = 20;
      speed = 20;
      cognition = 20;
    }
    astar = new SimpleAStar(board);
    path = new ArrayList<Integer>();
    possibles = new ArrayList<Integer>();
  }

  void go() {
    if (run) {
      if (!travel) {
        calc();
        travel = true;
      }
      if (path.size() > 0) {
        travel(path);
      }
    }
  }

  void calc() {
    endX = board.end.xi;
    endY = board.end.yi;
    x = board.start.xi;
    y = board.start.yi;
    possibles.clear();
    path.clear();
    int curnode = board.start.id;
    for (int i = 0; i < Math.pow(board.x * board.y, 3); i++) {
      possibles.addAll(board.visibleOpenNeighbors(curnode, vision/5));
      possibles.removeAll(path);
      if (possibles.size() > 0) {
        int nextnode = possibles.get(0);
        for (Integer pos : possibles) {
          if (board.nodeDist(pos, board.end.id)*propConstant + board.nodeDist(curnode, pos) <
          board.nodeDist(nextnode, board.end.id)* propConstant + board.nodeDist(curnode, nextnode)) {  //Edit this conditional - account for memory of previous routes
            nextnode = pos;
          }
        }
        ArrayList<Integer> newPath = astar.calc(board.grab(curnode), board.grab(nextnode));
        path.addAll(newPath);
        curnode = nextnode;
        if (curnode == board.end.id) break;
        //board.grab(nextnode).touch(4);
      } else break;
      //units+= 1*some constant
    }
  }

  void travel(ArrayList<Integer> pathF) {
    if (iterator < pathF.size() && millis() > time + 20) {  //makes sure iterator doesn't go out of bounds and that x ms has passed
      time = millis();
      System.out.println(pathF.get(iterator));
      x = board.grab(pathF.get(iterator)).xi;  //Updates coordinate values
      y = board.grab(pathF.get(iterator)).yi;

      if (pathF.get(iterator-1) >= 0) {
        board.grab(pathF.get(iterator-1)).on = false;  //Handles previous node
        board.grab(pathF.get(iterator-1)).visited = true;
        board.grab(pathF.get(iterator-1)).display();
      }

      if (!board.grab(pathF.get(iterator)).visited) visited++;  //So as to not overcount visited

      board.grab(pathF.get(iterator)).visited = true;  //Handles current node
      board.grab(pathF.get(iterator)).on = true;
      board.grab(pathF.get(iterator)).display();

      steps++;  //Iterates
      iterator++;
      count++;
    }
    if (iterator == pathF.size() && millis() > time + 20) {
      for (int i = 0; i < iterator; i++) {
        board.grab(pathF.get(i)).sealed = true;
        board.grab(pathF.get(i)).display();
      }
      iterator++;
    }
  }
}

class RouteList {
  SimpleAStar astar;
  Board board;
  ArrayList<ArrayList<Integer>> routes = new ArrayList<ArrayList<Integer>>();
  int sight;
  
  RouteList(int s, SimpleAStar a, Board board) {
    sight = s;
    astar = a;
    this.board = board;
  }
  
  ArrayList<Integer> findRoute(int a, int b) {
    ArrayList<Integer> path = new ArrayList<Integer>();
    int aPos = -1, bPos = -1;
    ArrayList<Integer> aSights = board.visibleOpenNeighbors(a, sight);
    ArrayList<Integer> bSights = board.visibleOpenNeighbors(b, sight);
    aSights.add(0, a);
    bSights.add(0, b);
    
    for(ArrayList<Integer> possible : routes) {  //Check each stored route
      for(Integer aTest : aSights) {
        if(possible.contains(aTest)) {
          aPos = possible.indexOf(aTest);
          break;
        }
      }
      for(Integer bTest : bSights) {
        if(possible.contains(bTest)) {
          bPos = possible.indexOf(bTest);
          break;
        }
      }
      
      if(aPos!= -1 && bPos != -1) {
        ArrayList<Integer> bridgeA = new ArrayList<Integer>();
        ArrayList<Integer> bridgeB = new ArrayList<Integer>();
        if(possible.get(aPos) != a) {
          bridgeA = astar.calc(board.grab(a), board.grab(possible.get(aPos)));
          bridgeA.remove(bridgeA.size()-1);
        }
        if(possible.get(bPos) != b) {
          bridgeB = astar.calc(board.grab(b), board.grab(possible.get(bPos)));
          bridgeB.remove(bridgeB.size()-1);
        }
        
        //Make route, then append bridges
        
        if(aPos == 0 && bridgeA.size() > 0) {
          possible.addAll(0, bridgeA);
        } else if(aPos == possible.size()-1 && bridgeA.size() > 0) {
          possible.addAll(reverse(bridgeA));
        }
        if(bPos == 0 && bridgeB.size() > 0) {
          possible.addAll(0, bridgeB);
        } else if(bPos == possible.size()-1 && bridgeB.size() > 0) {
          possible.addAll(reverse(bridgeB));
        }
        
      }
      else {
        aPos = -1;
        bPos = -1;
      }
    }
  }
  
  ArrayList<Integer> reverse(ArrayList<Integer> list) {
    ArrayList<Integer> rev = new ArrayList<Integer>();
    for(Integer i : list) rev.add(0, i);
    return list;
  }
}