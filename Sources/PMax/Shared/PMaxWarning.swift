enum PMaxWarning: PMaxError {
    
    case assignToVoid(lhs: PILExpression)
    
    var allowed: Bool {
        true
    }
    
    var description: String {
        "[warning]\t" + {
            switch self {
            case .assignToVoid(let lhs):
                return "Assignment to '\(lhs.readableDescription)' of type 'void' has no effect."
            }
        }()
    }
    
}
