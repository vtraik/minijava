class ClassInfo {
    private ClassInfo superClass;
    private String name;
    Map<String, MethodInfo> methods = new HashMap<String, MethodInfo>();
    Map<String, Symbol> fields = new HashMap<String, Symbol>();

    ClassInfo(ClassInfo baseClass, String name){
        superClass = baseClass;
        this.name = name;
    }

    public ClassInfo getSuper(){
        return superClass;
    }

    public String getName(){
        return name;
    }

    public Map<String, MethodInfo> getMethods(){
        return methods;
    }

    public Map<String, Symbol> getFields(){
        return fields;
    }

    public void addMethod(MethodInfo method){ // overloading ?
        String methName = method.getName();
        methods.put(methName, method);
    }

    public void addField(Symbol field) throws Exception {
        String fieldName = field.getName();
        if(fields.containsKey(fieldName))
            throw new Exception(String.format("Symbol %s is already defined in this scope", fieldName));

        fields.put(fieldName, field);
    }
}
