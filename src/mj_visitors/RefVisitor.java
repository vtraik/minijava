import syntaxtree.*;
import symboltable.*;
import visitor.GJDepthFirst;

class RefVisitor extends GJDepthFirst<String, String>{
    private SymbolTable symbt;

    RefVisitor(SymbolTable s){
        symbt = s;
    }

    private String getFirstEl(String scope){
        int indx = scope.indexOf('|');
        return scope.substring(0, indx);
    }

    private String getSecEl(String scope){
        int indx = scope.indexOf('|');
        return scope.substring(indx);
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
    }

    // f0 -> Expression()
    // f1 -> ExpressionTail()
    @Override
    public String visit(ExpressionList n, String argu) throws Exception {

        return ret;
    }

    // f0 -> ( ExpressionTerm() )*
    @Override
    public String visit(ExpressionTail n, String argu) throws Exception {

        return ret;
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

        // return type;
    }

    @Override
    public String visit(Type n, String argu) throws Exception {

        return n.f0.which == 3 ? ((Identifier) n.f0.choice).f0.tokenImage
                                : super.visit(n, argu);
    }

    @Override
    public String visit(ThisExpression n, String argu) {
        // return class_id;
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
