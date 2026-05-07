import syntaxtree.*;
import symboltable.*;
import visitor.GJDepthFirst;
import java.util.List;

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
        if(type1.equals(type2) && type1 != null)
            return true;

        ClassInfo superClass = symbt.getClass(type2).getSuper();
        if(superClass == null)
            return false;
        else
            return subtyperec(type1, superClass.getName());
    }

    private String findVarType(String id, String scope) throws Exception {
        String className = getFirstEl(scope);
        String methMangName = getSecEl(scope);

        // check Method scope
        if(!methMangName.equals("null")){
            MethodInfo meth = symbt.getClass(className).getMethodMang(methMangName);
            Symbol s = meth.resolveBinding(id);
            if(s != null)
                return s.getType();
        }

        // check Class field scope
        Symbol s = symbt.getClass(className).getField(id);
        if(s != null)
            return s.getType();

        // find in super class
        ClassInfo superClassName = symbt.getSuper(className);

        if(superClassName == null) // not found
            return null;
        else
            return findVarType(id, superClassName.getName() + "|" + methMangName);
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
        String className = n.f1.f0.tokenImage;
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
    public String visit(ClassExtendsDeclaration n, String argu) throws Exception {
        String className = n.f1.f0.tokenImage;
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
            throw new Exception(String.format("Return type mismatch in %s.%s -> expected <%s>, got <%s>",
                                              className, methName, methRetType, expRetType));

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
        String id = n.f0.accept(this, argu);
        String expr = n.f2.accept(this, argu);
        if(!subtype(expr, id))
            throw new Exception(String.format("Assignment type mismatch -> lval:%s, rval:%s", id, expr));

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
        String idType = n.f0.accept(this, argu);
        String indxType = n.f2.accept(this, argu);
        String exprType = n.f5.accept(this, argu);

        if(!idType.equals("int[]"))
            throw new Exception(String.format("Invalid lvalue type in array assignment statement -> %s", idType));

        if(!indxType.equals("int"))
            throw new Exception("Array size expression must have integral type");

        if(!exprType.equals("int"))
            throw new Exception("rvalue must have integral type in array assignment");

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
        String exprType = n.f2.accept(this, argu);
        if(!exprType.equals("boolean"))
            throw new Exception("Condition in if statement must be of type boolean");

        n.f4.accept(this, argu);
        n.f6.accept(this, argu);

        return null;
    }

    // f0 -> "while"
    // f1 -> "("
    // f2 -> Expression()
    // f3 -> ")"
    // f4 -> Statement()
    @Override
    public String visit(WhileStatement n, String argu) throws Exception {
        String exprType = n.f2.accept(this, argu);
        if(!exprType.equals("boolean"))
            throw new Exception("Condition in while statement must be of type boolean");

        n.f4.accept(this, argu);

        return null;
    }

    // f0 -> "System.out.println"
    // f1 -> "("
    // f2 -> Expression()
    // f3 -> ")"
    // f4 -> ";"
    @Override
    public String visit(PrintStatement n, String argu) throws Exception { // what types are allowed ??
        n.f2.accept(this, argu);
        return null;
    }

    // f0 -> Clause()
    // f1 -> "&&"
    // f2 -> Clause()
    @Override
    public String visit(AndExpression n, String argu) throws Exception {
        String type1 = n.f0.accept(this, argu);
        String type2 = n.f2.accept(this, argu);
        if(!type1.equals("boolean"))
            throw new Exception(String.format("Invalid type in (&&) expression -> %s", type1));
        if(!type2.equals("boolean"))
            throw new Exception(String.format("Invalid type in (&&) expression -> %s", type2));

        return "boolean";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "<"
    // f2 -> PrimaryExpression()
    @Override
    public String visit(CompareExpression n, String argu) throws Exception {
        String type1 = n.f0.accept(this, argu);
        String type2 = n.f2.accept(this, argu);
        if(!type1.equals("int"))
            throw new Exception(String.format("Invalid type in (<) expression -> %s", type1));
        if(!type2.equals("int"))
            throw new Exception(String.format("Invalid type in (<) expression -> %s", type2));

        return "boolean";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "+"
    // f2 -> PrimaryExpression()
    @Override
    public String visit(PlusExpression n, String argu) throws Exception {
        String type1 = n.f0.accept(this, argu);
        String type2 = n.f2.accept(this, argu);
        if(!type1.equals("int"))
            throw new Exception(String.format("Invalid type in (+) expression -> %s", type1));
        if(!type2.equals("int"))
            throw new Exception(String.format("Invalid type in (+) expression -> %s", type2));

        return "int";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "-"
    // f2 -> PrimaryExpression()
    @Override
    public String visit(MinusExpression n, String argu) throws Exception {
        String type1 = n.f0.accept(this, argu);
        String type2 = n.f2.accept(this, argu);
        if(!type1.equals("int"))
            throw new Exception(String.format("Invalid type in (-) expression -> %s", type1));
        if(!type2.equals("int"))
            throw new Exception(String.format("Invalid type in (-) expression -> %s", type2));

        return "int";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "*"
    // f2 -> PrimaryExpression()
    @Override
    public String visit(TimesExpression n, String argu) throws Exception {
        String type1 = n.f0.accept(this, argu);
        String type2 = n.f2.accept(this, argu);
        if(!type1.equals("int"))
            throw new Exception(String.format("Invalid type in (*) expression -> %s", type1));
        if(!type2.equals("int"))
            throw new Exception(String.format("Invalid type in (*) expression -> %s", type2));

        return "int";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "["
    // f2 -> PrimaryExpression()
    // f3 -> "]"
    @Override
    public String visit(ArrayLookup n, String argu) throws Exception {
        String type1 = n.f0.accept(this, argu);
        String type2 = n.f2.accept(this, argu);
        if(!type1.equals("int[]"))
            throw new Exception(String.format("Invalid type in array lookup expression -> %s", type1));
        if(!type2.equals("int"))
            throw new Exception(String.format("Invalid type in array index -> %s", type2));

        return "int";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "."
    // f2 -> "length"
    @Override
    public String visit(ArrayLength n, String argu) throws Exception {
        String type1 = n.f0.accept(this, argu);
        if(!type1.equals("int[]"))
            throw new Exception(String.format(".length is not supported for type -> %s", type1));

        return "int";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "."
    // f2 -> Identifier()
    // f3 -> "("
    // f4 -> ( ExpressionList() )?
    // f5 -> ")"
    @Override
    public String visit(MessageSend n, String argu) throws Exception { // ??
        String exprType = n.f0.accept(this, argu);
        String id = n.f2.f0.tokenImage;
        String retType = null;

        ClassInfo classI = symbt.getClass(exprType);
        if(classI == null)
            throw new Exception(String.format("Class %s isn't defined", classI.getName()));

        List<MethodInfo> classMeths = classI.getMethod(id);
        if(classMeths == null)
            throw new Exception(String.format("Method %s isn't defined", classI.getName()));

        String[] expressions = n.f4.present() ? n.f4.accept(this, argu).split(",") : new String[0];

        int argMatched = -1;
        for(int i = 0; i < classMeths.size(); ++i){
            MethodInfo meth = classMeths.get(i);
            int numParams = meth.getNumParams();
            List<Symbol> params = meth.getParams();

            if(expressions.length != numParams) continue;

            argMatched = 0;
            for(int j = 0; j < numParams; ++j){
                String methType = params.get(i).getType();
                if(!subtype(expressions[j], methType))
                    break;
                ++argMatched;
            }

            if(argMatched == numParams){
                retType = meth.getRetId().getType();
                break;
            }
        }

        if(argMatched != expressions.length){
            String types = String.join(", ", expressions);
            throw new Exception(String.format("No matching method found -> %s.%s(%s)",
                                classI.getName(), id, types));
        }

        return retType;
    }

    // f0 -> Expression()
    // f1 -> ExpressionTail()
    @Override
    public String visit(ExpressionList n, String argu) throws Exception {
        String ret = n.f0.accept(this, argu);

        if (n.f1 != null) {
            ret += n.f1.accept(this, argu);
        }

        return ret;
    }

    // f0 -> ( ExpressionTerm() )*
    @Override
    public String visit(ExpressionTail n, String argu) throws Exception {
        String ret = "";
        for (Node node: n.f0.nodes) {
            ret += "," + node.accept(this, argu);
        }

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
        String ret;
        if((ret = findVarType(n.f0.tokenImage, argu)) == null){
            String classN = getFirstEl(argu);
            String methN = getSecEl(argu);
            int idx = methN.indexOf('_');
            methN = (idx == -1) ? methN : methN.substring(0, idx);
            throw new Exception(String.format("Undefined identifier %s in %s.%s", n.f0.tokenImage, classN, methN));
        }
        return ret;
    }

    @Override
    public String visit(Type n, String argu) throws Exception {
        // decl id (Type Identifier) has different action from ref id (Identifier)
        if(n.f0.which == 3) // in declaration => should return just the id and not my override
            return ((Identifier) n.f0.choice).f0.tokenImage;
        else
           return super.visit(n, argu);
    }

    @Override
    public String visit(ThisExpression n, String argu) {
        String className = getFirstEl(argu);
        return className;
    }

    // f0 -> "new"
    // f1 -> "int"
    // f2 -> "["
    // f3 -> Expression()
    // f4 -> "]"
    @Override
    public String visit(ArrayAllocationExpression n, String argu) throws Exception {
        String type = n.f3.accept(this, argu);
        if(!type.equals("int"))
            throw new Exception("Array size expression must have integral type");

        return "int[]";
    }

    // f0 -> "new"
    // f1 -> Identifier()
    // f2 -> "("
    // f3 -> ")"
    @Override
    public String visit(AllocationExpression n, String argu) throws Exception {
        String className = n.f1.f0.tokenImage;
        ClassInfo classI = symbt.getClass(className);
        if(classI == null)
            throw new Exception(String.format("Class %s isn't defined", className));

        return classI.getName();
    }

    // f0 -> "!"
    // f1 -> Clause()
    @Override
    public String visit(NotExpression n, String argu) throws Exception {
        String type = n.f1.accept(this, argu);
        if(!type.equals("boolean"))
            throw new Exception(String.format("Invalid not expression type -> %s", type));

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
