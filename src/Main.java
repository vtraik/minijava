import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import syntaxtree.*;

public class Main {
    public static void main(String[] args) throws Exception {
        if(args.length != 1){
            System.err.println("Usage: java Main <File1> <File2> ... <FileN>");
            System.exit(1);
        }

        FileInputStream fis = null;
        for(int i = 0; i < args.length; ++i){
            SymbolTable st = new SymbolTable();
            try{
                fis = new FileInputStream(args[0]);
                MiniJavaParser parser = new MiniJavaParser(fis);

                Goal root = parser.Goal();

                System.err.println("Program parsed successfully.");

                // first pass: find declerations and populate symbol table
                DeclVisitor decl = new DeclVisitor(st);
                root.accept(decl, null);

                // second pass: type check references
                RefVisitor ref = new RefVisitor(st);
                root.accept(ref, null);

                // print offsets
                st.printOffsets();
            }
            catch(ParseException ex){
                System.out.println(ex.getMessage());
            }
            catch(FileNotFoundException ex){
                System.err.println(ex.getMessage());
            }
            finally{
                try{
                    if(fis != null) fis.close();
                }
                catch(IOException ex){
                    System.err.println(ex.getMessage());
                }
            }
        }
    }
}
