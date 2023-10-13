
// TODO: Bør lage både en veldefinert `==`-funksjon for absolutt likhet, og en løsere `assignableTo(other:)`-funksjon som sjekker om `self` kan assignes til `other`, som f.eks. kan gjøres dersom `self` er en `void*` og `other` er en vilkårlig pointer (for å slippe casts ved f.eks. `malloc` er dette et fint spesialtilfelle å ta med i kompilatoren)

// TODO: Må også ha mulighet for å addere `int` til en hvilken som helst annen `.pointer`-type slik at pointer-aritmetikk blir mulig uten massevis av type casts.

// Merk imidlertid at disse ikke er strengt _nødvendige_ (syntaktisk sukker), så de legges til senere (men definitivt før "launch").

indirect enum PILType: CustomStringConvertible, Hashable {
    
    case int
    case void
    case `struct`(name: String)
    case pointer(pointee: PILType)
    case error
    
    var description: String {
        switch self {
        case .int:
            return Builtin.native
        case .void:
            return Builtin.void
        case .struct(let name):
            return name
        case .pointer(let pointee):
            return pointee.description + "*"
        case .error:
            return "<error>"
        }
    }
    
    init(_ underlyingType: `Type`, _ lowerer: PILLowerer) {
        
        switch underlyingType {
        case .basic(Builtin.native):
            self = .int
        case .basic(Builtin.void):
            self = .void
        case .basic(let id):
            self = .struct(name: id)
        case .pointer(let wrapped, _):
            let pilWrapped = PILType(wrapped, lowerer)
            self = .pointer(pointee: pilWrapped)
        }
        
    }
    
}
