// TO-DO: offset calc
class SymbolTable {
    // keep the order of insertion
    Map<String, ClassInfo> classes = new LinkedHashMap<String, ClassInfo>();

    public ClassInfo getClass(String name){
        return classes.containsKey(name) ? classes.get(name) : null;
    }

    public void addClass(ClassInfo class_obj) throws Exception {
        if(classes.containsKey(class_obj))
            throw new Exception(String.format("Duplicate class %s found in file.", class_obj.getName()));

        classes.put(class_obj);
    }
}
