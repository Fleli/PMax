        
// Member.swift
// Auto-generated by SwiftParse
// See https://github.com/Fleli/SwiftParse

public class Member: CustomStringConvertible {
	
	let member: String
	
	init(_ member: String) {
		self.member = member
	}

	public var description: String {
		". " + member.description + " "
	}
	
}