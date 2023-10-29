        
// Declaration.swift
// Auto-generated by SwiftParse
// See https://github.com/Fleli/SwiftParse

public class Declaration: CustomStringConvertible {
	
	let type: `Type`
	let name: String
	let value: Expression?
	
	init(_ type: `Type`, _ name: String) {
		self.type = type
		self.name = name
		self.value = nil
	}
	
	init(_ type: `Type`, _ name: String, _ value: Expression) {
		self.type = type
		self.name = name
		self.value = value
	}

	public var description: String {
		type.description + " " + name.description + " " + (value == nil ? "" : "= " + value!.description + " ") + "; "
	}
	
}
