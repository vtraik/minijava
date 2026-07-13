package vtable;

import java.util.*;
import symboltable.*;

public class VTable {
  private Map<String, List<Info>> classMethods = new LinkedHashMap<>();

  public List<Info> getMethods(String className) {
    return classMethods.containsKey(className) ? classMethods.get(className) : null;
  }

  public int getNumMeths(String className) throws Exception {
    return classMethods.get(className).size();
  }

  public void addClass(String className) throws Exception {
    if (classMethods.containsKey(className)) throw new Exception("Duplicate class in vtable\n");
    classMethods.put(className, new ArrayList<Info>());
  }

  public void addMethod(String className, MethodInfo methI, String defClass) throws Exception {
    if (!classMethods.containsKey(className))
      throw new Exception(String.format("Class %s not found in vtable\n", className));

    List<Info> meths = classMethods.get(className);
    Info entry = new Info(defClass, methI);

    if (meths.contains(entry)) meths.set(meths.indexOf(entry), entry);
    else meths.add(entry);
  }
}
