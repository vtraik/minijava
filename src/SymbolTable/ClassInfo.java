class ClassInfo {
    private ClassInfo superClass;
    private String name;
    private int currFieldOffs;
    private int currMethOffs;
    // foo_int_boolean, retType
    Map<String, String> methodsSignatures = new LinkedHashMap<String, String>();
    // foo, MethodInfo
    Map<String, List<MethodInfo>> methods = new LinkedHashMap<String, ArrayList<MethodInfo>>();
    Map<String, Symbol> fields = new LinkedHashMap<String, Symbol>();

    ClassInfo(ClassInfo baseClass, String name, int currFieldOffs){
        superClass = baseClass;
        this.name = name;
        this.currFieldOffs = currFieldOffs;
    }

    public ClassInfo getSuper(){
        return superClass;
    }

    public ClassInfo getSuperName(){
        return superClass.getName();
    }

    public String getName(){
        return name;
    }

    public int getFieldOffset(){
        return currFieldOffs;
    }

    public int getMethOffset(){
        return currMethOffs;
    }

    public List<MethodInfo> getMethod(String name){
        return methods.containsKey(name) ? methods.get(name) : null;
    }

    public String getMethodRetType(String name){
        return methodsSignatures.containsKey(name) ? methodsSignatures.get(name) : null;
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

    public void addMethod(MethodInfo method) throws Exception {
        String methName = method.getName();
        if(methodsSignatures.containsKey(method.getMangName()))
            throw new Exception(String.format("Method %s is already defined in this scope", methName));
        methodsSignatures.put(method.getMangName(), method.getRetId().getType());
        methods.computeIfAbsent(methName, k -> new ArrayList<MethodInfo>()).add(method);
    }


    public void addField(Symbol field) throws Exception {
        String fieldName = field.getName();
        if(fields.containsKey(fieldName))
            throw new Exception(String.format("Symbol %s is already defined in this scope", fieldName));

        field.setOffset(currFieldOffs);
        fields.put(fieldName, field);

        String type = field.getType();
        if(type.equals("int"))
            currFieldOffs += 4;
        else if(type.equals("boolean"))
            currFieldOffs += 1;
        else
            currFieldOffs += 8;
    }

    public void printOffsets(){
        if(name.equals("main")) return;

        for(Map.entry<String, Symbol> field : fields){
            System.out.println(name + "." + field.getKey() + " : " + field.getOffset());
        }
        for(Map.entry<String, MethInfo> meth : methods){
            System.out.println(name + "." + meth.getKey() + " : " + meth.getOffset());
        }
    }
}
