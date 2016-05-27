class AlgHandler {
  ArrayList<Alg> algs;
  
  AlgHandler() {
    algs = new ArrayList<Alg>();
  }
  
  void go() {
    for(Alg a : algs) {
      a.go();
    }
  }
}