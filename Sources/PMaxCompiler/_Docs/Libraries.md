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

A `.hmax` file contains a list of functions on the following format:

```
RT N (T1 N1, ..., Tn Nn);
@K
L {
    ASM
}
```

As we can see, the first line corresponds to a function signature:
- `RT` is the function's return type
- `N` is its name
- `Ti Ni` refers to the type and name of the i-th parameter (if present)
- We end the signature with a semicolon (`;`)

After the signature comes 

Then, instead of the function's body in PMax, the file contains its body in assembly code.
- First, the `L` is a placeholder for the function's entry label, which must be visible to other functions calling it.
- Then comes the function's assembly code (including entry label) in `ASM`.
- The body is wrapped in `{}`.

Associating each function with its body directly instead of having the whole file's assembly code in one file means the compiler can pick and choose the labels it needs to properly define functions that are used, and discard functions never called. This means a mechanism for transitive reference resolving must be implemented, but this should be doable. The benefit of this approach is that the user can define `void a()` and `void b()` in the same file, and the assembly code for `b` is simply discarded if it is never called. This significantly reduces code size. 

PMax Header Files can also contain `struct` declarations, so that types they define are available externally as well. A struct is declared in PMax Header Files with the exact same syntax as in ordinary PMax source code. They are handled as if they were declared in the file actually being compiled.
