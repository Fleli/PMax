        
// UnconditionalElse.swift
// Auto-generated by SwiftParse
// See https://github.com/Fleli/SwiftParse

public class UnconditionalElse: CustomStringConvertible {
	
	let body: FunctionBodyStatements
	
	init(_ body: FunctionBodyStatements) {
		self.body = body
	}

	public var description: String {
		"{ " + body.description + " " + "} "
	}
	
}
