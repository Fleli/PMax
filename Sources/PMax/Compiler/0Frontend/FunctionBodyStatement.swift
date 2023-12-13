        
// FunctionBodyStatement.swift
// Auto-generated by SwiftParse
// See https://github.com/Fleli/SwiftParse

public enum FunctionBodyStatement: CustomStringConvertible {
	
	case declaration(Declaration)
	case `assignment`(Assignment)
	case `return`(Return)
	case `if`(If)
	case `while`(While)
	case call(Call)
	
	public var description: String {
		switch self {
		case .declaration(let declaration): return declaration.description
		case .`assignment`(let `assignment`): return `assignment`.description
		case .`return`(let `return`): return `return`.description
		case .`if`(let `if`): return `if`.description
		case .`while`(let `while`): return `while`.description
		case .call(let call): return call.description
		}
	}
	
}