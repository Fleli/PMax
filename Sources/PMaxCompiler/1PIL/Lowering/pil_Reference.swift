extension Reference {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> PILOperation {
        let nesting = flattenReference()
        return .reference(nesting)
    }
    
    func flattenReference() -> [String] {
        
        switch self {
        case .identifier(let id):
            return [id]
        case .member(let reference, _, let member):
            return reference.flattenReference() + [member]
        }
        
    }
    
}
