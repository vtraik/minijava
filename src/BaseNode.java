package basenode;

public abstract class BaseNode {
    private Object resolvedPtr;
    private int fieldOffs = 0;

    public Object getResolvedPtr() {
        return this.resolvedPtr;
    }

    public void setResolvedPtr(Object resolvedPtr) {
        this.resolvedPtr = resolvedPtr;
    }

    // for Vars -- needed in codegen
    public int getFieldOffs() {
        return this.fieldOffs;
    }

    public void setFieldOffs(int value) {
        this.fieldOffs = value;
    }
}
