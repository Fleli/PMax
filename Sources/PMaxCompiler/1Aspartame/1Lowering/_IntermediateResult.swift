
/// Use this `struct` whenever lowering does not _just_ produce `AspartameStatement`s, but we also need to keep track of a result variable. Useful for `Reference` and `Expression` lowering,
struct IntermediateResult {
    
    /// For multi-stage computation, the caller is usually just interested in where to find the result. The `resultName` field is a `String` that the caller can use to reference the result of the computation or search. When lowering is completed, these represent completely normal variables, but inserted by the compiler. Therefore, they must also have a corresponding `AspartameStatement.declaration` within `statements`. Note that these variables use special naming inaccessible to the programmer to avoid name conflicts.
    let resultName: String
    
    /// The statements produced by lowering.
    let statements: [AspartameStatement]
    
}
