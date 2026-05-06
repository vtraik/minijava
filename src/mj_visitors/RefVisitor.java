import syntaxtree.*;
import symboltable.*;
import visitor.GJDepthFirst;

class RefVisitor extends GJDepthFirst<String, String>{
    private SymbolTable symbt;
    private int methNumber;

    RefVisitor(SymbolTable s){
        symbt = s;
    }

    private String getFirstEl(String scope){
        int indx = scope.indexOf('|');
        return scope.substring(0, indx);
    }

    private String getSecEl(String scope){
        int indx = scope.indexOf('|');
        return scope.substring(indx + 1);
    }

    private boolean subtype(String type1, String type2) throws Exception {
        if(type1.equals("int"))
            return type2.equals("int");
        if(type1.equals("boolean"))
            return type2.equals("boolean");
        if(type1.equals("int[]"))
            return type2.equals("int[]");

        ClassInfo classType1 = symbt.getClass(type1);
        ClassInfo classType2 = symbt.getClass(type2);
        if(classType1 == null)
            throw new Exception(String.format("Undefined type %s", type1));
        else if(classType2 == null)
            throw new Exception(String.format("Undefined type %s", type2));

        if(type1.equals(type2))
            return true;

        return subtyperec(type1, type2);
    }

    private boolean subtyperec(String type1, String type2) {
        if(type2.equals("null")){
            return false;
        }else if(type1.equals(type2)){
            return true;
        }else{
            String superType = symbt.getClass(type2).getSuper().getName();
            return subtyperec(type1, superType);
        }
    }

