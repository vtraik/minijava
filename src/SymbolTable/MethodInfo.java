import java.util.Map;

class MethodInfo {
    private String retType;
    private String name;
    List<Symbol> params = new List<Symbol>();
    Map<String, String> localVars = new HashMap<String, String>();

    public String getRetType(){
        return retType;
    }

    public String getName(){
        return name;
    }

    public List<Symbol> getParams(){
        return params;
    }

    public Map<String, String> getLocalVars(){
        return localVars;
    }

    public void addParam(Symbol param) throws Exception {
        if(params.contains(param))
            throw new Exception(String.format("Duplicate parameter %s in function %s", param.getName(), name));
        params.add(param);
    }

    public void addLocalVar(Symbol var){
        if(localVars.containsKey(var))
            throw new Exception(String.format("Duplicate local variable %s in function %s", var.getName(), name));
        localVars.put(var.getName(), var);
    }
}
