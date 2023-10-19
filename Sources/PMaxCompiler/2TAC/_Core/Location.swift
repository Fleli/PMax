indirect enum Location: CustomStringConvertible {
    
    case framePointer(offset: Int)
    case dataSection(index: Int)
    case rawPointer(from: Location)
    
    var description: String {
        switch self {
        case .framePointer(let offset):
            return "[fp + \(offset)]"
        case .dataSection(let index):
            return "[text @ \(index)]"
        case .rawPointer(let location):
            return "[raw \(location)]"
        }
    }
    
}
