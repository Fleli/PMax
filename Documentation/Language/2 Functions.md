#  Functions

A function is declared with the syntax

```
func FunctionName ( Parameters ) -> ReturnType {
    FunctionBody
}
```

The `-> ReturnType` part may be omitted if the function's return type is `void`.

Parameters are on the form `Name: Type`, and are comma-separated when there are more than one. 

The `FunctionBody` is a list of statements. If the return-type is non-`void`, the function must return a value of that type on all paths.

An example of a `void` function is the standard library's print implementation. It makes use of macros and type casts, which may seem unfamiliar at this moment. The point is to show the function's structure.

```
func print(str: char*) {
    
    // Store the trap's argument
    * [char**] (TRAPFRAMEADDRESS + 1) = str;
    
    // Request a trap
    * [int*] TRAPFRAMEADDRESS = 1;
    
}
```

Another example, with a return type, is an (inefficient) implementation of a function to find Fibonacci numbers:

```
func fibonacci(n: int) -> int {
    
    if n < 3 {
        return 1;
    }
    
    return fibonacci(n - 1) + fibonacci(n - 2);
    
}
```
