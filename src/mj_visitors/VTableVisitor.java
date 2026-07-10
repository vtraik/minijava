import syntaxtree.*;
import visitor.GJDepthFirst;
import symbol_table.*;
import vtable.*;

public class VTableVisitor extends GJDepthFirst<String, String> {
    private VTable vtable;
    private SymbolTable symbt;

    public VTableVisitor(VTableVisitor vtable, SymbolTable symbt) {
        this.vtable = vtable;
        this.symbt = symbt;
    }

    private String getFirstEl(String scope){
        int indx = scope.indexOf('|');
        return scope.substring(0, indx);
    }

    private String getSecEl(String scope){
        int indx = scope.indexOf('|');
        return scope.substring(indx + 1);
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
    public String visit(MainClass n, String argu) throws Exception {
        String className = n.f1.accept(this, null);
        vtable.addClass(className);
        return null;
   }

    // f0 -> "class"
    // f1 -> Identifier()
    // f2 -> "{"
    // f3 -> ( VarDeclaration() )*
    // f4 -> ( MethodDeclaration() )*
    // f5 -> "}"
    public String visit(ClassDeclaration n, String argu) throws Exception {
        String className = n.f1.accept(this, null);
        vtable.addClass(className);
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
    public String visit(ClassExtendsDeclaration n, String argu) throws Exception {
        String className = n.f1.accept(this, null);
        String superName = n.f3.accept(this, null);

        vtable.addClass(className);

        // copy superclass vtable first
        for (MethodInfo method : vtable.getMethods(superName))
            vtable.addMethod(className, method, method.getDefClass());

        n.f6.accept(this, className);

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
    public String visit(MethodDeclaration n, String argu) throws Exception {
        // type1|id1,type2|id2,...
        String[] args = n.f4.present() ? n.f4.accept(this, null).split(",") : new String[0];

        String methName = n.f2.accept(this, null);
        String mangName = new String(methName);
        String className = argu;

        for(int i = 0; i < args.length; ++i){
            String ptype = getFirstEl(args[i]);
            mangName += "_" + ptype;
        }
        MethodInfo methI = symbt.getClass(className).getMethodMang(mangName);
        vtable.addMethod(className, methI, className);
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

}
