class A {
  public static void main(String[] args) {
    B b;
    int i;

    b = new B();
    i = b.init();
    System.out.println(b.foo(20));
  }
}

class B {
  int[] a;

  public int init() {
    int i;
    a = new int[10];

    i = 0;
    while (i < 10) {
      a[i] = 1;
      i = i + 1;
    }
    return 1;
  }

  public int foo(int i) {
    return a[i];
  }
}
