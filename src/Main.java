import java.io.*;
import syntaxtree.*;
import visitor.*;
import lexer_parser.*;
import symboltable.*;
import vtable.*;

public class Main {
    public static void main(String[] args) throws Exception {
        if(args.length < 1) {
            System.err.println("Usage: java Main <File1> <File2> ... <FileN>");
            System.exit(1);
        }

        FileInputStream fis = null;
        FileWriter fwriter = null;
        SymbolTable symbt = null;
        VTable vtable = null;
        Goal root = null;
        for(String file : args) {
            try {
                System.out.println();

                fis = new FileInputStream(file);
                root = new MiniJavaParser(fis).Goal();

                System.out.println("Program parsed successfully.");
                symbt = new SymbolTable();
                vtable = new VTable();

                // first pass: find declerations and populate symbol table
                root.accept(new DeclVisitor(symbt), null);
                // second pass: type check references
                root.accept(new RefVisitor(symbt), null);

                System.out.println("Program is semantically correct.");

                fwriter = new FileWriter(file.substring(0, file.lastIndexOf('.')) + ".ll");

                // third pass: populate vtable
                root.accept(new VTableVisitor(symbt, vtable), null);
                // fourth pass: generate llvm ir
                root.accept(new CodeGenVisitor(symbt, vtable, fwriter), null);

                // print offsets -> 1: + param types, 0: default
                // symbt.printOffsets(1);

                System.out.println();
            }
            catch(Exception ex) {
                System.err.println("Error: " + ex.getMessage());
            }
            finally {
                try {
                    if(fis != null) fis.close();
                    if(fwriter != null) fwriter.close();
                    fis = null; fwriter = null; symbt = null; vtable = null; root = null;
                }
                catch(IOException ex) {
                    System.err.println(ex.getMessage());
                }
            }
        }
    }
}
