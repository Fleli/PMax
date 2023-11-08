## Compiler

The compiler is a large and complex system, so it is best explained section by section. However, a short summary is provided here.
- The compiler receives _source code_ written by the programmer. This is a `String`. It is turned into an array of `Token` instances by the _lexer_. Each `Token` represents a lexical "word", for instance `int`, `512` or `x` in the source code. It also contains a _type_ that is used to distinguish control symbols (e.g. `{`) from integer literals (`integer`).
- The array of tokens is _parsed_ by an SLR parser. This results in a tree that conveys the structure of the input. In other words, the linear `[Token]` is now converted into a _tree_ that explicitly expresses nesting. Each node in the tree is an `SLRNode` instance. An `SLRNode` can have an arbitrary number of child `SLRNode`s. It also has a `String` that describes its _type_ (for example `Assignment`, `Expression` or `Function`).
- The tree of `SLRNode` objects is converted into another tree of designated classes for each type. Now, the `Assignment` node from the parsing stage is stored in its own `Assignment` class, with fields `lhs: Expression` and `rhs: Expression` (`Expression` is an `enum` with cases for unary and binary expressions, pure variable references and so on). This is much easier to work with for later stages of the compiler that an unspecialized `SLRNode` tree.
- The tree of designated objects, for example `Assignment` and `While`, is then lowered to the _PMax Intermediate Language_, shortened to _PIL_. PIL type-checks all expressions and synthesizes types from subexpressions where inference is needed. It also generates memory layouts for struct types. In addition, PIL verifies the existence of variables where they are used. PIL emits an intermediate representation similar to what it received from the previous step, but (type) annotated, verified and some meta information.
- After receiving a well-typed and (probably) meaningful program from PIL, we wish to remove the tree structure so that the program becomes closer to the machine. The flat structure we wish to convert to is called _Three-Address Code_ (TAC), because it deals with at most three addresses (operands) per statement. The TAC lowerer walks the PIL tree in order to flatten it. It also submits errors for some semantic issues in the code, like assigning an unassignable expression (e.g. `a + b`). The TAC stage outputs a number of _labels_, each containing a linear list of TAC Statements.
- The last stage is lowering to (breadboard) assembly. Lowering to assembly code involves translating each TAC statement into its corresponding list of assembly instructions. There is a quite direct mapping between the two. The result from this stage is a `String` that can be assembled by an assembler to create a binary.