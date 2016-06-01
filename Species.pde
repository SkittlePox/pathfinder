class Species extends Alg {
  SimpleAStar astar;
  RouteList routes;
  ArrayList<Integer> path, possibles;
  int vision, speed, cognition, id = -1, count = 1, mIndex = 1;
  double units = 0, propConstant = .7;

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
    routes = new RouteList(vision, astar, board);
  }

  void go() {
    if (run) {
      if (!travel) {
        //int t = millis();
        calc();
        //System.out.println("Species 1 " + (millis()-t));
        travel = true;
      }
      if (path.size() > 0) {
        travel(path);
        eunits = steps;
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
          if (board.nodeDist(pos, board.end.id)*propConstant + routes.nodeDist(curnode, pos) <
          board.nodeDist(nextnode, board.end.id)*propConstant + routes.nodeDist(curnode, nextnode)) {  //Edit this conditional - account for memory of previous routes
            nextnode = pos;
          }
        }
        ArrayList<Integer> newPath = routes.findRoute(curnode, nextnode);
        path.addAll(newPath);
        curnode = nextnode;
        if (curnode == board.end.id) break;
        //board.grab(nextnode).touch(4);
      } else break;
      //units+= 1*some constant
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
        }
        if(possible.get(bPos) != b) {
          bridgeB = astar.calc(board.grab(b), board.grab(possible.get(bPos)));
        }
        
        //Make route, then append bridges
        if(aPos < bPos) {
          bridgeA.remove(bridgeA.size()-1);
          bridgeB.remove(0);
          path.addAll(bridgeA);
          path.addAll(new ArrayList<Integer>(possible.subList(aPos, bPos+1)));
          path.addAll(bridgeB);
        }
        else {
          bridgeA.remove(bridgeB.size()-1);
          bridgeB.remove(0);
          path.addAll(bridgeA);
          path.addAll(reverse(new ArrayList<Integer>(possible.subList(aPos, bPos+1))));
          path.addAll(bridgeB);
        }
        
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
        
        return path;
      }
      else {
        aPos = -1;
        bPos = -1;
      }
    }
    
    routes.add(astar.calc(board.grab(a), board.grab(b)));
    return routes.get(routes.size()-1);
  }
  
  double nodeDist(int a, int b) {
    for(ArrayList<Integer> p : routes) {
      if(p.contains(a) && p.contains(b)) return Math.abs(p.indexOf(a) - p.indexOf(b));
    }
    return board.nodeDist(a, b)*30;
  }
  
  ArrayList<Integer> reverse(ArrayList<Integer> list) {
    ArrayList<Integer> rev = new ArrayList<Integer>();
    for(Integer i : list) rev.add(0, i);
    return rev;
  }
}