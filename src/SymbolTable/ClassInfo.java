class ClassInfo {
    private ClassInfo superClass;
    private String name;
    Map<String, MethodInfo> methods = new LinkedHashMap<String, MethodInfo>();
    Map<String, Symbol> fields = new LinkedHashMap<String, Symbol>();

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


    public MethodInfo getMethod(String name){
        return methods.containsKey(name) ? methods.get(name) : null;
    }

    public Map<String, MethodInfo> getMethods(){
        return methods;
    }

    public Symbol getField(String name){
        return fields.containsKey(name) ? fields.get(name) : null;
    }

    public Map<String, Symbol> getFields(){
        return fields;
    }

    public void addMethod(MethodInfo method){
        String methName = method.getName();
        if(methods.containsKey(methName))
            throw new Exception(String.format("Method %s is already defined in this scope", methName));

        methods.put(methName, method);
    }

    public void addField(Symbol field) throws Exception {
        String fieldName = field.getName();
        if(fields.containsKey(fieldName))
            throw new Exception(String.format("Symbol %s is already defined in this scope", fieldName));

        fields.put(fieldName, field);
    }
}
