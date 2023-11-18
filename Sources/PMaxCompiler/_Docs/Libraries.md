#  Libraries

For a programming language to be useful, it must provide a mechanism for spreading the input across multiple files and importing the necessary functionality in files where it is used. Most languages use either an `import` or `#include` statement to expose this funcitonality to the programmer.

## Introduction to PMax's Libary Model

In PMax, libraries are exposes through _import statements_.

```
import Library;
```

Here, `Library` represents an arbitrary library that the compiler has access to. The compiler will search through its current working directory (the directory of the file it is compiling) to find a file named `Library.hmax`, a _PMax Header File_. The PMax Header File contains function signatures that are visible to external source files. It also contains their corresponding assembly code entry points. For example, a `stdlib.hmax` file may include a method with the signature `void array_insert(Array*, void* element)`, its entry label and assembly code. That way, callers to `array_insert` can check that their arguments match what is expected and insert call statements referring to it, without ever seeing its function body.

When compilation is finished and we want to assemble the executable, we simply paste each function's corresponding assembly code into a large file, and assemble the whole program together. In other words, we statically link all files.

**Note:** Statically linking libraries such as the standard library may be an issue in terms of code size. All programs use `alloc` and similar functions, so it would be preferable if they could share memory. However, our breadboard computer most likely won't be used for multitasking with 10 applications running simultaneously, so adding such functionality is _not_ a priority.

## The PMax Header File (`.hmax`) Format

A `.hmax` file contains is PMax-parsable, so it uses the exact same lexer, parser and tree converter as the main compiler. However, it would be semantically meaningless to a compiler.

Just like a `.pmax` file, the `.hmax` files' top levels contain function and struct declarations. For it to be valid, the function's first statement must be a declaration on the form `Label l;`, where `l` is a placeholder for the function's entry label. After this, the preprocessor expects an assignment on the form `assign asm = str` where `str` is a placeholder for a string (wrapped in `"`) that contains the full assembly code for the function.
