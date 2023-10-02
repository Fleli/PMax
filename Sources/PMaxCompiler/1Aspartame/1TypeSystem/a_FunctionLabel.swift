class FunctionLabel {
    
    var name: String
    var type: DataType
    var parameters: [DataType]
    
    init(_ name: String, _ type: DataType, _ parameters: [DataType]) {
        self.name = name
        self.type = type
        self.parameters = parameters
    }
    
}
