import ArgumentParser

@main
struct pmax: ParsableCommand {
    
    static let configuration = CommandConfiguration(
        abstract: "PMax Compiler",
        subcommands: [Version.self, Build.self, Init.self]
    )
    
}
