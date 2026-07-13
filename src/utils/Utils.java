package utils;

import java.util.*;
import symboltable.*;

public class Utils {
  public static String getFirstEl(String scope) {
    int indx = scope.indexOf('|');
    return scope.substring(0, indx);
  }

  public static String getSecEl(String scope) {
    int indx = scope.indexOf('|');
    return scope.substring(indx + 1);
  }

  public static boolean subtype(SymbolTable symbt, String type1, String type2) throws Exception {
    if (type2.equals("int")) return type1.equals("int");
    if (type2.equals("boolean")) return type1.equals("boolean");
    if (type2.equals("int[]")) return type1.equals("int[]");

    if (type1.equals(type2)) return true;

    return subtyperec(symbt, type1, type2);
  }

  public static boolean subtyperec(SymbolTable symbt, String type1, String type2) {
    if (type1.equals(type2) && type1 != null) return true;

    ClassInfo classI = symbt.getClass(type1);
    if (classI == null) // type1 == prim type && type2 not
    return false;

    ClassInfo superClass = classI.getSuper();
    if (superClass == null) return false;
    else return subtyperec(symbt, superClass.getName(), type2);
  }

  public static MethodInfo getClassCompMethod(
      SymbolTable symbt, List<MethodInfo> classMeths, String[] args) throws Exception {
    int argMatched = -1;
    for (int i = 0; i < classMeths.size(); ++i) {
      MethodInfo meth = classMeths.get(i);
      int numParams = meth.getNumParams();
      List<Symbol> params = meth.getParams();

      if (args.length != numParams) continue;
      argMatched = 0;
      for (int j = 0; j < numParams; ++j) {
        String methType = params.get(j).getType();
        if (!subtype(symbt, args[j], methType)) break;
        ++argMatched;
      }

      if (argMatched == numParams) {
        return meth; // found a compatible method
      }
    }
    return null;
  }
}
