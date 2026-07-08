import java.util.*;
import syntaxtree.*;
import visitor.GJDepthFirst;
import symboltable.*;

class DeclVisitor extends GJDepthFirst<String, String>{
    private SymbolTable symbt;
    private Set<String> undefinedTypes = new HashSet<String>();

    public DeclVisitor(SymbolTable s){
        symbt = s;
    }

    private void updateUndefTypes(String type){
        if(type.equals("int") || type.equals("boolean") ||
           type.equals("int[]")){
            return;
        }
        if(symbt.getClass(type) == null){
            undefinedTypes.add(type);
        }
    }

    /*
       Either {
       1.  Scope: class|method.
           method != null : method scope.
           method == null : class scope.

       2.  type|id
   */
    private String getFirstEl(String scope){
        int indx = scope.indexOf('|');
        return scope.substring(0, indx);
    }

    private String getSecEl(String scope){
        int indx = scope.indexOf('|');
        return scope.substring(indx + 1);
    }

    private boolean subtype(String type1, String type2) throws Exception {
        if(type2.equals("int"))
            return type1.equals("int");
        if(type2.equals("boolean"))
            return type1.equals("boolean");
        if(type2.equals("int[]"))
            return type1.equals("int[]");

        if(type1.equals(type2))
            return true;

        return subtyperec(type1, type2);
    }

    private boolean subtyperec(String type1, String type2) {
        if(type1.equals(type2))
            return true;

        ClassInfo superClass = symbt.getClass(type2).getSuper();
        if(superClass == null)
            return false;
        else
            return subtyperec(type1, superClass.getName());
    }

    private boolean checkTypes(List<Symbol> l1, List<Symbol> l2) throws Exception {
        for(int i = 0; i < l1.size(); ++i){
            String t1 = l1.get(i).getType();
            String t2 = l2.get(i).getType();
            if(!(subtype(t1, t2) || subtype(t2, t1)))
                return true; // valid overload
        }
        return false;
    }

    private void checkOverloading(List<MethodInfo> methods, String className) throws Exception {
        // for all pairs with id := name
        for(int i = 0; i < methods.size(); ++i){
            for(int j = i+1; j < methods.size(); ++j){
                MethodInfo m1 = methods.get(i);
                MethodInfo m2 = methods.get(j);
                int diff = m1.getNumParams() - m2.getNumParams();
                if(diff != 0 || m1.getNumParams() == 0 || m2.getNumParams() == 0) continue;

                if(!checkTypes(m1.getParams(), m2.getParams()))
                    throw new Exception(String.format("Invalid overload -> %s.%s",
                                                      className, m1.getRetId().getName()));
            }
        }
    }

    private void checkOverloadingSuperClass(List<MethodInfo> meth, String className, String methName) throws Exception {
        ClassInfo superClass;
        String currSuperName = className;
        while((superClass = symbt.getSuper(currSuperName)) != null){
            currSuperName = superClass.getName();

            List<MethodInfo> m1 = meth;
            List<MethodInfo> m2 = superClass.getMethod(methName);

            for(int i = 0; i < m1.size(); ++i){
                if(m1.get(i).getOverridden()) continue; // dont check overridden methods

                // check overload
                if(m2 == null) continue;

                for(int j = 0; j < m2.size(); ++j){
                    int diff = m1.get(i).getNumParams() - m2.get(j).getNumParams();
                    if(diff != 0 || m1.get(i).getNumParams() == 0 || m2.get(j).getNumParams() == 0) continue;
                    if(!checkTypes(m1.get(i).getParams(), m2.get(j).getParams()))
                        throw new Exception(String.format("Invalid overload between %s.%s and %s.%s",
                                                        className, m1.get(i).getMangName(),
                                                        currSuperName, m2.get(j).getMangName()));
                }
            }
        }
    }

