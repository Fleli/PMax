        
// Assignment.swift
// Auto-generated by SwiftParse
// See https://github.com/Fleli/SwiftParse

public class Assignment: CustomStringConvertible {
	
	let lhs: Expression
	let rhs: Expression
	
	init(_ lhs: Expression, _ rhs: Expression) {
		self.lhs = lhs
		self.rhs = rhs
	}

	public var description: String {
		"assign " + lhs.description + " " + "= " + rhs.description + " " + "; "
	}
	
}
