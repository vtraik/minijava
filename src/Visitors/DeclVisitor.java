import syntaxtree.*;
import visitor.*;

// TO-DO: OVerloading prob in methods in a class.
class DeclVisitor extends GJDepthFirst<String, String>{
    private SymbolTable symbt;

    DeclVisitor(SymbolTable s){
        symbt = s;
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
        return scope.substring(indx);
    }

    private boolean subtype(String type1, String type2){
        if(type2.equals("null")) return false;
        if(type1.equals("int")){
            if(type2.equals("int")) return true;
            else return false;
        }
        if(type1.equals("boolean")){
            if(type2.equals("boolean")) return true;
            else return false;
        }
        if(type1.equals("int[]")){
            if(type2.equals("int[]")) return true;
            else return false;
        }
        if(type1.equals(type2)) return true;
        String superType = symbt.getClass(type1).getSuperName();
        subtype(type1, superType);
    }

    private void checkOverride(MethodInfo methI, List<MethodInfo> methSuper) throws Exception {
        List<Symbol> clParams = methi.getParams();
        List<Symbol> superParams = methSuper.getParams();

        if(clParams.size() != superParams.size()) return 0; // diff methods

        for(int i = 0; i < clParams.size(); ++i){
            if(!clParams.get(i).getType().equals(superParams.get(i).getType()))
                return 0; // diff params
        }

        if(!methI.getRetId().getType().equals(methSuper.getRetId().getType()))
            return 1; // throw exception: same param types, diff ret type

        return 2; // stop loop: found overriden method
    }

    private boolean checkTypes(List<Symbol> l1, List<Symbol> l2){
        for(int i = 0; i < l1.size(); ++i){
            String t1 = l1.get(i).getType();
            String t1 = l2.get(i).getType();
            if(!(subtype(t1, t2) || subtype(t2, t1)))
                return true; // valid overload
        }
        return false;
    }

    private void checkOverloading(List<MethodInfo> methods) throws Exception {
        // for all pairs with id := name
        for(int i = 0; i < methods.size(); ++i){
            for(int j = i+1; j < methods.size(); ++j){
                MethodInfo m1 = methods.get(i);
                MethodInfo m2 = methods.get(j);
                if(m1.getNumParams() != m2.getNumParams) continue;

                if(!checkTypes(m1.getParams(), m2.getParams()))
                    throw new Exception(String.format("Invalid overload between %s and %s", m1.getName(), m2.getName()));
            }
        }
    }

    private void checkViolationsSuperClass(List<MethodInfo> meth, String className){
        ClassInfo superClass;
        String currSuperName = className;
        while((superClass = symbt.getSuper(currSuperName)) != null){
            currSuperName = supperClass.getName();
            for(int i = 0; i < meth.size(); ++i){
                // check override
                // if a method with the same param types exists in super class it will be exactly 1 instance
                // (intra class instances are denied earlier)
                // so if it exists its either a valid override or a type error
                String superMethRetType = superClass.getMethodRetType(meth.get(i).getMangName());
                String methRetType = meth.getRetId().getType();
                // class: int_foo_int_boolean, super: boolean_foo_int_boolean
                if(methRetType != null && !methRetType.equals(superMethRetType)){
                        throw new Exception(String.format("Override return types don't match in class %s: (%s-%s)",
                                                        className, type, retType));
                }else if(methRetType != null){ // overriden method, skip overload check for this method.
                    continue;
                }

                // check overload
                List<MethodInfo> m1 = meth;
                List<MethodInfo> m2 = superClass.getMethod();
                for(int j = 0; j < m2.size(); ++j){
                    if(m1.get(i).getNumParams() != m2.get(j).getNumParams()) continue;
                    if(!checkTypes(m1.get(i).getParams(), m2.get(j).getParams()))
                        throw new Exception(String.format("Invalid overload between %s and %s",
                                                        m1.get(i).getName(), m2.get(j).getName()));
                }
            }
        }
    }

    private void checkMethodViolations(){
        // traverse symbol table:
        // - check override errors (intra class, iner class covered by addMethod)
        // - check overloading errors
        // - calc method offsets

        Map<String, ClassInfo> classes = symbt.getClasses();
        for(Map.entry<String, ClassInfo> cl : classes){
            Map<String, List<MethodInfo>> methods = cl.getMethods();
            for(Map.entry<String, List<MethodInfo>> meth : methods){
                List<MethodInfo> sameClass = meth.getValue(); // same class methods with id := name
                // same class overloading
                checkOverloading(sameClass);

                // super class overloading/overriding
                checkViolationsSuperClass(meth, cl.getKey());
            }
        }

    }

