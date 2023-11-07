# PMaxCompiler

Welcome to the PMax repository. PMax is a programming language that draws inspiration from C. It is built specifically with Hackerspace NTNU's [breadboard computer](https://github.com/hackerspace-ntnu/BreadboardComputer) in mind. While it might not match the sheer elegance of C or the power of Swift, PMax aims to provide an easy-to-use platform to make breadboard computer programming accessible. 

Within this repository, you will find the PMax compiler. The compiler translates PMax source code into breadboard computer assembly code. Although it is functional, the language and compiler still has a long way to go in terms of performance and usability. Several optimizations passes will be added later on to improve performance of the generated code. In addition, new language features that make the code more readable and "user-friendly" are on their way.

## Installation

Please refer to the [repository](https://github.com/Fleli/pmax) wrapping the compiler in an executable command-line application for installation instructions.

## Repository Structure

All code is found within `Sources/PMaxCompiler`. 

The folder `__main` provides the `Compiler` class, which represents the external interface for this repository. The `_Compiler` folder contains several definitions and functions that help the compilation, for example `FileOption`, a profiler and a pass manager.

The four folders `0Frontend`, `1PIL`, `2TAC`, and `3ASM` are also found within `Sources/PMaxCompiler`. These contain the actual code for source-to-assembly transformation. For further documentation on each pass, in addition to a future roadmap and a high-level compiler overview, please refer to the `_Docs` folder.

Finally, the `_Extensions` folder is used to extend existing types. An `SLRNode` extension is placed there in order to preserve it when SwiftParse and SwiftLex overwrites the frontend files.

## Standard Library

The standard library is being implemented in its own [repository](https://github.com/Fleli/PMax-StdLib). It will contain frequently used algorithms and data structures. Before the standard library can be used, however, the compiler needs to support an `import` statement and some infrastructure to "talk" to code outside the current source file.

## Timeline

Date        |   Commits |   State
------------|-----------|------------------------------------------------------------------------------------------------------------------------------
2023-10-02  |   1       |   The repository is set up.
2023-10-10  |   27      |   Old work was scrapped because of structural issues.
2023-10-16  |   51      |   The core functionality of PIL is completed, and TAC planning begins.
2023-10-20  |   77      |   The core functionality of TAC is completed, and ASM planning begins.
2023-10-23  |   98      |   Completed the core functionality of ASM. The compiler performed its first source-to-assembly transformation.
2023-11-01  |   115     |   Implemented a compiler interface and better error messages and assembly output. Laid out roadmap for future updates.
