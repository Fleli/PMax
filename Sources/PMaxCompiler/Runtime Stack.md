#  Runtime Stack


 data           | function      |
----------------|---------------|
 ...            | ...           |
 local 2        | `Q`           |
 local 1        | `Q`           |
 param M        | `Q`           |
 ...            |  ...          |
 param 1        | `Q`           |
 frame pointer  | `Q`           |
 return address | `Q`           |
 return value   | `Q`           |
 local N        | `P`           |
 local N - 1    | `P`           |

The return address specified as part of `Q` refers to the location where the next statement in `P` is located.

Storing the return value immediately after local `N - 1` from the previous function means that it will be ready as if it were a local variable when we return. This fits the call convention in TAC, where we assign the return value of a call to a local (intermediate) variable.

In order to correctly place parameters on the stack, we need some information about how they are placed relative to the old frame pointer. Sinde the frame pointer offset for the return value is known (we declare that variable as we lower function calls to TAC), this information is known at compile-time. The first parameter should be placed at the current location: The offset of the return value + the size of the returned type + 2 (1 for the return address and 1 for the frame pointer).
