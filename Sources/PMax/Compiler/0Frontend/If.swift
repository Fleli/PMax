        
// If.swift
// Auto-generated by SwiftParse
// See https://github.com/Fleli/SwiftParse

public class If: CustomStringConvertible {
	
	let condition: Expression
	let body: FunctionBodyStatements
	let `else`: Else?
	
	init(_ condition: Expression, _ body: FunctionBodyStatements, _ `else`: Else) {
		self.condition = condition
		self.body = body
		self.`else` = `else`
	}
	
	init(_ condition: Expression, _ body: FunctionBodyStatements) {
		self.condition = condition
		self.body = body
		self.`else` = nil
	}

	public var description: String {
		"if " + condition.description + " " + "{ " + body.description + " " + "} " + (`else` == nil ? "" : "else " + `else`!.description + " ")
	}
	
}
