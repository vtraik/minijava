# minijava
- Tools : JFlex, JavaCUP and JTB.
- Dependencies : >= clang with LLVM IR 15 (opaque ptrs used)
- Tests from: [minijava-testsuite](https://github.com/baziotis/minijava-testsuite). And some new ones.

## Compilation, Run, Cleanup
```bash
# make proj
make

# run
java -cp bin [MainClassName] [file1] [file2] ... [fileN]

# clean
make clean
```
## Documentation

- 🌍 [Language Specification](langspec.md)
- 📖 [Grammar](grammar)

## Implementation

### Compilation Phases

AST is produced by JFlex, JavaCUP and JTB.
Four visitors are implemented that do:
- `DeclVisitor`: Populates symbol table with declerations and checks for overriding/overloading errors.
- `RefVisitor`: Type checks the program.
- `VTableVisitor`: Populates the vtable.
- `CodeGenVisitor`: Generates llvm ir.

> [!NOTE]
> 1. "ClassName|MethodName\_argtype1_\argtype2\_..." is used as a scope mechanism. It gets passed as argument to 
> the children nodes as the visitors walk the AST.
> 2. LLVM-IR virtual registers follow the naming convention : `%r<number>` where `<number>` is an incrementing integer.
> 3. BaseNode is used to store in the AST the resolved MethodInfo references and variable field offsets so it is not needed to
> search my data structures again in code-gen phase.
