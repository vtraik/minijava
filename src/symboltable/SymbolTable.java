package symboltable;

import java.util.*;

public class SymbolTable {
  // keep the order of insertion to print offsets in order.
  Map<String, ClassInfo> classes = new LinkedHashMap<String, ClassInfo>();
  List<MethodInfo> zeroIndxMethods = new ArrayList<MethodInfo>();

  public ClassInfo getClass(String name) {
    return classes.containsKey(name) ? classes.get(name) : null;
  }

  public Map<String, ClassInfo> getClasses() {
    return classes;
  }

  public ClassInfo getSuper(String name) {
    return classes.containsKey(name) ? classes.get(name).getSuper() : null;
  }

  public MethodInfo getNumMeth(int numMeth) {
    return zeroIndxMethods.get(numMeth);
  }

  public void addClass(ClassInfo class_obj) throws Exception {
    if (classes.containsKey(class_obj.getName()))
      throw new Exception(String.format("Duplicate class %s found in file.", class_obj.getName()));

    classes.put(class_obj.getName(), class_obj);
  }

  public void addNumMeth(MethodInfo numMeth) {
    zeroIndxMethods.add(numMeth);
  }

  public void printOffsets(int choice) {
    for (Map.Entry<String, ClassInfo> ce : classes.entrySet()) ce.getValue().printOffsets(choice);
  }
}
