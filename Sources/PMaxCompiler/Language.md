#  Language

PMax will in many ways be similar to C. The programmer must perform manual memory management, pointers are exposed as a core concept, and classes must be built by using pointer-to-struct.

## Statements

### Declarations

```
type name;
type name = value;
```

Declarations always contain a type and a value. They may (except for in structs) also include a default value.

### Assignments

```
assign lhs = rhs;
assign lhs @O = rhs;
```

Assignments begin with the `assign` keyword (will hopefully be removed once SwiftSLR becomes powerful enough). They use expressions on both the left- and right-hand side.

Assignments can (optionally) be sugared to perform an operation on the left-hand side and the right-hand side, and write the result to the left-hand side. This is similar to `x += y` in other languages. However, due to SwiftSLR being weak, we must include the `@` symbol before the sugared operator. This will hopefully change once SwiftSLR is upgraded (it needs to make better use of its lookahead).

### Returns

```
return;
return value;
```

A `return` statement exits a function, optionally returning a value. All functions are required to have a return statement on all paths (in other words, functions must be explicitly exited). This also applies to `void` functions (they just use the `return;` variant). This requirement may change in future versions.

### ...

## Types

The type system in PMax is built around two built-in base types:
- `int`
- `void`

In addition, there is explicit compiler support for
- _pointers_ to any type `T`, `T*`
- _structs_ that group together types `T1, ..., Tn` declared with the `struct` keyword.

Arithmetic operators such as `+` and `%` are only allowed on the built-in type `int`. However, the compiler implicitly converts all pointer types to `int` if they are used in arithmetic operations. It also allows `int` to be assigned to any pointer type.

Note however that `T*`-to-`U*` conversions are _not_ allowed for `T != U`.

Also, attempting to _assign_ a pointer to an `int` will yield an error (but _not_ vice versa).
