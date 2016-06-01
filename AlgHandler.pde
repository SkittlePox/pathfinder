class AlgHandler {
  ArrayList<Alg> algs;
  Alg main;
  
  AlgHandler() {
    algs = new ArrayList<Alg>();
  }
  
  void go() {
    if(main!= null) main.go();
  }
}