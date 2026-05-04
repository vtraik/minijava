import java.util.Map;

class MethodInfo {
    private Symbol retId; // return_type + identifier
    private String mangName;
    private boolean isOverridden;
    private int offset;
    List<Symbol> params = new ArrayList<Symbol>();
    Map<String, Symbol> localVars = new HashMap<String, Symbol>();

    MethodInfo(Symbol retId, String mangName, boolean isOverridden){
        this.retId = retId;
        this.mangName = mangName;
        this.isOverridden = isOverridden;
        this.offset = -1;
    }

    public Symbol getRetId(){
        return retId;
    }

    public boolean getOverridden(){
        return isOverridden;
    }

    public Symbol getParam(String name){
        int indx = params.IndexOf(name);
        return indx != -1 ? params.get(indx) : null;
    }

    public Symbol getLocalVar(String name){
        return localVars.containsKey(name) ? localVars.get(name) : null;
    }

    public int getNumParams(){
        return params.length;
    }

    public List<Symbol> getParams(){
        return params;
    }

    public Map<String, Symbol> getLocalVars(){
        return localVars;
    }

    public int getOffset(){
        return offset;
    }

    public String getMangName(){
        return mangName;
    }

    public void setOffset(int offset){
        this.offset = offset;
    }

    public void addParam(Symbol param) throws Exception {
        if(params.contains(param))
            throw new Exception(String.format("Duplicate parameter %s in function %s", param.getName(), name));
        params.add(param);
    }

    public void addLocalVar(Symbol var) throws Exception {
        if(localVars.containsKey(var))
            throw new Exception(String.format("Duplicate local variable %s in function %s", var.getName(), name));
        localVars.put(var.getName(), var);
    }
}
