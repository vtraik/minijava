import java.io.FileWriter;
import visitor.GJDepthFirst;
import java.util.*;
import syntaxtree.*;
import vtable.*;
import symbol_table.*;

// get order of methods hashmap global between Ref, Vtable, CG visitors
// or just remove it completely ?

// new llvm ir requires ptr instead of bitcasts . Should change code for that

class CodeGenVisitor extends GJDepthFirst<Symbol, String> {
    private VTable vtable;
    private SymbolTable symbt;
    private FileWriter fw;

    private boolean isField = false;
    private int fieldOffs = 0;
    private int reg_id = 0;
    private int label_id = 0;
    private String prevBasicBlock = null;

    public CodeGenVisitor(SymbolTable symbt, VTable vtable, FileWriter fw) {
        this.symbt = symbt;
        this.vtable = vtable;
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


    private Symbol findVar(String id, String scope) throws Exception {
        String className = getFirstEl(scope);
        String methMangName = getSecEl(scope);

        ClassInfo classI = symbt.getClass(className);
        // check Method scope
        if(!methMangName.equals("null")){
            MethodInfo meth = classI.getMethodMang(methMangName);
            Symbol pref = meth.resolveBinding(id);
            if(pref != null) {
                is_field = false;
                return pref; // found local local var or param
            }
        }

        // check Class field scope
        Symbol pref = classI.getField(id);
        if(pref != null) {
            isField = true;
            fieldOffs = 8 + classI.getFieldOffset(); // vtable ptr + field offs
            return pref;
        }

        // find in super class
        ClassInfo superClass = symbt.getSuper(className);

        if(superClass == null) // not found
            return null;
        else
            return findVarType(id, superClass.getName() + "|null");
    }

    private String llvmType(String type) {
        if (t.equals("int"))
            return "i32";
        else if (t.equals("bool"))
            return "i8";
        else if (t.equals("int[]"))
            return "i32*";

        return "i8*"; // classes
    }


    private String newReg() {
        return "r" + reg_id++;
    }

    private String newLabel() {
        return "l" + label_id++;
    }

    private void emit(String code) throws Exception {
        fw.write(code);
    }

    private void emitHelpers() throws Exception {
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

    private emitVtableDecl() {
        // @.className_vtable = global [numMeth x i8*] [methodList]
        for (c : symbt.getClasses()) {
            List<Info> clMeths = c.getMethods();
            emit("@." + c.getName() + "_vtable = global ["
                 + clMeths.size() + " x i8*] [" );
            for (meth : clMeths.getValue()) {
                String defClass = clMeths.get
                String className = clMeths.getKey();
                emit("ptr @" + className + meth.getMangName() ",\n");
            }
        }
    }
i8* bitcast (i32 ()* @func1 to i8*)
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
        String classname = n.f1.f0.tokenImage;

        emitVTableDecl(); // vtable declarations
        emitHelpers();    // boilerplate

        emit("define i32 @main() {\n");

        n.f14.accept(this, classname + "|main_String[]"); // generate code: var declarations
        n.f15.accept(this, classname + "|main_String[]"); // generate code: statements

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
        String className = n.f1.f0.tokenImage;
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
    public Symbol visit(ClassExtendsDeclaration n, String argu) throws Exception {
        String className = n.f1.f0.tokenImage;
        n.f6.accept(this, className + "|null");

        return null;
    }

    // f0 -> Type()
    // f1 -> Identifier()
    // f2 -> ";"
    @Override
    public Symbol visit(VarDeclaration n, String argu) throws Exception {
        String type = n.f0.accept(this, null).getType();
        String name = n.f1.f0.tokenImage;

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
        String className = argu;
        String methName = n.f2.f0.tokenImage;

        ClassInfo classI = symbt.getClass(className);

        // might be temp
        String[] args = n.f4.present() ? n.f4.accept(this, null).split(",") : new String[0]; // ??

        String mangName = new String(methName);

        for(int i = 0; i < args.length; ++i){
            String ptype = getFirstEl(args[i]); // ??
            mangName += "_" + ptype;
        }
        MethodInfo methI = classI.getMethodMang(mangName);

        // define + args
        String type = llvmType(methI.getRetId().getType());
        emit("\ndefine " + type + "@" + name + "(i8* %this");

        // param names := _id
        List<Symbol> params = methI.getParams()
        for (Symbol pref : params) {
            emit(", " + llvmType(pref.getType()) + " %_" + methi.getName());
        }
        emit(") {\n");

        // alloca and store for each argument
        for (Symbol pref : params) {
            String name = pref.getName();
            String type = llvmType(pref.getType())
            emit("\t%" + name + " = alloca " + type + "\n"
                 + "\tstore " + type + " %_" + name + ", " + type + "* %" + name + "\n\n");
        }

        n.f7.accept(this, argu + "|" + mangName); // var decl
        n.f8.accept(this, argu + "|" + mangName); // statements

        Symbol retReg = n.f10.accept(this, argu + "|" + mangName);


        String pref = getFirstEl(retReg.getType()).endsWith("Lit") ? "" : "%";
        // return expr
        emit("ret " + llvmType(methI.getRetId().getType())
             + " " + pref + retReg.getName() + "\n}\n");

        return null;
    }

    @Override
    public Symbol visit(Type n, String argu) throws Exception {
        // .which = 0 -> ArrayType
        //        = 1 -> BooleanType
        //        = 2 -> IntegerType
        //        = 3 -> Identifier
        if (n.f0.which == 3)
            return new Symbol(null, "i8*");
        else
            return super.visit(n, argu);
    }

    @Override
    public Symbol visit(ArrayType n, String argu) {
        return new Symbol(null, "i32*");
    }

    @Override
    public Symbol visit(BooleanType n, String argu) {
        return new Symbol(null, "i1");
    }

    @Override
    public Symbol visit(IntegerType n, String argu) {
        return new Symbol(null, "i32");
    }

    @Override
    public Symbol visit(Identifier n, String argu) throws Exception {
        // when identifier := expression
        Symbol var = findVar(n.f0.tokenImage, argu);
        String type = llvmType(var.getType());

        if(isField) {
            String tempPtr = newReg();
            String tempCast = newReg();
            String tempLoad = newReg();

            // get ptr to field, cast to right type and load field
            emit("\t%" + tempPtr + " = getelementptr i8, i8* %this, i32 " + fieldOffs + "\n"
                + "\t%" + tempCast + " = bitcast i8* %" + tempPtr + " to " + type + "*\n"
                + "\t%" + tempLoad + " = load " + type + ", " + type + "* %" + tempCast + "\n\n"
                );

            return new Symbol(tempLoad, type + "|" + var.getType());
        }

        String tempLoad = newReg();

        emit("\t%" + tempLoad + " = load " + type + ", " + type + "* %" + var.getName() + "\n");

        return new Symbol(tempLoad, type + "|" + var.getType());
    }

    // f0 -> Identifier()
    // f1 -> "="
    // f2 -> Expression()
    // f3 -> ";"
    @Override
    public Symbol visit(AssignmentStatement n, String argu) throws Exception {
        Symbol lvalue = findVar(n.f0.f0.tokenImage, argu);
        String type = llvmType(lvalue.getType());
        // save current state
        boolean lvalueIsField = isField;
        int lvalueOffs = fieldOffs;

        Symbol exprReg = n.f2.accept(this, argu); // expression code

        String pref = getFirstEl(retReg.getType()).endsWith("Lit") ? "" : "%";

        if (lvalueIsField) {
            String tempPtr = newReg();
            String tempCast = newReg();

            // get field'pref ptr, cast to its type, store expr res to it
            emit("\t%" + tempPtr + " = getelementptr i8, i8* %this, i32 " + lvalueOffs + "\n"
                + "\t%" + tempCast + " = bitcast i8* %" + tempPtr + " to " + type + "*\n"
                + "\tstore " + type + " " + pref
                + expr.getName() + ", " + type + "* %" + tempCast + "\n\n"
                );

            return null;
        }

        emit("\tstore " + type + " " + pref
            + expr.getName() + ", " + type + "* %" + lvalue.getName() + "\n\n"
            );

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
        Symbol expr = n.f2.accept(this, argu); // expr code

        String iflabel = newLabel();
        String elselabel = newLabel();
        String exit = newLabel();

        String pref = getFirstEl(expr.getType()).equals("bLit") ? "" : "%";
        emit("br i1 " pref + expr.getName()
            + ", label %" + iflabel + ", label %" + elselabel + "\n\n"
            );

        emit(elselabel + ":\n");
        n.f6.accept(this, argu); // else statement code

        emit("br label %" + exit + "\n\n");

        emit(iflabel + ":\n");
        n.f4.accept(this, argu); // if statement code

        emit("br label %" + exit + "\n\n"
             + exit + ":\n");

        return null;
    }


    // f0 -> "while"
    // f1 -> "("
    // f2 -> Expression()
    // f3 -> ")"
    // f4 -> Statement()
    @Override
    public Symbol visit(WhileStatement n, String argu) throws Exception {
        String entry = newLabel();
        String body  = newLabel();
        String exit  = newLabel();

        emit("br label %" + entry + "\n"
             + entry + ":\n");

        Symbol expr = n.f2.accept(this, argu);

        String pref = getFirstEl(expr.getType()).equals("bLit") ? "" : "%";

        // branch to body if true, else exit
        emit("br i1 " pref + expr.getName()
            + ", label %" + body + ", label %" + exit + "\n\n"
            );

        emit(body + ":\n");

        n.f4.accept(this, argu); // statement code

        emit("br label %" + entry + "\n\n");
        emit(exit + ":\n");

        return null;
    }

    // f0 -> "System.out.println"
    // f1 -> "("
    // f2 -> Expression()
    // f3 -> ")"
    // f4 -> ";"
    @Override
    public Symbol visit(PrintStatement n, String argu) throws Exception {
        Symbol expr = n.f2.accept(this, argu); // expr code

        String pref = getFirstEl(expr.getType()).equals("iLit") ? "" : "%";
        emit("call void i32 @print_int(i32 " + pref + expr.getType() + ")\n\n");

        return null;
    }

    // f0 -> Clause()
    // f1 -> "&&"
    // f2 -> Clause()
    @Override
    public Symbol visit(AndExpression n, String argu) throws Exception {
        Symbol lclause = n.f0.accept(this, argu); // left clause code

        String label1 = newLabel();
        String label2 = newLabel();
        String label3 = newLabel();

        String pref1 = getFirstEl(lclause.getType()).equals("bLit") ? "" : "%";
        emit("br i1 " + pref1 + lclause.getName() + ", label %" + label1 + ", label %" + label2 + "\n\n"
             + label2 + ":\n"
             + "br %" + label3 + "\n\n"
             + label1 + ":\n");

        prevBasicBlock = label1;

        Symbol rclause = n.f2.accept(this, argu); // right clause code

        String pref2 = getFirstEl(rclause.getType()).equals("bLit") ? "" : "%";

        String r = newReg();
        // r takes value either from lclause or rclause
        emit("\tbr label %" + label3 + "\n\n"
            + label3 + ":\n"
            + "\t%" + r + " = phi i1 [ 0, %" + label2 + " ], [ "
            + pref2 + rclause.getId() + ", %" + prevBasicBlock + " ]\n\n"
            );

        prevBasicBlock = label3;

        return new Symbol(r, "i1|boolean");
    }


    // f0 -> PrimaryExpression()
    // f1 -> "<"
    // f2 -> PrimaryExpression()
    @Override
    public Symbol visit(CompareExpression n, String argu) throws Exception {
        Symbol lexpr = n.f0.accept(this, argu);
        Symbol rexpr = n.f2.accept(this, argu);

        String r = newReg();

        String pref1 = getFirstEl(lexpr.getType()).equals("iLit") ? "" : "%";
        String pref2 = getFirstEl(rexpr.getType()).equals("iLit") ? "" : "%";

        emit("\t%" + r + " = icmp slt i32 "
            + "%" + pref1 + lexpr.getName() + ", "
            + "%" + pref2 + rexpr.getName() "\n\n");

        return new Symbol(r, "i1|boolean");
    }

    // f0 -> PrimaryExpression()
    // f1 -> "+"
    // f2 -> PrimaryExpression()
    @Override
    public Symbol visit(PlusExpression n, String argu) throws Exception {
        Symbol lexpr = n.f0.accept(this, argu);
        Symbol rexpr = n.f2.accept(this, argu);

        String r = newReg();

        String pref1 = getFirstEl(lexpr.getType()).equals("iLit") ? "" : "%";
        String pref2 = getFirstEl(rexpr.getType()).equals("iLit") ? "" : "%";

        emit("\t%" + r + " = add i32 %" + lexpr.getName()
             + ", " + "%" + rexpr.getName() + "\n\n");

        return new Symbol(r, "i32|int");
    }

    // f0 -> PrimaryExpression()
    // f1 -> "-"
    // f2 -> PrimaryExpression()
    @Override
    public Symbol visit(MinusExpression n, String argu) throws Exception {
        Symbol lexpr = n.f0.accept(this, argu);
        Symbol rexpr = n.f2.accept(this, argu);

        String r = newReg();

        String pref1 = getFirstEl(lexpr.getType()).equals("iLit") ? "" : "%";
        String pref2 = getFirstEl(rexpr.getType()).equals("iLit") ? "" : "%";

        emit("\t%" + r + " = sub i32 %" + lexpr.getName()
             + ", " + "%" + rexpr.getName() + "\n\n");

        return new Symbol(r, "i32|int");
    }

    // f0 -> PrimaryExpression()
    // f1 -> "*"
    // f2 -> PrimaryExpression()
    @Override
    public Symbol visit(TimesExpression n, String argu) throws Exception {
        Symbol lexpr = n.f0.accept(this, argu);
        Symbol rexpr = n.f2.accept(this, argu);

        String r = newReg();

        String pref1 = getFirstEl(lexpr.getType()).equals("iLit") ? "" : "%";
        String pref2 = getFirstEl(rexpr.getType()).equals("iLit") ? "" : "%";

        emit("\t%" + r + " = mul i32 %" + lexpr.getName()
             + ", " + "%" + rexpr.getName() + "\n\n");

        return new Symbol(r, "i32|int");
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
        Symbol expr = n.f0.accept(this, argu); // expr code

        String r = newReg();
        // first 4 bytes = length of array
        emit("\t%" + r + " = load i32, i32* %" + expr.getName() + "\n\n");

        return new Symbol(r, "i32|int");
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
        Symbol expr = n.f0.accept(this, argu);
        Symbol exprtail = null;

        if (n.f1 != null)
            exprtail = n.f1.accept(this, argu);

        String pref = getFirstEl(expr.getType()).endsWith("Lit") ? "" : "%";
        String r = pref + expr.getName() + (exprtail == null ? "" : exprtail.getName());

        return new VarInfo(r, null); // ??

    }

    // f0 -> ( ExpressionTerm() )*
    @Override
    public Symbol visit(ExpressionTail n, String argu) throws Exception {
        String ret = "";

        for (Node node : n.f0.nodes) {
            Symbol exprt = node.accept(this, argu);
            ret += ", "
                    + (getFirstEl(exprt.getType()).endsWith("Lit") ? "" : "%")
                    + exprt.getName();
        }

        return new VarInfo(ret, null);
    }

    // f0 -> ","
    // f1 -> Expression()
    @Override
    public Symbol visit(ExpressionTerm n, String argu) throws Exception {
        return n.f1.accept(this, argu);
    }

    @Override
    public Symbol visit(IntegerLiteral n, String argu) {
        return new Symbol(n.f0.tokenImage, "iLit|int");
    }

    @Override
    public Symbol visit(TrueLiteral n, String argu) {
        return new Symbol("1", "bLit|boolean");
    }

    @Override
    public Symbol visit(FalseLiteral n, String argu) {
        return new Symbol("0", "bLit|boolean");
    }

    @Override
    public Symbol visit(ThisExpression n, String argu) {
        return new Symbol("this", "i8*|" + getFirstEl(argu));
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
        String className = n.f1.f0.tokenImage;

        String obj_ref = newReg();

    }

    // f0 -> "!"
    // f1 -> Clause()
    @Override
    public Symbol visit(NotExpression n, String argu) throws Exception {
        Symbol clause = n.f1.accept(this, argu);

        // xor with 1 = ! Clause
        String r = newReg();

        String pref1 = getFirstEl(clause.getType()).equals("bLit") ? "" : "%";
        emit("\t%" + r + " = xor i32 1, " + pref + clause.getName() + "\n\n");

        return new Symbol(r, "i1|boolean");
    }

    // f0 -> "("
    // f1 -> Expression()
    // f2 -> ")"
    @Override
    public Symbol visit(BracketExpression n, String argu) throws Exception {
        return n.f1.accept(this, argu);
    }


    // THESE MIGHT BE TEMP . Also i return Symbol, so they should also return that

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
}
