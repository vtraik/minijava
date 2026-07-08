import java.util.*;
import syntaxtree.*;
import visitor.GJDepthFirst;
import symboltable.*;

class RefVisitor extends GJDepthFirst<String, String>{
    private SymbolTable symbt;
    private int methNumber;

    public RefVisitor(SymbolTable s){
        symbt = s;
    }

    // find nodetoken to get error coordinates
    public NodeToken getToken(Node n){
        if(n instanceof NodeToken){
            return (NodeToken) n;
        }

        if(n instanceof NodeChoice){
            return getToken(((NodeChoice) n).choice);
        }

        try{
            java.lang.reflect.Field f = n.getClass().getField("f0");
            Node child = (Node) f.get(n);
            return getToken(child);
        }catch(Exception e){
            return null;
        }
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
        if(type1.equals(type2) && type1 != null)
            return true;

        ClassInfo superClass = symbt.getClass(type1).getSuper();
        if(superClass == null)
            return false;
        else
            return subtyperec(superClass.getName(), type2);
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
        ClassInfo superClass = symbt.getSuper(className);

        if(superClass == null) // not found
            return null;
        else
            return findVarType(id, superClass.getName() + "|null");
    }

    private String findMethodRetType(ClassInfo classI, String name, String[] args) throws Exception {
        if(classI == null) // no other class in the hierarchy
            return null;

        List<MethodInfo> classMeths = classI.getMethod(name);
        if(classMeths == null) // no method with same name in this class
            return findMethodRetType(classI.getSuper(), name, args);

        MethodInfo compMeth = getClassCompMethod(classMeths, args);

        if(compMeth != null)
            return compMeth.getRetId().getType();

        return findMethodRetType(classI.getSuper(), name, args);

    }

    private MethodInfo getClassCompMethod(List<MethodInfo> classMeths, String[] args) throws Exception {
        int argMatched = -1;
        for(int i = 0; i < classMeths.size(); ++i){
            MethodInfo meth = classMeths.get(i);
            int numParams = meth.getNumParams();
            List<Symbol> params = meth.getParams();

            if(args.length != numParams) continue;

            argMatched = 0;
            for(int j = 0; j < numParams; ++j){
                String methType = params.get(j).getType();
                if(!subtype(args[j], methType))
                    break;
                ++argMatched;
            }

            if(argMatched == numParams){
                return meth; // found a compatible method
            }
        }
        return null;
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
        n.f15.accept(this, className + "|main_String[]");

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
            throw new Exception(String.format("Return type mismatch in %s.%s at %s:%s -> expected <%s>, got <%s>",
                                              className, method.getRetId().getName(),
                                              getToken(n.f10).beginLine, getToken(n.f10).beginColumn,
                                              methRetType, expRetType));

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
        if(!subtype(expr, id)){
            throw new Exception(String.format("Assignment type mismatch at %s:%s -> lval:%s, rval:%s",
                                              getToken(n.f0).beginLine, getToken(n.f0).beginColumn, id, expr));
        }

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
            throw new Exception(String.format("Invalid lvalue type at %s:%s -> %s",
                                              getToken(n.f0).beginLine, getToken(n.f0).beginColumn, idType));

        if(!indxType.equals("int"))
            throw new Exception(String.format("Array size must have integral type at %s:%s",
                                              getToken(n.f2).beginLine, getToken(n.f2).beginColumn));

        if(!exprType.equals("int"))
            throw new Exception(String.format("Invalid rvalue type at %s:%s -> %s",
                                getToken(n.f5).beginLine, getToken(n.f5).beginColumn, exprType));

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
            throw new Exception(String.format("Condition in if statement must be of type boolean at %s:%s",
                                              getToken(n.f2).beginLine, getToken(n.f2).beginColumn));

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
            throw new Exception(String.format("Condition in while statement must be of type boolean at %s:%s",
                                              getToken(n.f2).beginLine, getToken(n.f2).beginColumn));

        n.f4.accept(this, argu);

        return null;
    }

