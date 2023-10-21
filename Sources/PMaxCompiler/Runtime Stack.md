#  Runtime Stack


 data           | function      |
----------------|---------------|
 ...            | ...           |
 local 2        | `Q`           |
 local 1        | `Q`           |
 param M        | `Q`           |
 ...            | `Q`           |
 param 1        | `Q`           |
 frame pointer  | `Q`           |
 return address | `Q`           |
 return value   | `Q`           |
 local N        | `P`           |
 local N - 1    | `P`           |

The return address specified as part of `Q` refers to the location where the next statement in `P` is located.

Storing the return value immediately after local `N - 1` from the previous function means that it will be ready as if it were a local variable when we return. This fits the call convention in TAC, where we assign the return value of a call to a local (intermediate) variable.
