class Symbol {
    private String name;
    private String type;
    private int offset;

    Symbol(String name, String type){
        this.name = name;
        this.type = type;
        this.offset = -1;
    }

    public String getName(){
        return name;
    }

    public String getType(){
        return type;
    }

    public int getOffset(){
        return offset;
    }

    public void setName(String name){
        this.name = name;
    }

    public void setType(String type){
        this.type = type;
    }

    public void setOffset(int offset){
        this.offset = offset;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof Symbol)) return false;

        Symbol other = (Symbol) obj;
        return Objects.equals(this.name, other.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name);
    }
}
