package basenode;

// keeps resolved MethodInfo and var symbols in AST (also field offs) to prevent
// searching for them again in codegen phase
public abstract class BaseNode {
    private Object resolvedPtr;
    private int fieldOffs = 0;

    public Object getResolvedPtr() {
        return this.resolvedPtr;
    }

    public void setResolvedPtr(Object resolvedPtr) {
        this.resolvedPtr = resolvedPtr;
    }

    public int getFieldOffs() {
        return this.fieldOffs;
    }

    public void setFieldOffs(int value) {
        this.fieldOffs = value;
    }
}
