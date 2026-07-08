package vtable;

import java.util.*;
import symboltable.*;

public class VTable {
    private Map<String, Map.Entry<String, List<MethodInfo>>> class_methods = new LinkedHashMap<>();

    public Map.Entry<String, List<MethodInfo>> getMethods(String className) {
        return class_methods.containsKey(className) ? class_methods.get(className) : null;
    }

    public int getNumMeths(String className) throws Exception {
        return class_methods.get(className).getValue().size();
    }

    public void addClass(String className, String superClass) throws Exception {
        if (class_methods.containsKey(className))
            throw new Exception("Duplicate class in vtable\n");
        class_methods.put(className, new AbstractMap.SimpleEntry<>(
            superClass,
            List<MethodInfo>()
        ));
    }

    public void addMethod(String className, MethodInfo methI) throws Exception {
        if (!class_methods.containsKey(className))
            throw new Exception(String.format("Class %s not found in vtable\n"), className);
        List<MethodInfo> meths = class_methods.get(className).getValue();

        if (meths.contains(methI))
            methods.set(meths.indexOf(methI), methI);
        else
            meths.add(methI);
    }
}
