package symboltable;

import java.util.*;

public class MethodInfo {
    private Symbol retId; // return_type + identifier
    private String mangName;
    private boolean isOverridden;
    private int offset;
    List<Symbol> params = new ArrayList<Symbol>();
    Map<String, Symbol> localVars = new HashMap<String, Symbol>();

    public MethodInfo(Symbol retId, String mangName, boolean isOverridden){
        this.retId = retId;
        this.mangName = mangName;
        this.isOverridden = isOverridden;
        this.offset = -1;
    }

    public MethodInfo(Symbol retId){
        this.retId = retId;
        this.mangName = "";
        this.isOverridden = false;
        this.offset = -1;
    }

    public Symbol getRetId(){
        return retId;
    }

    public boolean getOverridden(){
        return isOverridden;
    }

    public Symbol getLocalVar(String name){
        return localVars.containsKey(name) ? localVars.get(name) : null;
    }

    public Symbol resolveBinding(String name){
        if(localVars.containsKey(name)){
            return localVars.get(name);
        }
        int indx;
        return (indx = params.indexOf(new Symbol(name, null))) == -1 ? null : params.get(indx);
    }

    public int getNumParams(){
        return params.size();
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

    public void setOverridden(boolean isOverridden){
        this.isOverridden = isOverridden;
    }

    public void setMangName(String mangName){
        this.mangName = mangName;
    }

    public void addParam(Symbol param) throws Exception {
        if(params.contains(param))
            throw new Exception(String.format("Duplicate parameter %s in method -> %s", param.getName(), retId.getName()));
        params.add(param);
    }

    public void addLocalVar(Symbol var) throws Exception {
        if(localVars.containsKey(var.getName()) || params.contains(var))
            throw new Exception(String.format("Duplicate symbol %s in method scope -> %s", var.getName(), retId.getName()));
        localVars.put(var.getName(), var);
    }
}
