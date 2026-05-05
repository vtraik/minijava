package symboltable;
import java.util.*;

public class SymbolTable {
    // keep the order of insertion to print offsets in order.
    Map<String, ClassInfo> classes = new LinkedHashMap<String, ClassInfo>();

    public ClassInfo getClass(String name){
        return classes.containsKey(name) ? classes.get(name) : null;
    }

    public Map<String, ClassInfo> getClasses(){
        return classes;
    }

    public ClassInfo getSuper(String name){
        return classes.containsKey(name) ? classes.get(name).getSuper() : null;
    }

    public void addClass(ClassInfo class_obj) throws Exception {
        if(classes.containsKey(class_obj))
            throw new Exception(String.format("Duplicate class %s found in file.", class_obj.getName()));

        ClassInfo superClass = class_obj.getSuper();
        if(superClass == null)
                throw new Exception(String.format("Class %s not defined", superClass));

        classes.put(class_obj.getName(), class_obj);
    }

    public int getSuperFieldOffs(String className){
        return classes.get(className).getSuper().getFieldOffset();
    }

    public int getSuperMethOffs(String className){
        return classes.get(className).getSuper().getMethOffset();
    }

    public void printOffsets(){
        for(Map.Entry<String, ClassInfo> ce : classes.entrySet())
            ce.getValue().printOffsets();
    }
}
