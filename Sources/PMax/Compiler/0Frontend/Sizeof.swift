        
// Sizeof.swift
// Auto-generated by SwiftParse
// See https://github.com/Fleli/SwiftParse

public class Sizeof: CustomStringConvertible {
	
	let type: `Type`
	
	init(_ type: `Type`) {
		self.type = type
	}

	public var description: String {
		"sizeof " + "( " + type.description + " " + ") "
	}
	
}