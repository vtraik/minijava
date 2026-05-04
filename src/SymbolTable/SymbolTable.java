// TO-DO: offset calc: override -> doesnt change state, overload: it does
class SymbolTable {
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

        String superClass = class_obj.getSuper();
        if(superClass != null){
            if(!classes.containsKey(superClass))
                throw new Exception(String.format("Class %s not defined", superClass));
        }

        classes.put(class_obj);
    }

    public getSuperFieldOffs(String className){
        return classes.get(className).getSuper().getFieldOffset();
    }

    public getSuperMethOffs(String className){
        return classes.get(className).getSuper().getMethOffset();
    }

    public void printOffsets(){
        for(Map.entry<String, ClassInfo> ce : classes)
            ce.getValue().printOffsets();
    }
}
