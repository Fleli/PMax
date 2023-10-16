#  Structure

## TODO

Consider moving function calls to the `Expression` root instead of in `Reference`: Nested calls are not supported by this language since functions cannot return functions.

Assignments must have a reference as their `lhs` (not a `String`). This is because we need to access struct members to assign their properties.

## Syntactic Frontend

The _syntactic frontend_ of the compiler takes a `String`, lexes into `[Token]`, parses into `SLRNode` and converts to `TopLevelStatements`.

## Semantic Frontend

**Note: Consider auto-inserting type casting for literals.**

### Literals

While lowering from syntactic statements to PIL, each reference to literals notify the lowerer's `LiteralPool` instance. The literal pool includes all literals in the program and makes them accessible as global variables. References to them are then replaced by an identifier that refers to that variable. Each such variable has a specific type. This type is decided by running through the program before lowering to decide which type a literal is automatically stored as.

### Preparation

First, we simply prepare an array of _functions_ (`PILFunction`) and _structs_ (`PILStruct`). Then, we start lowering each statement in every function's body to PIL (see below).

### PMax Intermediate Language (PIL) lowering

After all `PILFunction` instances have been initialized, function bodies are lowered into their corresponding PIL. This includes annotating all expressions with types, either fetched directly from variables or inferred from expressions (see `synthesizeTypes.swift`). 

After lowering the body of a function, that function has the responsibility to check that a value is returned on all paths (and that this value is of the right type). To accomplish this, the function calls `returnsOnAllPaths(_:_:)` on each statement in the body. See `__PILFunction.swift`, `_PILStatement.swift` and `PILIfStatement.swift` for more. 

**Note: The current framework actually allows for dead code analysis as well. Consider adding this in a future version to emit warnings.**

### The `PILType` enumeration.

Raw syntactic types are converted to corresponding `PILType` instances. `.struct` instances have an associated value `name: String`. When building `PILType`s, we do _not_ have full knowledge about existing structs. Thus, any `PILType.struct` assumes that the associated `name` refers to an existing struct. The existence of this struct is verified later on (except for attempted member acccess, which forces the compiler to look for the struct being accessed).

### PIL Statements

PIL is _not_ built around protocol conformance, but rather as `enum` cases. Each type of `PIL` statement is its own case with a number of associated values. Some statements, like `if`, are so complex that they are stored as seperate classes that are pointed to in the case's associated value. Others, like declarations, simply store the declaraed variable's type and name as associated values.
