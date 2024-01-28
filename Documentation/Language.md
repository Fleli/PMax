#  Language

The PMax programming language shares a lot of syntax and semantics with C. Some key similarities include:
- The `int` type being built in to the language
- Allowing the user to define _structs_ that group data together
- The widespread use of pointers for dynamic memory management
- The language is statically typed, but its typing system is weak and obeys the programmer's type casts

Below follows a top-down description of the language. When a word (like `Args` or `Name`) starts with an uppercase letter, it is to be considered a placeholder for an actual value, for example `abc` in the place of `Name`. Words that begin with lowercase letters, like `if` or `assign`, are PMax keywords and must be found in their exact form. Special tokens like `(` and `;` are also treated this way, and are _not_ placeholders.

## Top Down

The compiler deals with `.pmax` source code files. From the grammar (see `Sources/PMaxCompiler/0Frontend/PMaxGrammar`), it is apparent that such files allow two kinds of top-level statements:
- Function declarations, on the form `Type Name ( Args ) { Body }`
- Structure (`struct`) declarations, on the form `struct name { body }`

No other statements are allowed at the top level. This will change in the future, however, as `import` statements will become available.

### Functions

A function contains a list of statements in its body. Any one statement falls into one of these categories:
- Declarations, on the form `Type Name;` or `Type Name = Expression;`
- Assignments, on the form `assign Expression = Expression;`<sup>1</sup>
- Call statements, on the form `call Name ( Args );`
- If statements, on the form `if Expression { Body }`, optionally followed by the `else` keyword and another `if` statement.
- While statements, on the form `while Expression { Body }`

Note the `assign` and `call` keywords, which aren't usually found in other languages. These are required because the parser is somewhat underpowered and does not manage to distinguish between statement types if a special keyword isn't used to clarify. The plan is to upgrade the parser significantly in the coming months since this restriction greatly damages the ergonomics of the language.

<sup>1</sup> The left-hand side Expression of an assignment must be an _LValue_ expression. This essentially just means that it must be assignable. For example, you cannot assign a value to the integer literal `4`, so statements like `assign 4 = 5;` will produce an error. LValue Expressions are either variables, member (or follow-pointer) references, or pointer dereferences. 

### Structures

A `struct` is a collection of data packaged tightly. To define a struct, use the `struct` keyword followed by its name, and its body enclosed in `{` and `}`. Its body can only contain declarations, and does not allowd default values on those declarations (in other words, `int x = 5;` is disallowed in structs).

Structure members can be referred to by the dot (`.`) notation, or indirectly (through a pointer) with the arrow (`->`) notation:

```
// Declare the structure Point as a collection of two ints a and b.
struct Point {
    int x;
    int y;
}

// Declare the point a
Point a;

// Declare the pointer-to-point b. A point is of size 2 (since it contains 2 ints), so we allocate two words for it.
Point* b = malloc(2);

// Set the x coordinate of a to 5.
assign a.x = 5;

// Set the x coordinate of the Point pointed to by b to 5.
assign b->x = 5;
```

### Expressions

Expressions appear everywhere throughout the language. Expressions are defined inductively, with the base cases being:
- integer literals
- identifiers
- function calls (without the `call` prefix)

In addition, an Expression is
- The address-of an Expression, `&E`
- Dereferencing an expression, `*E`
- Type-casting an expression, `(as T) (E)`<sup>2</sup>
- An parenthesized expression, `(E)`

Also, several operators can be applied to expressions to form new ones. Operators have certain relative precedences. For an updated list of precedences, please refer to the grammatical description in the `0Frontend` folder, where they are named `CASEXExpression` where an `X` later in the alphabet means higher precedence. Operators include `+`, `&`, `->`, `<<` and many more.

<sup>2</sup>Note the parentheses around `E` and the `as` keyword in front of the new type `T`. Again, these restrictions are the consequences of an underpowered parser and will be fixed.
