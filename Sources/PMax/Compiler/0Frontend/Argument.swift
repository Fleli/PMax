        
// Argument.swift
// Auto-generated by SwiftParse
// See https://github.com/Fleli/SwiftParse

public class Argument: CustomStringConvertible {
	
	let label: String?
	let expression: Expression
	
	init(_ label: String, _ expression: Expression) {
		self.label = label
		self.expression = expression
	}
	
	init(_ expression: Expression) {
		self.label = nil
		self.expression = expression
	}

	public var description: String {
		(label == nil ? "" : label!.description + " " + ": ") + expression.description + " "
	}
	
}