    // f0  -> "class"
    // f1  -> Identifier()
    // f2  -> "{"
    // f3  -> "public"
    // f4  -> "static"
    // f5  -> "void"
    // f6  -> "main"
    // f7  -> "("
    // f8  -> "String"
    // f9  -> "["
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
        n.f15.accept(this, className + "|null");
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
        n.f4.accept(this, className + "|null");
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
        n.f6.accept(this, className + "|null");
        return null;
    }

    // f0  -> "public"
    // f1  -> Type()
    // f2  -> Identifier()
    // f3  -> "("
    // f4  -> ( FormalParameterList() )?
    // f5  -> ")"
    // f6  -> "{"
    // f7  -> ( VarDeclaration() )*
    // f8  -> ( Statement() )*
    // f9  -> "return"
    // f10 -> Expression()
    // f11 -> ";"
    // f12 -> "}"
    @Override
    public String visit(MethodDeclaration n, String argu) throws Exception {
        String methRetType = n.f1.accept(this, null);
        MethodInfo method = symbt.getNumMeth(methNumber++); // same visit on method decl as the 1st pass
        String methName = method.getMangName();
        String className = getFirstEl(argu);
        n.f8.accept(this, className + "|" + methName);

        String expRetType = n.f10.accept(this, className + "|" + methName);
        if(!subtype(expRetType, methRetType))
            throw new Exception(String.format("Invalid return type in %s.%s", className, methName));

        return null;
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

    // f0 -> Identifier()
    // f1 -> "="
    // f2 -> Expression()
    // f3 -> ";"
    @Override
    public String visit(AssignmentStatement n, String argu) throws Exception {
        String id = n.f0.accept(this, null);
        String expr = n.f2.accept(this, argu);
        if(!subtype(expr, id))
            throw new Exception(String.format("Assignment type mismatch lval:%s, rval:%s", id, expr));
        return null;
    }

    // f0 -> Identifier()
    // f1 -> "["
    // f2 -> Expression()
    // f3 -> "]"
    // f4 -> "="
    // f5 -> Expression()
    // f6 -> ";"
    @Override
    public String visit(ArrayAssignmentStatement n, String argu) throws Exception {

        return null;
    }

    // f0 -> "if"
    // f1 -> "("
    // f2 -> Expression()
    // f3 -> ")"
    // f4 -> Statement()
    // f5 -> "else"
    // f6 -> Statement()
    @Override
    public String visit(IfStatement n, String argu) throws Exception {

        return null;
    }

    // f0 -> "while"
    // f1 -> "("
    // f2 -> Expression()
    // f3 -> ")"
    // f4 -> Statement()
    @Override
    public String visit(WhileStatement n, String argu) throws Exception {

        return null;
    }

    // f0 -> "System.out.println"
    // f1 -> "("
    // f2 -> Expression()
    // f3 -> ")"
    // f4 -> ";"
    @Override
    public String visit(PrintStatement n, String argu) throws Exception {

        return null;
    }

    // f0 -> Clause()
    // f1 -> "&&"
    // f2 -> Clause()
    @Override
    public String visit(AndExpression n, String argu) throws Exception {

        return "boolean";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "<"
    // f2 -> PrimaryExpression()
    @Override
    public String visit(CompareExpression n, String argu) throws Exception {

        return "boolean";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "+"
    // f2 -> PrimaryExpression()
    @Override
    public String visit(PlusExpression n, String argu) throws Exception {

        return "int";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "-"
    // f2 -> PrimaryExpression()
    @Override
    public String visit(MinusExpression n, String argu) throws Exception {

        return "int";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "*"
    // f2 -> PrimaryExpression()
    @Override
    public String visit(TimesExpression n, String argu) throws Exception {

        return "int";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "["
    // f2 -> PrimaryExpression()
    // f3 -> "]"
    @Override
    public String visit(ArrayLookup n, String argu) throws Exception {

        return "int";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "."
    // f2 -> "length"
    @Override
    public String visit(ArrayLength n, String argu) throws Exception {

        return "int";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "."
    // f2 -> Identifier()
    // f3 -> "("
    // f4 -> ( ExpressionList() )?
    // f5 -> ")"
    @Override
    public String visit(MessageSend n, String argu) throws Exception {

        // return type;
        return null;
    }

    // f0 -> Expression()
    // f1 -> ExpressionTail()
    @Override
    public String visit(ExpressionList n, String argu) throws Exception {

        // return ret;
        return null;
    }

    // f0 -> ( ExpressionTerm() )*
    @Override
    public String visit(ExpressionTail n, String argu) throws Exception {

        // return ret;
        return null;
    }

    // f0 -> ","
    // f1 -> Expression()
    @Override
    public String visit(ExpressionTerm n, String argu) throws Exception {
        return n.f1.accept(this, argu);
    }

    @Override
    public String visit(IntegerLiteral n, String argu) {
        return "int";
    }

    @Override
    public String visit(TrueLiteral n, String argu) {
        return "boolean";
    }

    @Override
    public String visit(FalseLiteral n, String argu) {
        return "boolean";
    }

    @Override
    public String visit(Identifier n, String argu) throws Exception {
        String className = getFirstEl(argu);
        String methMangName = getSecEl(argu);
        return symbt.getClass(className).getMethodRetType(methMangName); // should fix
    }

    @Override
    public String visit(Type n, String argu) throws Exception {

        return null;
        // return n.f0.which == 3 ? ((Identifier) n.f0.choice).f0.tokenImage
        //                         : super.visit(n, argu);
    }

    @Override
    public String visit(ThisExpression n, String argu) {
        // return class_id;
        return null;
    }

    // f0 -> "new"
    // f1 -> "int"
    // f2 -> "["
    // f3 -> Expression()
    // f4 -> "]"
    @Override
    public String visit(ArrayAllocationExpression n, String argu) throws Exception {

        return "int[]";
    }

    // f0 -> "new"
    // f1 -> Identifier()
    // f2 -> "("
    // f3 -> ")"
    @Override
    public String visit(AllocationExpression n, String argu) throws Exception {

        // return type;
        return null;
    }

    // f0 -> "!"
    // f1 -> Clause()
    @Override
    public String visit(NotExpression n, String argu) throws Exception {

        return "boolean";
    }

    // f0 -> "("
    // f1 -> Expression()
    // f2 -> ")"
    @Override
    public String visit(BracketExpression n, String argu) throws Exception {
        return n.f1.accept(this, argu);
    }


}
