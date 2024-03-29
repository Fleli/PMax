        
// TopLevelStatement.swift
// Auto-generated by SwiftParse
// See https://github.com/Fleli/SwiftParse

public enum TopLevelStatement: CustomStringConvertible {
	
	case `struct`(Struct)
	case function(Function)
	case `import`(Import)
	case macro(Macro)
	
	public var description: String {
		switch self {
		case .`struct`(let `struct`): return `struct`.description
		case .function(let function): return function.description
		case .`import`(let `import`): return `import`.description
		case .macro(let macro): return macro.description
		}
	}
	
}