    private void checkOverloadingViolations() throws Exception {
        // traverse symbol table and check overloading errors
        Map<String, ClassInfo> classes = symbt.getClasses();
        for(Map.Entry<String, ClassInfo> cl : classes.entrySet()){
            Map<String, List<MethodInfo>> methods = cl.getValue().getMethods();
            for(Map.Entry<String, List<MethodInfo>> meth : methods.entrySet()){
                List<MethodInfo> sameClass = meth.getValue(); // same class methods with id := name
                // same class overloading
                checkOverloading(sameClass, cl.getKey());

                // super class overloading/overriding
                checkOverloadingSuperClass(sameClass, cl.getKey(), meth.getKey());
            }
        }

    }



    // f0 -> MainClass()
    // f1 -> ( TypeDeclaration() )*
    // f2 -> <EOF>
    @Override
    public String visit(Goal n, String argu) throws Exception {
        n.f0.accept(this, argu);
        n.f1.accept(this, argu);

        if(!undefinedTypes.isEmpty())
            throw new Exception(String.format("Class %s isn't defined", undefinedTypes.iterator().next()));

        checkOverloadingViolations();
        n.f2.accept(this, argu);
        return null;
    }


     // f0 -> "class"
     // f1 -> Identifier()
     // f2 -> "{"
     // f3 -> "public"
     // f4 -> "static"
     // f5 -> "void"
     // f6 -> "main"
     // f7 -> "("
     // f8 -> "String"
     // f9 -> "["
     // f10 -> "]"
     // f11 -> Identifier()
     // f12 -> ")"
     // f13 -> "{"
     // f14 -> ( VarDeclaration() )*
     // f15 -> ( Statement() )*
     // f16 -> "}"
     // f17 -> "}"
    @Override
    public String visit(MainClass n, String argu) throws Exception {
        String className = n.f1.accept(this, null);
        String param = n.f11.accept(this, null);

        ClassInfo mainClass = new ClassInfo(null, className, 0, 0);
        Symbol retId = new Symbol("main", "void");
        MethodInfo mainMeth = new MethodInfo(retId, "main_String[]", true); // dont count offset for main
        mainMeth.addParam(new Symbol(param, "String[]"));
        mainClass.addMethod(mainMeth);

        symbt.addClass(mainClass);

        String scope = String.format("%s|main_String[]", className);
        n.f14.accept(this, scope);

        return null;
    }


     // f0 -> "class"
     // f1 -> Identifier()
     // f2 -> "{"
     // f3 -> ( VarDeclaration() )*
     // f4 -> ( MethodDeclaration() )*
     // f5 -> "}"
    @Override
    public String visit(ClassDeclaration n, String argu) throws Exception {
        String className = n.f1.accept(this, null);

        undefinedTypes.remove(className); // remove the undefined type that is now being defined (if of course it is)
        symbt.addClass(new ClassInfo(null, className, 0, 0));

        String scope = String.format("%s|null", className);
        n.f3.accept(this, scope);
        n.f4.accept(this, scope);

        return null;
    }


     // f0 -> "class"
     // f1 -> Identifier()
     // f2 -> "extends"
     // f3 -> Identifier()
     // f4 -> "{"
     // f5 -> ( VarDeclaration() )*
     // f6 -> ( MethodDeclaration() )*
     // f7 -> "}"
    @Override
    public String visit(ClassExtendsDeclaration n, String argu) throws Exception {
        String className = n.f1.accept(this, null);
        String superClassName = n.f3.accept(this, null);
        ClassInfo superClass = symbt.getClass(superClassName); // either: superclass | null

        if(superClass == null)
            throw new Exception(String.format("Class %s not defined", superClassName));

        int currFieldOffs = superClass.getFieldOffset();
        int currMethOffs = superClass.getMethOffset();

        undefinedTypes.remove(className);
        symbt.addClass(new ClassInfo(superClass, className, currFieldOffs, currMethOffs));

        String scope = String.format("%s|null", className);
        n.f5.accept(this, scope);
        n.f6.accept(this, scope);

        return null;
    }

    // f0 -> Type()
    // f1 -> Identifier()
    // f2 -> ";"
   @Override
   public String visit(VarDeclaration n, String argu) throws Exception {
        String className = getFirstEl(argu);
        String methName = getSecEl(argu); // mangled name

        String type = n.f0.accept(this, argu);
        String var = n.f1.accept(this, argu);
        Symbol newVar = new Symbol(var, type);

        updateUndefTypes(type);
        if(methName.equals("null")){ // class scope => field
            symbt.getClass(className).addField(newVar);
        }else{                  // method scope => local var
            symbt.getClass(className).getMethodMang(methName).addLocalVar(newVar);
        }

        return null;
    }

