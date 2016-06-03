class Species extends Alg {
  SimpleAStar astar;
  RouteList routes;
  ArrayList<Integer> path, possibles, blazes;
  int count = 1, bIndex = 0;
  double units = 0, propConstant = .7;

  Species(Board board, int v, int s, int c) {
    this.board = board;
    vision = 1 + v;
    speed = s;
    cognition = c;
    if (v+s+c > 15) {
      vision = 5;
      speed = 5;
      cognition = 5;
    }
    astar = new SimpleAStar(board);
    path = new ArrayList<Integer>();
    possibles = new ArrayList<Integer>();
    blazes = new ArrayList<Integer>();
    routes = new RouteList(vision, astar, board);
  }

  void go() {
    if (run) {
      if (!travel) {
        //int t = millis();
        calc();
        routes.printRoutes();
        //System.out.println("Species 1 " + (millis()-t));
        travel = true;
      }
      if (path.size() > 0) {
        travel(path);
        //eunits = steps;  //Change this!!
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
    blazes.clear();
    int curnode = board.start.id;
    for (int i = 0; i < Math.pow(board.x * board.y, 3); i++) {
      possibles.addAll(board.visibleOpenNeighbors(curnode, vision));
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
        //System.out.println(newPath.size());
        path.addAll(newPath);
        curnode = nextnode;
        //blazes.add(curnode);
        //board.grab(curnode).marked = true;
        if (curnode == board.end.id) break;
      } else break;
      eunits += 15-cognition;
    }
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

      if (iterator >= 2 && board.grab(pathF.get(iterator)).xi != board.grab(pathF.get(iterator-2)).xi && board.grab(pathF.get(iterator)).yi != board.grab(pathF.get(iterator-2)).yi) {
        eunits += speed+1;
      } else {
        eunits += 15-speed;
      }

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
    boolean handled = false;
    ArrayList<Integer> path = new ArrayList<Integer>();
    int aPos = -1, bPos = -1;
    ArrayList<Integer> aSights = board.visibleOpenNeighbors(a, sight);
    ArrayList<Integer> bSights = board.visibleOpenNeighbors(b, sight);
    aSights.add(0, a);
    bSights.add(0, b);

    for (ArrayList<Integer> possible : routes) {  //Check each stored route
      for (Integer aTest : aSights) {
        if (possible.contains(aTest)) {
          aPos = possible.indexOf(aTest);
          break;
        }
      }
      for (Integer bTest : bSights) {
        if (possible.contains(bTest)) {
          bPos = possible.indexOf(bTest);
          break;
        }
      }

      if (aPos!= -1 && bPos != -1) {
        System.out.println("Contstructing Route with roots");
        ArrayList<Integer> bridgeA = new ArrayList<Integer>();
        ArrayList<Integer> bridgeB = new ArrayList<Integer>();
        if (aPos != -1 && possible.get(aPos) != a) {
          bridgeA = astar.calc(board.grab(a), board.grab(possible.get(aPos)));
        }
        if (bPos != -1 && possible.get(bPos) != b) {
          bridgeB = astar.calc(board.grab(b), board.grab(possible.get(bPos)));
        }

        //Make route, then append bridges
        if (aPos < bPos) {
          bridgeA.remove(bridgeA.size()-1);
          bridgeB.remove(0);
          path.addAll(bridgeA);
          path.addAll(new ArrayList<Integer>(possible.subList(aPos, bPos+1)));
          path.addAll(bridgeB);
        } else {
          bridgeA.remove(bridgeB.size()-1);
          bridgeB.remove(0);
          path.addAll(bridgeA);
          path.addAll(reverse(new ArrayList<Integer>(possible.subList(aPos, bPos+1))));
          path.addAll(bridgeB);
        }

        if (aPos == 0 && bridgeA.size() > 0) {
          possible.addAll(0, bridgeA);
        } else if (aPos == possible.size()-1 && bridgeA.size() > 0) {
          possible.addAll(reverse(bridgeA));
        }
        if (bPos == 0 && bridgeB.size() > 0) {
          possible.addAll(0, bridgeB);
        } else if (bPos == possible.size()-1 && bridgeB.size() > 0) {
          possible.addAll(reverse(bridgeB));
        }

        return path;
      } else {
        aPos = -1;
        bPos = -1;
      }
    }
    for (ArrayList<Integer> possible : routes) {  //Re-evaluate if either a or b lies on the ends of a route and append
      for (Integer aTest : aSights) {
        if (possible.contains(aTest)) {
          aPos = possible.indexOf(aTest);
          break;
        }
      }
      for (Integer bTest : bSights) {
        if (possible.contains(bTest)) {
          bPos = possible.indexOf(bTest);
          break;
        }
      }

      if (bPos != -1 && (aPos == 0 || aPos == possible.size()-1)) {
        ArrayList<Integer> bridgeA = astar.calc(board.grab(possible.get(aPos)), board.grab(b));
        if(bridgeA.size() != 0) bridgeA = new ArrayList<Integer>(bridgeA.subList(1, bridgeA.size()));
        if (aPos == 0) {
          possible.addAll(0, reverse(bridgeA));
        } else {
          possible.addAll(bridgeA);
        }
        handled = true;
      }
      if (bPos != -1 && (bPos == 0 || bPos == possible.size()-1)) {
        ArrayList<Integer> bridgeB = astar.calc(board.grab(possible.get(bPos)), board.grab(a));
        bridgeB = new ArrayList<Integer>(bridgeB.subList(1, bridgeB.size()));
        if (bPos == 0) {
          possible.addAll(0, reverse(bridgeB));
        } else {
          possible.addAll(bridgeB);
        }
        handled = true;
      }
    }

    if(handled) return astar.calc(board.grab(a), board.grab(b));
    
    routes.add(astar.calc(board.grab(a), board.grab(b)));
    System.out.println("Adding route " + routes.get(routes.size()-1));
    return routes.get(routes.size()-1);
  }

  double nodeDist(int a, int b) {
    for (ArrayList<Integer> p : routes) {
      if (p.contains(a) && p.contains(b)) {
        //System.out.println("Not Guessing Distance");
        return Math.abs(p.indexOf(a) - p.indexOf(b));
      }
    }
    //System.out.println("Guessing Distance");
    return board.nodeDist(a, b)*20;
  }

  ArrayList<Integer> reverse(ArrayList<Integer> list) {
    ArrayList<Integer> rev = new ArrayList<Integer>();
    for (Integer i : list) rev.add(0, i);
    return rev;
  }

  void printRoutes() {
    for (ArrayList<Integer> r : routes) {
      System.out.println(r);
    }
  }
}