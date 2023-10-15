extension PILOperation {
    
    func synthesizeType(_ lowerer: PILLowerer) -> PILType {
        
        switch self {
        case .unary(let `operator`, let arg):
            
            guard arg.type.allowedInArithmetic() else {
                lowerer.submitError(.unaryOperatorNotDefined(op: `operator`.rawValue, argType: arg.type))
                return .error
            }
            
            return .int
            
        case .binary(let `operator`, let arg1, let arg2):
            
            guard arg1.type.allowedInArithmetic(), arg2.type.allowedInArithmetic() else {
                lowerer.submitError(.binaryOperatorNotDefined(op: `operator`.rawValue, arg1Type: arg1.type, arg2Type: arg2.type))
                return .error
            }
            
            return .int
            
        case .call(let pILCall):
            
            let funcType = lowerer.functionType(pILCall.name)
            
            if funcType == .error {
                lowerer.submitError(.functionDoesNotExist(name: pILCall.name))
            }
            
            return funcType
            
        case .variable(let variable):
            
            guard let type = lowerer.local.getVariable(variable) else {
                lowerer.submitError(.variableIsNotDeclared(name: variable))
                return .error
            }
            
            return type
            
        case .dereference(let expression):
            
            switch expression.type {
            case .int, .void, .struct(_):
                lowerer.submitError(.dereferenceNonPointerType(type: expression.type))
                fallthrough
            case .error:
                return .error
            case .pointer(let pointee):
                return pointee
            }
            
        case .addressOf(let expression):
            
            if case .error = expression.type {
                return .error
            }
            
            return .pointer(pointee: expression.type)
            
        case .member(let main, let member):
            
            return lowerer.fieldType(member, of: main.type)
            
        }
        
    }
    
}
