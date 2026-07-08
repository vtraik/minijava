import java.io.FileWriter;
import visitor.GJDepthFirst;
import java.util.*;
import syntaxtree.*;
import vtable.*;
import symbol_table.*;


class CodeGenVisitor extends GJDepthFirst<Symbol, String> {
    private VTable vt;
    private SymbolTable st;
    private FileWriter fw;

    public CodeGenVisitor(SymbolTable st, VTable vt, FileWriter fw) {
        this.st = st;
        this.vt = vt;
        this.fw = fw;
    }

    private String getFirstEl(String scope){
        int indx = scope.indexOf('|');
        return scope.substring(0, indx);
    }

    private String getSecEl(String scope){
        int indx = scope.indexOf('|');
        return scope.substring(indx + 1);
    }

    private emit(String code) throws Exception {
        fw.write(code);
    }

    private emitHelpers() throws Exception {
        emit("declare i8* @calloc(i32, i32)\n"
            + "declare i32 @printf(i8*, ...)\n"
            + "declare void @exit(i32)\n\n"
            + "@_cint = constant [4 x i8] c\"%d\\0a\\00\"\n"
            + "@_cOOB = constant [15 x i8] c\"Out of bounds\\0a\\00\"\n\n"
            + "define void @print_int(i32 %i) {\n"
            + "\t%_str = bitcast [4 x i8]* @_cint to i8*\n"
            + "\tcall i32 (i8*, ...) @printf(i8* %_str, i32 %i)\n"
            + "\tret void\n"
            + "}\n\n"
            + "define void @throw_oob() {\n"
            + "\t%_str = bitcast [15 x i8]* @_cOOB to i8*\n"
            + "\tcall i32 (i8*, ...) @printf(i8* %_str)\n"
            + "\tcall void @exit(i32 1)\n"
            + "\tret void\n"
            + "}\n\n"
        );
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
    public Symbol visit(MainClass n, String argu) throws Exception {
        String classname = n.f1.accept(this, null);

        emitVTable();  // vtable declarations
        emitHelpers(); // boilerplate

        emit("define i32 @main() {\n");

        n.f14.accept(this, classname + "|main"); // generate code: var declarations
        n.f15.accept(this, classname + "|main"); // generate code: statements

        emit("\n\tret i32 0\n}\n");

        return null;
    }

    // f0 -> "class"
    // f1 -> Identifier()
    // f2 -> "{"
    // f3 -> ( VarDeclaration() )*
    // f4 -> ( MethodDeclaration() )*
    // f5 -> "}"
    @Override
    public Symbol visit(ClassDeclaration n, String argu) throws Exception {
        String className = n.f1.accept(this, null);
        n.f4.accept(this, className);

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
    public Symbol visit(ClassExtendsDeclaration n, String argu) throws Exception {
        String className = n.f1.accept(this, null);
        n.f6.accept(this, className);

        return null;
    }

    // f0 -> Type()
    // f1 -> Identifier()
    // f2 -> ";"
    @Override
    public Symbol visit(VarDeclaration n, String argu) throws Exception {
        String type = n.f0.accept(this, null).getType();
        String name = n.f1.f0.accept(this, null);

        // i32,i1 = 0 | i32*,i8* = null
        emit("\t%" + name + " = alloca " + type + "\n"
             + "\tstore " + type + " "
             +  (type.equals("i32") || type.equals("i1") ? "0" : "null")
             + ", " + type + "* %" + name + "\n\n"
             );

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
    public Symbol visit(MethodDeclaration n, String argu) throws Exception {

    }

    @Override
    public Symbol visit(Type n, String argu) throws Exception {

    }

    @Override
    public Symbol visit(ArrayType n, String argu) {

    }

    @Override
    public Symbol visit(BooleanType n, String argu) {

    }

    @Override
    public Symbol visit(IntegerType n, String argu) {

    }

    @Override
    public Symbol visit(Identifier n, String argu) throws Exception {

    }

    // f0 -> Identifier()
    // f1 -> "="
    // f2 -> Expression()
    // f3 -> ";"
    @Override
    public Symbol visit(AssignmentStatement n, String argu) throws Exception {

    }

    // f0 -> Identifier()
    // f1 -> "["
    // f2 -> Expression()
    // f3 -> "]"
    // f4 -> "="
    // f5 -> Expression()
    // f6 -> ";"
    @Override
    public Symbol visit(ArrayAssignmentStatement n, String argu) throws Exception {

    }

    // f0 -> "if"
    // f1 -> "("
    // f2 -> Expression()
    // f3 -> ")"
    // f4 -> Statement()
    // f5 -> "else"
    // f6 -> Statement()
    @Override
    public Symbol visit(IfStatement n, String argu) throws Exception {

    }


    // f0 -> "while"
    // f1 -> "("
    // f2 -> Expression()
    // f3 -> ")"
    // f4 -> Statement()
    @Override
    public Symbol visit(WhileStatement n, String argu) throws Exception {

    }

    // f0 -> "System.out.println"
    // f1 -> "("
    // f2 -> Expression()
    // f3 -> ")"
    // f4 -> ";"
    @Override
    public Symbol visit(PrintStatement n, String argu) throws Exception {

    }

    // f0 -> Clause()
    // f1 -> "&&"
    // f2 -> Clause()
    @Override
    public Symbol visit(AndExpression n, String argu) throws Exception {

    }

    // f0 -> PrimaryExpression()
    // f1 -> "<"
    // f2 -> PrimaryExpression()
    @Override
    public Symbol visit(CompareExpression n, String argu) throws Exception {

    }

    // f0 -> PrimaryExpression()
    // f1 -> "+"
    // f2 -> PrimaryExpression()
    @Override
    public Symbol visit(PlusExpression n, String argu) throws Exception {

    }

    // f0 -> PrimaryExpression()
    // f1 -> "-"
    // f2 -> PrimaryExpression()
    @Override
    public Symbol visit(MinusExpression n, String argu) throws Exception {

    }

    // f0 -> PrimaryExpression()
    // f1 -> "*"
    // f2 -> PrimaryExpression()
    @Override
    public Symbol visit(TimesExpression n, String argu) throws Exception {

    }

    // f0 -> PrimaryExpression()
    // f1 -> "["
    // f2 -> PrimaryExpression()
    // f3 -> "]"
    @Override
    public Symbol visit(ArrayLookup n, String argu) throws Exception {

    }

    // f0 -> PrimaryExpression()
    // f1 -> "."
    // f2 -> "length"
    @Override
    public Symbol visit(ArrayLength n, String argu) throws Exception {

    }

    // f0 -> PrimaryExpression()
    // f1 -> "."
    // f2 -> Identifier()
    // f3 -> "("
    // f4 -> ( ExpressionList() )?
    // f5 -> ")"
    @Override
    public Symbol visit(MessageSend n, String argu) throws Exception {

    }

    // f0 -> Expression()
    // f1 -> ExpressionTail()
    @Override
    public Symbol visit(ExpressionList n, String argu) throws Exception {

    }

    // f0 -> ( ExpressionTerm() )*
    @Override
    public Symbol visit(ExpressionTail n, String argu) throws Exception {

    }

    // f0 -> ","
    // f1 -> Expression()
    @Override
    public Symbol visit(ExpressionTerm n, String argu) throws Exception {

    }

    @Override
    public Symbol visit(IntegerLiteral n, String argu) {

    }

    @Override
    public Symbol visit(TrueLiteral n, String argu) {

    }

    @Override
    public Symbol visit(FalseLiteral n, String argu) {

    }

    @Override
    public Symbol visit(ThisExpression n, String argu) {

    }

    // f0 -> "new"
    // f1 -> "int"
    // f2 -> "["
    // f3 -> Expression()
    // f4 -> "]"
    @Override
    public Symbol visit(ArrayAllocationExpression n, String argu) throws Exception {

    }

    // f0 -> "new"
    // f1 -> Identifier()
    // f2 -> "("
    // f3 -> ")"
    @Override
    public Symbol visit(AllocationExpression n, String argu) throws Exception {

    }

    // f0 -> "!"
    // f1 -> Clause()
    @Override
    public Symbol visit(NotExpression n, String argu) throws Exception {

    }

    // f0 -> "("
    // f1 -> Expression()
    // f2 -> ")"
    @Override
    public Symbol visit(BracketExpression n, String argu) throws Exception {

    }
}