     // f0 -> "public"
     // f1 -> Type()
     // f2 -> Identifier()
     // f3 -> "("
     // f4 -> ( FormalParameterList() )?
     // f5 -> ")"
     // f6 -> "{"
     // f7 -> ( VarDeclaration() )*
     // f8 -> ( Statement() )*
     // f9 -> "return"
     // f10 -> Expression()
     // f11 -> ";"
     // f12 -> "}"
    @Override
    public String visit(MethodDeclaration n, String argu) throws Exception {
        // type1|id1,type2|id2,...
        String[] args = n.f4.present() ? n.f4.accept(this, null).split(",") : new String[0];

        String type = n.f1.accept(this, null);
        String methName = n.f2.accept(this, null);
        String mangName = new String(methName);
        MethodInfo methI = new MethodInfo(new Symbol(methName, type));

        String className = getFirstEl(argu);

        // check if return type undefined
        updateUndefTypes(type);

        for(int i = 0; i < args.length; ++i){
            String ptype = getFirstEl(args[i]);
            String name = getSecEl(args[i]);
            mangName += "_" + ptype;
            updateUndefTypes(ptype);
            methI.addParam(new Symbol(name, ptype));
        }
        methI.setMangName(mangName);


        ClassInfo superClass;
        String currSuperName = className;
        boolean isOverridden = false;
        while((superClass = symbt.getSuper(currSuperName)) != null){
            currSuperName = superClass.getName();
            // check override
            // if a method with the same param types exists in super class it will be exactly 1 instance
            // (intra class instances are denied earlier)
            // so if it exists its either a valid override or a type error
            String superMethRetType = superClass.getMethodRetType(methI.getMangName());
            String methRetType = methI.getRetId().getType();
            // class: int_foo_int_boolean, super: boolean_foo_int_boolean
            if(superMethRetType != null && !methRetType.equals(superMethRetType)){
                    throw new Exception(String.format("Override return types don't match -> class %s (%s-%s)",
                                                    className, methRetType, superMethRetType));
            }else if(superMethRetType != null){
                isOverridden = true;
                break;
            }
        }

        methI.setOverridden(isOverridden);
        symbt.getClass(className).addMethod(methI);
        symbt.addNumMeth(methI); // keep the visited order of methods (needed in ref pass)

        String scope = String.format("%s|%s", className, mangName);
        n.f7.accept(this, scope);
        return null;
    }

     // f0 -> FormalParameter()
     // f1 -> FormalParameterTail()
    @Override
    public String visit(FormalParameterList n, String argu) throws Exception {
        String ret = n.f0.accept(this, null); // type|id

        if (n.f1 != null) {
            ret += n.f1.accept(this, null);
        }

        return ret;
    }

     // f0 -> FormalParameter()
     // f1 -> FormalParameterTail()
    @Override
    public String visit(FormalParameterTerm n, String argu) throws Exception {
        return n.f1.accept(this, null);
    }

     // f0 -> ","
     // f1 -> FormalParameter()
    @Override
    public String visit(FormalParameterTail n, String argu) throws Exception {
        String ret = "";
        for ( Node node: n.f0.nodes) {
            ret += "," + node.accept(this, null);
        }

        return ret;
    }

     // f0 -> Type()
     // f1 -> Identifier()
    @Override
    public String visit(FormalParameter n, String argu) throws Exception {
        String type = n.f0.accept(this, null);
        String name = n.f1.accept(this, null);
        return type + "|" + name;
    }

    @Override
    public String visit(ArrayType n, String argu) {
        return "int[]";
    }

    @Override
    public String visit(BooleanType n, String argu) {
        return "boolean";
    }

    @Override
    public String visit(IntegerType n, String argu) {
        return "int";
    }

    @Override
    public String visit(Identifier n, String argu) {
        return n.f0.toString();
    }
}
