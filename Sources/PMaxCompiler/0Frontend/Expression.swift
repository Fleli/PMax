        
// Expression.swift
// Auto-generated by SwiftParse
// See https://github.com/Fleli/SwiftParse

public indirect enum Expression: CustomStringConvertible {
	
	public enum InfixOperator: String {
		case operator_0 = "||"
		case operator_1 = "&&"
		case operator_2 = "|"
		case operator_3 = "^"
		case operator_4 = "&"
		case operator_5 = "=="
		case operator_6 = "!="
		case operator_7 = "<"
		case operator_8 = ">"
		case operator_9 = "<="
		case operator_10 = ">="
		case operator_11 = "<<"
		case operator_12 = ">>"
		case operator_13 = "+"
		case operator_14 = "-"
		case operator_15 = "*"
		case operator_16 = "/"
		case operator_17 = "%"
	}
	
	case infixOperator(InfixOperator, Expression, Expression)
	
	public enum SingleArgumentOperator: String {
		case operator_0 = "sizeof"
		case operator_1 = "!"
		case operator_2 = "~"
		case operator_3 = "-"
	}
	
	case singleArgumentOperator(SingleArgumentOperator, Expression)
	
	case leftParenthesis_ExpressionrightParenthesis_(String, Expression, String)
	case TypeCastleftParenthesis_ExpressionrightParenthesis_(TypeCast, String, Expression, String)
	case integer(String)
	case identifier(String)
	case identifierleftParenthesis_ArgumentsrightParenthesis_(String, String, Arguments, String)
	case leftParenthesis_ExpressionrightParenthesis_period_identifier(String, Expression, String, String, String)
	case ampersand_Expression(String, Expression)
	case asterisk_Expression(String, Expression)

	public var description: String {
		switch self {
		case .infixOperator(let op, let a, let b): return "(\(a.description) \(op.rawValue) \(b.description))"
		case .singleArgumentOperator(let op, let a): return "(\(op.rawValue) \(a.description))"
		case .leftParenthesis_ExpressionrightParenthesis_(_, let expression, _): return "(" + expression.description + ")"
		case .TypeCastleftParenthesis_ExpressionrightParenthesis_(let typeCast, _, let expression, _): return typeCast.description + "(" + expression.description + ")"
		case .integer(_): return "integer"
		case .identifier(_): return "identifier"
		case .identifierleftParenthesis_ArgumentsrightParenthesis_(_, _, let arguments, _): return "identifier" + "(" + arguments.description + ")"
		case .leftParenthesis_ExpressionrightParenthesis_period_identifier(_, let expression, _, _, _): return "(" + expression.description + ")" + "." + "identifier"
		case .ampersand_Expression(_, let expression): return "&" + expression.description
		case .asterisk_Expression(_, let expression): return "*" + expression.description
		}
	}
	
}