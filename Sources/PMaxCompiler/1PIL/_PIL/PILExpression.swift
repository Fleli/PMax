/// A `PILExpression` is essentially a wrapper around a modified syntactical `Expression` node.
/// Each `PILExpression` node contains a `type: PILType` field that is synthesized from its children.
/// Like Java and C++ (but unlike Swift), the `type` field in `PILExpression` nodes does _not_ support inheritance (only synthesis).
class PILExpression {
    
    var type: PILType
    var value: PILOperation
    
    init(_ value: PILOperation) {
        self.type = value.synthesizeType()
        self.value = value
    }
    
}