    // f0 -> "System.out.println"
    // f1 -> "("
    // f2 -> Expression()
    // f3 -> ")"
    // f4 -> ";"
    @Override
    public String visit(PrintStatement n, String argu) throws Exception {
        String type = n.f2.accept(this, argu);
        if(!type.equals("int"))
            throw new Exception(String.format("Print's argument should be of type int at %s:%s",
                                getToken(n.f2).beginLine, getToken(n.f2).beginColumn));
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
            throw new Exception(String.format("Invalid type in (&&) expression at %s:%s -> %s",
                                              getToken(n.f0).beginLine, getToken(n.f0).beginColumn, type1));
        if(!type2.equals("boolean"))
            throw new Exception(String.format("Invalid type in (&&) expression at %s:%s -> %s",
                                              getToken(n.f2).beginLine, getToken(n.f2).beginColumn, type2));

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
            throw new Exception(String.format("Invalid type in (<) expression at %s:%s -> %s",
                                              getToken(n.f0).beginLine, getToken(n.f0).beginColumn, type1));
        if(!type2.equals("int"))
            throw new Exception(String.format("Invalid type in (<) expression at %s:%s -> %s",
                                              getToken(n.f2).beginLine, getToken(n.f2).beginColumn, type2));

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
            throw new Exception(String.format("Invalid type in (+) expression at %s:%s -> %s",
                                              getToken(n.f0).beginLine, getToken(n.f0).beginColumn, type1));
        if(!type2.equals("int"))
            throw new Exception(String.format("Invalid type in (+) expression at %s:%s -> %s",
                                              getToken(n.f2).beginLine, getToken(n.f2).beginColumn, type2));

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
            throw new Exception(String.format("Invalid type in (-) expression at %s:%s -> %s",
                                              getToken(n.f0).beginLine, getToken(n.f0).beginColumn, type1));
        if(!type2.equals("int"))
            throw new Exception(String.format("Invalid type in (-) expression at %s:%s -> %s",
                                              getToken(n.f2).beginLine, getToken(n.f2).beginColumn, type2));

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
            throw new Exception(String.format("Invalid type in (*) expression at %s:%s -> %s",
                                              getToken(n.f0).beginLine, getToken(n.f0).beginColumn, type1));
        if(!type2.equals("int"))
            throw new Exception(String.format("Invalid type in (*) expression at %s:%s -> %s",
                                              getToken(n.f2).beginLine, getToken(n.f2).beginColumn, type2));

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
            throw new Exception(String.format("Invalid type in array lookup expression at %s:%s -> %s",
                                              getToken(n.f0).beginLine, getToken(n.f0).beginColumn, type1));
        if(!type2.equals("int"))
            throw new Exception(String.format("Invalid type in array index at %s:%s -> %s",
                                              getToken(n.f2).beginLine, getToken(n.f2).beginColumn, type2));

        return "int";
    }

    // f0 -> PrimaryExpression()
    // f1 -> "."
    // f2 -> "length"
    @Override
    public String visit(ArrayLength n, String argu) throws Exception {
        String type1 = n.f0.accept(this, argu);
        if(!type1.equals("int[]"))
            throw new Exception(String.format(".length is not supported for type %s at %s:%s", type1,
                                              getToken(n.f0).beginLine, getToken(n.f0).beginColumn));

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
        String lexprType = n.f0.accept(this, argu);
        String id = n.f2.f0.tokenImage;

        ClassInfo classI = symbt.getClass(lexprType);
        if(classI == null){
            throw new Exception(String.format("Method call on invalid type %s at %s:%s",
                                              lexprType, getToken(n.f0).beginLine, getToken(n.f0).beginColumn));
        }


        String[] rexprTypes = n.f4.present() ? n.f4.accept(this, argu).split(",") : new String[0];

        String retType = findMethodRetType(classI, id, rexprTypes);
        if(retType == null){
            String types = String.join(", ", rexprTypes);
            throw new Exception(String.format("No compatible method found at %s:%s -> %s.%s(%s)",
                                getToken(n.f2).beginLine, getToken(n.f2).beginColumn, classI.getName(), id, types));
        }

        // found a comp meth return its type
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
        if((ret = findVarType(n.f0.tokenImage, argu)) != null)
            return ret;

        String classN = getFirstEl(argu);
        String methN = getSecEl(argu);
        int idx = methN.indexOf('_');
        methN = (idx == -1) ? methN : methN.substring(0, idx);
        if(methN.equals("null"))
            throw new Exception(String.format("Undefined identifier %s in %s at %s:%s", n.f0.tokenImage, classN,
                                              getToken(n.f0).beginLine, getToken(n.f0).beginColumn));
        else
            throw new Exception(String.format("Undefined identifier %s in %s.%s at %s:%s", n.f0.tokenImage, classN, methN,
                                              getToken(n.f0).beginLine, getToken(n.f0).beginColumn));
    }


    //   f0 -> ArrayType()
    //       | BooleanType()
    //       | IntegerType()
    //       | Identifier()
    @Override
    public String visit(Type n, String argu) throws Exception {
        // decl id (Type Identifier) has different action from ref id (Identifier)
        if(n.f0.which == 3) // in declaration => should return just the id token and not search for var's (as my Identifier visitor does)
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
            throw new Exception(String.format("Array size must have integral type at %s:%s",
                                getToken(n.f3).beginLine, getToken(n.f3).beginColumn));

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
            throw new Exception(String.format("Class %s isn't defined at %s:%s", className,
                                              getToken(n.f1).beginLine, getToken(n.f1).beginColumn));


        return classI.getName();
    }

    // f0 -> "!"
    // f1 -> Clause()
    @Override
    public String visit(NotExpression n, String argu) throws Exception {
        String type = n.f1.accept(this, argu);
        if(!type.equals("boolean"))
            throw new Exception(String.format("Invalid not expression type at %s:%s -> %s",
                                              getToken(n.f1).beginLine, getToken(n.f1).beginColumn, type));

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
