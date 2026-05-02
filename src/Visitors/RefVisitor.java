class RefVisitor extends GJDepthFirst<String, String>{
    private SymbolTable symbt;

    RefVisitor(SymbolTable s){
        symbt = s;
    }
}
