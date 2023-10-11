class PILIfStatement {
    
    let condition: PILExpression
    
    let body: [PILStatement]
    
    let `else`: PILIfStatement?
    
    init(_ condition: PILExpression, _ body: [PILStatement], _ `else`: PILIfStatement? = nil) {
        self.condition = condition
        self.body = body
        self.`else` = `else`
    }
    
}
