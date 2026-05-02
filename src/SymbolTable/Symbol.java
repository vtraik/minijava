class Symbol {
    private String name;
    private String type;

    Symbol(String name, String type){
        this.name = name;
        this.type = type;
    }

    public String getName(){
        return name;
    }

    public String getType(){
        return type;
    }

    public void setName(String name){
        this.name = name;
    }

    public void setType(String type){
        this.type = type;
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
