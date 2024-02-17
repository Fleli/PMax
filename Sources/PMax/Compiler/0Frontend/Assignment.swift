        
// Assignment.swift
// Auto-generated by SwiftParse
// See https://github.com/Fleli/SwiftParse

public class Assignment: CustomStringConvertible {
	
	let lhs: Expression
	let `operator`: SugarOperator?
	let rhs: Expression
	
	init(_ lhs: Expression, _ rhs: Expression) {
		self.lhs = lhs
		self.`operator` = nil
		self.rhs = rhs
	}
	
	init(_ lhs: Expression, _ `operator`: SugarOperator, _ rhs: Expression) {
		self.lhs = lhs
		self.`operator` = `operator`
		self.rhs = rhs
	}

	public var description: String {
		lhs.description + " " + (`operator` == nil ? "" : "@ " + `operator`!.description + " ") + "= " + rhs.description + " " + "; "
	}
	
}
