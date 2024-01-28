#  Calling Convention

For now, PMax is *not* designed to interoperate with code generated from other languages. This is because PMax is a specialized language designed specifically with Hackerspace NTNU's breadboard computer in mind.

Because interoperability has not been a goal, PMax's calling convention is not influenced by other lanugages. Instead, the convention aims to provide good performance for our breadboard computer, while being fairly easy to understand.

## The Stack Frame

First, we'll look at the stack frame structure for a function `T X(t1 a1, ..., tn an)`. In other words, we'll look at a function with `n` parameters `ak` (`1 <= k <= n`), each of type `tk`, and a return value of type `T`. Also, we assume that `r` local variables `u1 l1, ..., ur lr`, each of type `uk` (for `1 <= k <= r`) and with name `lk`, at the time of this "snapshot".

When the function has just been called (control is transferred to `X`), the stack frame looks like this:

contents            |   size            |   Explanation                                                                 |
--------------------|-------------------|-------------------------------------------------------------------------------|
local *r* (`lr`)    |   `sizeof(ur)`    |   The *r*-th local variable defined (at this time).                           |
...                 |   ...             |   ...                                                                         |
local 1 (`l1`)      |   `sizeof(u1)`    |   The first local variable defined.                                           |
param *n* (`an`)    |   `sizeof(tn)`    |   The function's *n*-th parameter.                                            |
...                 |   ...             |   ...                                                                         |
param 1 (`a1`)      |   `sizeof(t1)`    |   The function's first parameter                                              |
frame pointer       |   1               |   Points to the previous frame pointer (together, these form a linked list)   |
return address      |   1               |   The address where the caller will resume operation at return                |
return value        |   `sizeof(T)`     |   The return value will be stored here when the function returns              |

### Return Value

When a statement like `return x;` is executed, the value `x` (which is either a parameter or a local variable) is copied to the return value space. This value is the only value that the caller gets access to when the function returns. This mechanism is explained in further detail later.

### Return Address

Let `A` and `B` be two functions. In label `L_A`, `A` calls function `B` by jumping to label `L_B`. When `B` returns, it is instructed to jump to `L_A_continue`. Then, the return address in `B`'s stack frame is the address where `L_A_continue` starts. The sequence is as follows:
1. Code is executed in function `A`.
2. In `L_A`, which belongs to function `A`, a call statement to function `B` is encountered. This call statement contains two pieces of information:
    - Where execution of `B` begins (`L_B`)
    - Where `B` should jump at return (`L_A_continue`)
3. After `B` has been called (the stack frame has been set up), all of B's code executes.
4. When `B` returns, it jumps to `L_A_continue`, and control has been transferred back to `A`.

### Frame Pointer

The frame pointer is used as a reference for all variables stored in a stack frame. Whenever we wish to read or write a variable, we write to an offset from the current frame pointer.

The register `r7` always holds the _local frame pointer_. Assume that a function `A` calls a function `B`. Then, a pointer to `B`'s frame is stored in `r7`. By `B`'s frame we mean all addresses (inclusive) from the return value space of `B` to the parameter of `B`. The single address that represents `B`'s frame is actually the address just before the first parameter, that holds another frame pointer. This other frame pointer is actually `A`'s frame pointer, which points to `A`'s frame.

When a parameter of `B` is accessed, we calculate an offset from `r7`. For example, the address of the first parameter is `r7 + 1`. Note that `r7 + 0`, or just `r7`, is considered the address of `B`'s frame, and the value stored at this address is the address of `A`'s frame. When `B` returns, this value is put into `r7`, so that `r7 + 1` then means `A`'s first parameter.

## Initializing a Stack Frame

Assume that we have two functions `a` and `b` defined as such:

```
int a() {
    int k;
    assign k = b();
    return k;
}

int b() {
    int m;
    assign m = 7;
    return m;
}
```

Before `b()` is called, a variable `$1_call_b_retvalue` is generated at the top of the frame, so `a`'s stack frame looks like this:

contents            |   size                |   Explanation                                                                 |
--------------------|-----------------------|-------------------------------------------------------------------------------|
`$1_call_b_retvalue`|   `sizeof(int) = 1`   |   A compiler-generated local variable that will hold the result of `b()`      |
`k`                 |   `sizeof(int) = 1`   |   The local variable `int k`.                                                 |
frame pointer       |   1                   |   Points to the previous frame pointer (together, these form a linked list)   |
return address      |   1                   |   The address where the caller will resume operation at return                |
return value        |   `sizeof(int) = 1`   |   The return value will be stored here when the function returns              |

**Note:**
The address (or addresses in the case of return types larger than `int`) at the top of the frame are shared between `$1_call_b_retvalue` (in function `a`) and the _return value_ space in function `b` when it is called. Thus, when `b` returns and puts its return value in these addresses, they will become available to `a` through the variable `$1_call_b_retvalue`. Then, the compiler inserts the statement `assign k = $1_call_b_retvalue;` to actually assign the value to `k` as specified by the programmer.

Since the addresses holding `b`'s return value will be written to later, nothing needs to be done yet. There are 4 steps that _do_ need to be performed for the function call to be correct:
1. In the memory address just after that of _return value_ (from `b`'s perspective) (or `$1_call_b_retvalue` from `a`'s perspective), `b` expects a return address. When `a` calls `b`, `a` puts the address of the continuing label here. `a` knows the address of this label at assemble-time (see [the assembler](https://github.com/Fleli/bbasm) for more information), so at runtime this just involves putting an immediate value there.
2. In the memory address after that again, we put the current frame pointer value. In other words, we store `r7` (`fp`) at that address. We then store that address in `r7`, so that all variable references (offset calculations) are done relative to function `b`, not `a`.
3. Then, we push any relevant parameters. In this case, no such parameters exist. But if they did, we would simply copy each parameter to their offset relative to the new frame pointer (`fp + 1` for the 1st parameter, etc.)
4. Finally, we begin executing function `b` by jumping to its entry point (this address is known at assemble-time).
