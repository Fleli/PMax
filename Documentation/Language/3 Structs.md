#  Structs

A `struct` (structure) is a collection of data types. For example, a three-dimensional `Point` could be defined using a `struct`:

```
struct Point {
    var x: int;
    var y: int;
    var z: int;
}
``` 

The type `Point` is now available across the whole program. Members can be accessed through a `.`.

```
func getOrigin() -> Point {
    
    var p: Point;
    
    p.x = 0;
    p.y = 0;
    p.z = 0;
    
    return p;
    
}
```

If a variable is a pointer to a struct, e.g. `p: P*`, a dereference-and-access-member operation can be combined into one with a C-style arrow.

```
var p: P* = ...;
p->x = 5;  // Equivalent to (*p).x = 5;
``` 
