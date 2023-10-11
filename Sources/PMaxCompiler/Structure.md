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

First, we simply prepare an array of _functions_, (later) _structs_ and (later) _operator declarations_.

### The `PILType` enumeration.

Raw syntactic types are converted to corresponding `PILType` instances. `.struct` instances have an associated type `name: String`. When building `PILType`s, we do _not_ have full knowledge about existing structs. Thus, any `PILType.struct` assumes that the associated `name` refers to an existing struct. The existence of this struct is checked later on.

### PMax Intermediate Language (PIL) lowering

As part of PIL Function initialization, function bodies are lowered into their corresponding PIL. This includes annotating all expressions with types, either fetched directly from variables or inferred from expressions. 

Inferring types from expressions requires clear knowledge about operators (and their input- and output types). Thus, we must search through operator declarations before lowering to PIL. In the compiler's first version, operator declarations are not allowed. Therefore, this step is ignored in the first deployment.

### PIL Statements

PIL is _not_ built around protocol conformance, but rather as `enum` statements. Each type of `PIL` statement is its own case, with an associated value pointing to the actual statement (so the `.while` case points to a `PILWhile` statement).


