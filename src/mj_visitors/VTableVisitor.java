import syntaxtree.*;
import visitor.GJDepthFirst;
import symboltable.*;
import vtable.*;

public class VTableVisitor extends GJDepthFirst<String, String> {
    private VTable vtable;
    private SymbolTable symbt;
    private int methNum = 0;

    public VTableVisitor(SymbolTable symbt, VTable vtable) {
        this.symbt = symbt;
        this.vtable = vtable;
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
        String className = n.f1.f0.tokenImage;
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
        String className = n.f1.f0.tokenImage;
        String superName = n.f3.f0.tokenImage;

        vtable.addClass(className);

        // copy superclass vtable first
        for (Info method : vtable.getMethods(superName))
            vtable.addMethod(className, method.getMethod(), method.getDefClass());

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
        String className = argu;
        MethodInfo methI = symbt.getNumMeth(methNum++);
        vtable.addMethod(className, methI, className);

        return null;
    }
}
