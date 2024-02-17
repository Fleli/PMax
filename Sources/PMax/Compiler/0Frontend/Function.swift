        
// Function.swift
// Auto-generated by SwiftParse
// See https://github.com/Fleli/SwiftParse

public class Function: CustomStringConvertible {
	
	let name: String
	let parameters: Parameters
	let type: `Type`?
	let body: FunctionBodyStatements
	
	init(_ name: String, _ parameters: Parameters, _ type: `Type`, _ body: FunctionBodyStatements) {
		self.name = name
		self.parameters = parameters
		self.type = type
		self.body = body
	}
	
	init(_ name: String, _ parameters: Parameters, _ body: FunctionBodyStatements) {
		self.name = name
		self.parameters = parameters
		self.type = nil
		self.body = body
	}

	public var description: String {
		"func " + name.description + " " + "( " + parameters.description + " " + ") " + (type == nil ? "" : "-> " + type!.description + " ") + "{ " + body.description + " " + "} "
	}
	
}
