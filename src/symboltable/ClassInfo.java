package symboltable;
import java.util.*;

public class ClassInfo {
    private ClassInfo superClass;
    private String name;
    private int currFieldOffs;
    private int currMethOffs;
    // foo_int_boolean, retType
    Map<String, MethodInfo> methodsSignatures = new LinkedHashMap<String, MethodInfo>();
    // foo, MethodInfo
    Map<String, List<MethodInfo>> methods = new LinkedHashMap<>();
    Map<String, Symbol> fields = new LinkedHashMap<String, Symbol>();

    public ClassInfo(ClassInfo baseClass, String name, int currFieldOffs, int currMethOffs){
        superClass = baseClass;
        this.name = name;
        this.currFieldOffs = currFieldOffs;
        this.currMethOffs = currMethOffs;
    }

    public ClassInfo getSuper(){
        return superClass;
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

    public MethodInfo getMethodMang(String mangName){
        return methodsSignatures.containsKey(mangName) ? methodsSignatures.get(mangName) : null;
    }

    public String getMethodRetType(String mangName){
        return methodsSignatures.containsKey(mangName) ?
               methodsSignatures.get(mangName).getRetId().getType() : null;
    }

    public Map<String, List<MethodInfo>> getMethods(){
        return methods;
    }

    public Symbol getField(String name){
        return fields.containsKey(name) ? fields.get(name) : null;
    }

    public Map<String, Symbol> getFields(){
        return fields;
    }

    public void addMethod(MethodInfo method) throws Exception {
        String methName = method.getRetId().getName();
        if(methodsSignatures.containsKey(method.getMangName()))
            throw new Exception(String.format("Method %s is already defined in this scope -> class %s", methName, name));

        boolean isOverridden = method.getOverridden();
        if(!isOverridden){
            method.setOffset(currMethOffs);
            currMethOffs += 8;
        }

        methodsSignatures.put(method.getMangName(), method);
        methods.computeIfAbsent(methName, k -> new ArrayList<MethodInfo>()).add(method);
    }


    public void addField(Symbol field) throws Exception {
        String fieldName = field.getName();
        if(fields.containsKey(fieldName))
            throw new Exception(String.format("Symbol %s is already defined in this scope -> class %s", fieldName, name));

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

    public void printOffsets(int choice){
        if(methods.containsKey("main")) return;

        switch(choice){
            case 0:
                System.out.println("-----------Class " + name + "-----------");
                System.out.println("--Variables---");
                for(Map.Entry<String, Symbol> field : fields.entrySet()){
                    System.out.println(name + "." + field.getKey() + " : " + field.getValue().getOffset());
                }
                System.out.println("---Methods---");
                for(Map.Entry<String, MethodInfo> meth : methodsSignatures.entrySet()){
                    int offs = meth.getValue().getOffset();
                    if(offs != -1)
                        System.out.println(name + "." + meth.getValue().getRetId().getName() + " : " + offs);
                }
                System.out.println();
                break;
            case 1:
                for(Map.Entry<String, Symbol> field : fields.entrySet()){
                    System.out.println(name + "." + field.getKey() + " : " + field.getValue().getOffset());
                }
                for(Map.Entry<String, MethodInfo> meth : methodsSignatures.entrySet()){
                    int offs = meth.getValue().getOffset();
                    if(offs != -1)
                        System.out.println(name + "." + meth.getKey() + " : " + offs);
                }
        }
    }
}