    /**
     * f0 -> "class"
     * f1 -> Identifier()
     * f2 -> "{"
     * f3 -> "public"
     * f4 -> "static"
     * f5 -> "void"
     * f6 -> "main"
     * f7 -> "("
     * f8 -> "String"
     * f9 -> "["
     * f10 -> "]"
     * f11 -> Identifier()
     * f12 -> ")"
     * f13 -> "{"
     * f14 -> ( VarDeclaration() )*
     * f15 -> ( Statement() )*
     * f16 -> "}"
     * f17 -> "}"
     */
    @Override
    public String visit(MainClass n, String argu) throws Exception {
        String className = n.f1.accept(this, null);
        String param = n.f11.accept(this, null);

        ClassInfo mainClass = new ClassInfo(null, className, 0);
        Symbol retId = new Symbol("main", "void");
        MethodInfo mainMeth = new MethodInfo(retId);
        Symbol paramType = new Symbol(param, "String[]");
        mainMeth.addParam(paramType);
        mainClass.addMethod(mainMeth);

        symbt.addClass(mainClass);

        String scope = String.format("%s|main", className);
        n.f14.accept(this, scope);
        checkMethodViolations();
        return null;
    }

    /**
     * f0 -> "class"
     * f1 -> Identifier()
     * f2 -> "{"
     * f3 -> ( VarDeclaration() )*
     * f4 -> ( MethodDeclaration() )*
     * f5 -> "}"
     */
    @Override
    public String visit(ClassDeclaration n, String argu) throws Exception {
        String className = n.f1.accept(this, null);

        ClassInfo classI = new ClassInfo(null, className, 0);

        symbt.addClass(classI);

        String scope = String.format("%s|null", className);
        n.f3.accept(this, scope);
        n.f4.accept(this, scope);

        return null;
    }

    /**
     * f0 -> "class"
     * f1 -> Identifier()
     * f2 -> "extends"
     * f3 -> Identifier()
     * f4 -> "{"
     * f5 -> ( VarDeclaration() )*
     * f6 -> ( MethodDeclaration() )*
     * f7 -> "}"
     */
    @Override
    public String visit(ClassExtendsDeclaration n, String argu) throws Exception {
        String className = n.f1.accept(this, null);
        String superClassName = n.f3.accept(this, null);
        int currFieldOffs = symbt.getSuperFieldOffs(className);
        ClassInfo classI = new ClassInfo(superClassName, className, currFieldOffs);

        symbt.addClass(classI);

        String scope = String.format("%s|null", className);
        n.f5.accept(this, scope);
        n.f6.accept(this, scope);

        return null;
    }

    /**
    * f0 -> Type()
    * f1 -> Identifier()
    * f2 -> ";"
    */
   @Override
   public String visit(VarDeclaration n, String argu) throws Exception {
        String className = getFirstEl(argu);
        String methName = getSecEl(argu);

        String type = n.f0.accept(this, argu);
        String var = n.f1.accept(this, argu);
        Symbol newVar = new Symbol(var, type);

        if(methName.equals("null")){ // class scope => field
            symbt.getClass(className).addField(newVar);
        }else{                  // method scope => local var
            symbt.getClass(className).getMethod(methName).addLocalVar(newVar);
        }

        return null;
    }

    /**
     * f0 -> "public"
     * f1 -> Type()
     * f2 -> Identifier()
     * f3 -> "("
     * f4 -> ( FormalParameterList() )?
     * f5 -> ")"
     * f6 -> "{"
     * f7 -> ( VarDeclaration() )*
     * f8 -> ( Statement() )*
     * f9 -> "return"
     * f10 -> Expression()
     * f11 -> ";"
     * f12 -> "}"
     */
    @Override
    public String visit(MethodDeclaration n, String argu) throws Exception {
        // type1|id1,type2|id2,...
        String argumentList = n.f4.present() ? n.f4.accept(this, null) : "";

        String type = n.f1.accept(this, null);
        String methName = n.f2.accept(this, null);
        String mangName = new String(methName);

        String className = getFirstEl(argu);


        String[] args = argumentList.split(",");
        for(int i = 0; i < args.length; ++i){
            String ptype = getFirstEl(args[i]);
            String name = getSecEl(args[i]);
            mangName += "_" + ptype;
            Symbol param = new Symbol(name, ptype);
            methI.addParam(param);
        }

        Symbol retId = new Symbol(methName, type);
        MethInfo methI = new MethInfo(retId, mangName);
        symbt.getClass(className).addMethod(methI);

        String scope = String.format("%s|%s", className, methName);
        n.f7.accept(this, scope);
        return null;
    }

    /**
     * f0 -> FormalParameter()
     * f1 -> FormalParameterTail()
     */
    @Override
    public String visit(FormalParameterList n, String argu) throws Exception {
        String ret = n.f0.accept(this, null); // type|id

        if (n.f1 != null) {
            ret += n.f1.accept(this, null);
        }

        return ret;
    }

    /**
     * f0 -> FormalParameter()
     * f1 -> FormalParameterTail()
     */
    @Override
    public String visit(FormalParameterTerm n, String argu) throws Exception {
        return n.f1.accept(this, null);
    }

    /**
     * f0 -> ","
     * f1 -> FormalParameter()
     */
    @Override
    public String visit(FormalParameterTail n, String argu) throws Exception {
        String ret = "";
        for ( Node node: n.f0.nodes) {
            ret += "," + node.accept(this, null);
        }

        return ret;
    }

    /**
     * f0 -> Type()
     * f1 -> Identifier()
     */
    @Override
    public String visit(FormalParameter n, String argu) throws Exception{
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
