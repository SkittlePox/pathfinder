class AlgHandler {
  ArrayList<Alg> algs;
  Alg main;
  
  AlgHandler() {
    algs = new ArrayList<Alg>();
  }
  
  void go() {
    //for(Alg a : algs) {
    //  a.go();
    //}
    if(main!= null) main.go();
  }
}