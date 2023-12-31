        
// Struct.swift
// Auto-generated by SwiftParse
// See https://github.com/Fleli/SwiftParse

public class Struct: CustomStringConvertible {
	
	let name: String
	let statements: StructBodyStatements
	
	init(_ name: String, _ statements: StructBodyStatements) {
		self.name = name
		self.statements = statements
	}

	public var description: String {
		"struct " + name.description + " " + "{ " + statements.description + " " + "} "
	}
	
}
