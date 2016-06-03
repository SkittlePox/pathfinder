class AlgHandler {
  ArrayList<Alg> algs;
  Alg main;
  int index = 0;
  
  AlgHandler(Alg a) {
    algs = new ArrayList<Alg>();
    main = a;
  }
  
  void go() {
    if(main != null) main.go();
  }
  
  Alg getID(int id) {
    for(Alg a : algs) if(a.id == id) return a;
    return null;
  }
  
  void add(Alg a) {
    if(a.id == -1) {
      a.id = index;
      index++;
    }
    algs.add(a);
  }
}