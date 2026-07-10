import java.io.FileWriter;
import visitor.GJDepthFirst;
import java.util.*;
import syntaxtree.*;
import vtable.*;
import symbol_table.*;

// get order of methods hashmap global between Ref, Vtable, CG visitors
// or just remove it completely ?

// might put String.format in emits to be more readable ?
// messageSend and
class CodeGenVisitor extends GJDepthFirst<Symbol, String> {
    private VTable vtable;
    private SymbolTable symbt;
    private FileWriter fw;

    private boolean isField = false;
    private int fieldOffs = 0;
    private int reg_id = 0;
    private int label_id = 0;
    // for phi. Only updated in expr nodes
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
            return findVar(id, superClass.getName() + "|null");
    }

    private MethodInfo findMethod(String methName, String className) {
        ClassInfo classI = symbt.getClass(className);

        MethodInfo meth = classI.getMethodMang(methName); // ??
        if (meth != null)
            return meth;
        else
            return findMethod(methName, symbt.getSuperClass(className));
    }

    private int getMethodOffset(String className, String methodName) throws Exception {
        ClassInfo classInfo = symbt.getClass(className);
        int offs= classInfo.getMethOffset(methodName);

        if (offset == null)
            return getMethodOffset(symbt.getSuper(className), methName);
        else
            return offset;
    }

    private String llvmType(String type) {
        if (type.equals("int"))
            return "i32";
        else if (type.equals("bool"))
            return "i8";

        return "ptr"; // classes, int arrays
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
        emit("declare ptr @calloc(i32, i32)\n"
            + "declare i32 @printf(ptr, ...)\n"
            + "declare void @exit(i32)\n\n"
            + "@_cint = constant [4 x i8] c\"%d\\0a\\00\"\n"
            + "@_cOOB = constant [15 x i8] c\"Out of bounds\\0a\\00\"\n\n"
            + "define void @print_int(i32 %i) {\n"
            + "\tcall i32 (ptr, ...) @printf(ptr @_cint, i32 %i)\n"
            + "\tret void\n"
            + "}\n\n"
            + "define void @throw_oob() {\n"
            + "\tcall i32 (ptr, ...) @printf(ptr @_cOOB)\n"
            + "\tcall void @exit(i32 1)\n"
            + "\tret void\n"
            + "}\n\n"
        );
    }

    private void emitVtableDecl() {
        for (c : symbt.getClasses()) {
            List<Info> clMeths = c.getMethods();
            methNum = clMeths.size();

            // @.className_vtable = global [numMeth x ptr] [methodList]
            emit("@." + c.getName() + "_vtable = global ["
                 + methNum  + " x ptr] [" );

            for (meth : clMeths) {
                String defClass = clMeths.getDefClass();
                // ptr @defClass.foo_(paramtypes)
                emit("ptr @" + defClass + "." + meth.getMangName());

                methNum--;
                emit(methNum == 0 ? "" : ", ");
            }

            emit("]\n");
        }

        emit("\n");
    }

    // emits code for oob check and returns a ptr to that mem
    private String emitCheckOOB(String arrSize) {
        String pref = getFirstEl(expr.getType()).equals("iLit") ? "" : "%";
        emit("\t%" + arrSize + " = add i32 1, " + pref + expr.getName() + "\n");

        // size >= 1 (since arr[0] = size)
        String cmp = newReg();
        emit("\t%" + cmp + " = icmp sge i32 %" + arrSize + ", 1\n");

        String elselabel = newLabel();
        String thenlabel = newLabel();
        String alloc = newTemp();

        emit("\tbr i1 %" + cmp + ", label %" + thenlabel + ", label %" + elselabel + "\n\n"
             + elselabel + ":\n"
                + "\tcall void @throw_oob()\n"
                + "\tbr label %" + thenlabel + "\n\n"
            + thenlabel + ":\n"
                + "\t%" + alloc + " = call ptr @calloc(i32 %" + size + ", i32 4)\n"
                );

        emit("\tstore i32 " + pref + expr.getName() + ", ptr %" + alloc + "\n\n");
        return alloc;
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
        String classname = n.f1.f0.tokenImage;

        emitVtableDecl(); // vtable declarations
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

        // i32,i1 = 0 | ptr, ptr = null
        emit("\t%" + name + " = alloca " + type + "\n"
             + "\tstore " + type + " "
             +  (type.equals("i32") || type.equals("i1") ? "0" : "null")
             + ", " "ptr %" + name + "\n\n"
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
        String[] args = n.f4.present() ? n.f4.accept(this, null).getName().split(",") : new String[0];

        String mangName = new String(methName);

        for(int i = 0; i < args.length; ++i){
            String ptype = getFirstEl(args[i]);
            mangName += "_" + ptype;
        }
        MethodInfo methI = classI.getMethodMang(mangName);

        // define + args
        String type = llvmType(methI.getRetId().getType());
        emit("\ndefine " + type + "@" + className + "." + mangName +  "(ptr %this");

        // param names := _id
        List<Symbol> params = methI.getParams();
        for (Symbol pref : params) {
            emit(", " + llvmType(pref.getType()) + " %_" + methi.getName());
        }
        emit(") {\n");

        // alloca and store for each argument
        for (Symbol pref : params) {
            String name = pref.getName();
            String type = llvmType(pref.getType())
            emit("\t%" + name + " = alloca " + type + "\n"
                 + "\tstore " + type + " %_" + name + ", " + "ptr %" + name + "\n\n");
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
            return new Symbol(null, "ptr");
        else
            return super.visit(n, argu);
    }

    @Override
    public Symbol visit(ArrayType n, String argu) {
        return new Symbol(null, "ptr");
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
            String tempLoad = newReg();

            // get ptr to field, cast to right type and load field
            emit("\t%" + tempPtr + " = getelementptr i8, ptr %this, i32 " + fieldOffs + "\n"
                + "\t%" + tempLoad + " = load " + type + ", ptr %" + tempPtr + "\n\n"
                );

            return new Symbol(tempLoad, type + "|" + var.getType());
        }

        String tempLoad = newReg();

        emit("\t%" + tempLoad + " = load " + type + ", " + "ptr %" + var.getName() + "\n");

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

        String pref = getFirstEl(exprReg.getType()).endsWith("Lit") ? "" : "%";

        if (lvalueIsField) {
            String tempPtr = newReg();

            // get field'pref ptr, cast to its type, store expr res to it
            emit("\t%" + tempPtr + " = getelementptr i8, ptr %this, i32 " + lvalueOffs + "\n"
                + "\tstore " + type + " " + pref
                + expr.getName() + ", ptr %" + tempPtr + "\n\n"
                );

            return null;
        }

        emit("\tstore " + type + " " + pref
            + expr.getName() + ", " + "ptr %" + lvalue.getName() + "\n\n"
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
        Symbol arr = findVar(n.f0.f0.tokenImage, argu);
        // capture current state
        boolean lvalueIsField = isField;
        int lvalueOffs = fieldOffs;

        Symbol idx = n.f2.accept(this, argu); // expr code
        Symbol expr = n.f5.accept(this, argu); // expr code

        String thenlabel = newLabel();
        String elselabel = newLabel();

        String load;

        if (lvalueIsField) {
            String ptr = newReg();
            load = newReg();
            emit("\t%" + ptr + " = getelementptr i8, ptr %this, i32 " + lvalueOffs + "\n"
                + "\t%" + temp_load + " = load ptr, ptr %" + ptr + "\n"
                );
        } else {
            load = newReg();
            emit("\t%" + load + " = load ptr, ptr %" + arr.getName() + "\n");
        }

        // check for oob
        String arrSize = newReg();
        emit("\t%" + arrSize + " = load i32, ptr %" + load + "\n\n");
        emitCheckOOB(arrSize);

        prevBasicBlock = thenlabel;
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
        emit("call void @print_int(i32 " + pref + expr.getName() + ")\n\n");

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
            + pref2 + rclause.getName() + ", %" + prevBasicBlock + " ]\n\n"
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
            + pref1 + lexpr.getName() + ", "
            + pref2 + rexpr.getName() "\n\n");

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

        emit("\t%" + r + " = add i32 " + pref1 + lexpr.getName() + ", "
             + pref2 + rexpr.getName() + "\n\n");
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

        emit("\t%" + r + " = sub i32 " + pref1 + lexpr.getName() + ", "
             + pref2 + rexpr.getName() + "\n\n");

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

        emit("\t%" + r + " = mul i32 " + pref1 + lexpr.getName() + ", "
             + pref2 + rexpr.getName() + "\n\n");

        return new Symbol(r, "i32|int");
    }

    // f0 -> PrimaryExpression()
    // f1 -> "["
    // f2 -> PrimaryExpression()
    // f3 -> "]"
    @Override
    public Symbol visit(ArrayLookup n, String argu) throws Exception {
        Symbol arrBase = n.f0.accept(this, argu);
        Symbol idx = n.f2.accept(this, argu);
        String arrSize = newReg();
        emit("\t%" + size + " = load i32, ptr %" + arrBase.getName() + "\n");
        emitCheckOOB(arrSize);
        prevBasicBlock = thenlabel;
        return new Symbol(res, "i32|int");
    }

    // f0 -> PrimaryExpression()
    // f1 -> "."
    // f2 -> "length"
    @Override
    public Symbol visit(ArrayLength n, String argu) throws Exception {
        Symbol expr = n.f0.accept(this, argu); // expr code

        String r = newReg();
        // first 4 bytes = length of array
        emit("\t%" + r + " = load i32, ptr %" + expr.getName() + "\n\n");

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
        Symbol obj = n.f0.accept(this, argu); // expression code
        String methodName = n.f2.f0.tokenImage;

        // expression list code
        // Symbol(num or %r<num>, %r<num>.., type1_type2_..)
        Symbol args = n.f4.present() ? n.f4.accept(this, argu) : new Symbol("", null);

        String methMang = methodName + "_" + args.getType();
        MethodInfo methodInfo = findMethod(methMang, getSecEl(obj.getType()));
        String methType = methodInfo.getRetId().getType();

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
        String rTypes = getSecEl(expr.getType()) + (exprtail == null ? "" : "_" + exprtail.getType());

        return new Symbol(r, rTypes); // Symbol(num or %r<num>, %r<num>.., type1_type2_..)

    }

    // f0 -> ( ExpressionTerm() )*
    @Override
    public Symbol visit(ExpressionTail n, String argu) throws Exception {
        String retNames = "";
        String retTypes = "";

        for (Node node : n.f0.nodes) {
            Symbol exprt = node.accept(this, argu);
            retNames += ", "
                    + (getFirstEl(exprt.getType()).endsWith("Lit") ? "" : "%")
                    + exprt.getName();
            retTypes += "_" + getSecEl(exprt.getType());
        }

        return new Symbol(retNames, retTypes);
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
        return new Symbol("this", "ptr|" + getFirstEl(argu));
    }

    // f0 -> "new"
    // f1 -> "int"
    // f2 -> "["
    // f3 -> Expression()
    // f4 -> "]"
    @Override
    public Symbol visit(ArrayAllocationExpression n, String argu) throws Exception {
        Symbol expr = n.f3.accept(this, argu); // expr code
        String arrSize = newReg();
        String allocPtr = emitCheckOOB(arrSize);
        prevBasicBlock = thenlabel;
        return new Symbol(allocPtr, "ptr|int[]");
    }

    // f0 -> "new"
    // f1 -> Identifier()
    // f2 -> "("
    // f3 -> ")"
    @Override
    public Symbol visit(AllocationExpression n, String argu) throws Exception {
        String className = n.f1.f0.tokenImage;

        String objRef = newReg();
        // objsize = 8 (vtable size) + fieldoffset (accum variable)
        int objSize = 8 + symbt.getClass(className).getFieldOffset();

        emit("\t%" + objRef + " = call ptr @calloc(i32 1, i32 " + objSize + ")\n");

        String base = newReg();
        int numMeths = vtable.getNumMeths(className);

        // write vtable ptr to obj heap space
        emit("\t%" + base + " = getelementptr [" + numMeths + " x ptr]"
            + ", ptr @." + className + "_vtable, i32 0, i32 0\n"
            + "\tstore ptr %" + base + ", ptr %" + objRef + "\n\n"
            );

        return new Symbol(objRef, "ptr|" + className);
    }

    // f0 -> "!"
    // f1 -> Clause()
    @Override
    public Symbol visit(NotExpression n, String argu) throws Exception {
        Symbol clause = n.f1.accept(this, argu);

        // xor with 1 = ! Clause
        String r = newReg();

        String pref1 = getFirstEl(clause.getType()).equals("bLit") ? "" : "%";
        emit("\t%" + r + " = xor i1 1, " + pref + clause.getName() + "\n\n");

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
    public Symbol visit(FormalParameterList n, String argu) throws Exception {
        String ret = n.f0.accept(this, null).getName(); // type|id

        if (n.f1 != null) {
            ret += n.f1.accept(this, null).getName();
        }

        return new Symbol(ret, null);
    }

     // f0 -> FormalParameter()
     // f1 -> FormalParameterTail()
    @Override
    public Symbol visit(FormalParameterTerm n, String argu) throws Exception {
        return n.f1.accept(this, null);
    }

     // f0 -> ","
     // f1 -> FormalParameter()
    @Override
    public Symbol visit(FormalParameterTail n, String argu) throws Exception {
        String ret = "";
        for ( Node node: n.f0.nodes) {
            ret += "," + node.accept(this, null).getName();
        }

        return new Symbol(ret, null);
    }

     // f0 -> Type()
     // f1 -> Identifier()
    @Override
    public Symbol visit(FormalParameter n, String argu) throws Exception {
        String type = n.f0.accept(this, null);
        String name = n.f1.f0.tokenImage;
        return new Symbol(type + "|" + name, null);
    }
}
