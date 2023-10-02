        
// Reference.swift
// Auto-generated by SwiftParse
// See https://github.com/Fleli/SwiftParse

public indirect enum Reference: CustomStringConvertible {
	
	case identifier(_ identifier: String)
	case intLiteral(_ integer: String)
	case member(_ reference: Reference, _ _underscore_terminal: String, _ identifier: String)
	case call(_ identifier: String, _ _underscore_terminal: String, _ arguments: Arguments, _ _underscore_terminal49: String)
	
	public var description: String {
		switch self {
		case .identifier(let identifier): return identifier 
		case .intLiteral(let integer): return integer 
		case .member(let reference, let _underscore_terminal, let identifier): return reference.description + _underscore_terminal + identifier 
		case .call(let identifier, let _underscore_terminal, let arguments, let _underscore_terminal49): return identifier + _underscore_terminal + arguments.description + _underscore_terminal49 
		}
	}
	
}
