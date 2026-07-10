package vtable;

import java.util.*;
import symboltable.*;

public class VTable {
    private Map<String, List<Info>> classMethods = new LinkedHashMap<>();

    public List<Info> getMethods(String className) {
        return class_methods.containsKey(className) ? class_methods.get(className) : null;
    }

    public int getNumMeths(String className) throws Exception {
        return class_methods.get(className).getValue().size();
    }

    public void addClass(String className) throws Exception {
        if (class_methods.containsKey(className))
            throw new Exception("Duplicate class in vtable\n");
        class_methods.put(className, new ArrayList<>());
    }

    public void addMethod(String className, MethodInfo methI, String defClass) throws Exception {
        if (!class_methods.containsKey(className))
            throw new Exception(String.format("Class %s not found in vtable\n"), className);

        List<Info> methods = classMethods.get(className);
        Info entry = new Info(defClass, methI);

        if (meths.contains(entry))
            methods.set(meths.indexOf(entry), entry);
        else
            meths.add(entry);
    }
}
