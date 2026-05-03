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

        ClassInfo mainClass = new ClassInfo(null, className);
        Symbol retId = new Symbol("main", "void");
        MethodInfo mainMeth = new MethodInfo(retId);
        Symbol paramType = new Symbol(param, "String[]");
        mainMeth.addParam(paramType);
        mainClass.addMethod(mainMeth);

        symbt.addClass(mainClass);

        String scope = String.format("%s|main", className);
        n.f14.accept(this, scope);

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

        ClassInfo classI = new ClassInfo(null, className);

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
        ClassInfo classI = new ClassInfo(superClassName, className);

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
        Symbol retId = new Symbol(methName, type);
        MethInfo methI = new MethInfo(retId);

        String className = getFirstEl(argu);


        String[] args = argumentList.split(",");
        for(int i = 0; i < args.length; ++i){
            String ptype = getFirstEl(args[i]);
            String name = getSecEl(args[i]);
            methName += "_" + ptype;
            Symbol param = new Symbol(name, ptype);
            methI.addParam(param);
        }

        // update methName of methI: id_type1_type2...
        retId.setName(methName);

        // Check between classes (override violation: ret type diff)
        ClassInfo superClass;
        String currSuperName = className;
        while((superClass = symbt.getSuper(currSuperName)) != null){
            currSuperName = supperClass.getName();
            methSuper = superClass.getMethod(methName);
            if(methSuper == null) continue;
            String retType = methSuper.getRetId().getType();
            if(!retType.equals(type))
                throw new Exception(String.format("Override return types don't match in class %s: (%s-%s)",
                                                  className, type, retType));
        }

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
