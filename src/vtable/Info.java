package vtable;

import symboltable.*;

public class Info {
  private String defClass;
  private MethodInfo methodInfo;

  public Info(String defClass, MethodInfo methodInfo) {
    this.defClass = defClass;
    this.methodInfo = methodInfo;
  }

  public String getDefClass() {
    return defClass;
  }

  public MethodInfo getMethod() {
    return methodInfo;
  }

  @Override
  public boolean equals(Object obj) {
    if (this == obj) return true;

    if (obj == null) return false;

    if (getClass() != obj.getClass()) return false;

    return methodInfo.equals(((Info) obj).methodInfo);
  }

  @Override
  public int hashCode() {
    return methodInfo.hashCode();
  }
}
