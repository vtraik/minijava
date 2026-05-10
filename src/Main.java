import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import syntaxtree.*;
import visitor.*;
import lexer_parser.*;
import symboltable.*;

public class Main {
    public static void main(String[] args) throws Exception {
        if(args.length != 1){
            System.err.println("Usage: java Main <File1> <File2> ... <FileN>");
            System.exit(1);
        }

        FileInputStream fis = null;
        for(int i = 0; i < args.length; ++i){
            try{
                fis = new FileInputStream(args[i]);
                MiniJavaParser parser = new MiniJavaParser(fis);

                Goal root = parser.Goal();

                System.out.println("Program parsed successfully.");
                SymbolTable st = new SymbolTable();

                // first pass: find declerations and populate symbol table
                DeclVisitor decl = new DeclVisitor(st);
                root.accept(decl, null);

                // second pass: type check references
                RefVisitor ref = new RefVisitor(st);
                root.accept(ref, null);

                System.out.println("Program is semantically correct.");

                // print offsets
                st.printOffsets(1);
            }
            catch(Exception ex){
                System.err.println("Error: " + ex.getMessage());
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
