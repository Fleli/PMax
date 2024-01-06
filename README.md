# <img src="https://upload.wikimedia.org/wikipedia/commons/4/45/Pepsi_max_brand_logo.png" />

Welcome to the PMax repository. PMax is a programming language that draws inspiration from C. It is built specifically with Hackerspace NTNU's [breadboard computer](https://github.com/hackerspace-ntnu/BreadboardComputer) in mind. While it might not match the sheer elegance of C or the power of Swift, PMax aims to provide an easy-to-use platform to make breadboard computer programming accessible. This repository performs source-to-assembly transformation. An assembler is needed to convert the assembly code to machine instructions. This will be announced once finished.

## Installation

Please refer to the [PMax Development Kit](https://github.com/Fleli/PDK-Installer) to install the compiler (this repository), an assembler and a virtual machine to run the code on.

## Documentation

The `Documentation` folder contains detailed information about each part of the compiler. A quick overview is found in `Documentation/Compiler.md`.

## Standard Library

The standard library is being implemented in its own repository. Its development happens in parallel with the compiler and language. Therefore, it is rapidly changing and won't be published until it reaches a more stable state.

## Further Development

I would love to hear from you if you have
- found a compiler bug, e.g. a `fatalError()` (`trap`) during compilation or incorrect assembly output
- an idea for a feature you would like to see implemented
- an idea related to optimization, either in the compiler or its generated code

You can either open an issue on the repository's GitHub page or send me an email:

```
// Avoid bots
String email = "frederikedvardsen" + "@gmail" + ".com";
```

## Timeline

Date        |   Commits |   State
------------|-----------|-----------------------------------------------------------------------------------------------------------------------------------
2023-10-02  |   1       |   The repository is set up.
2023-10-10  |   27      |   Old work was scrapped because of structural issues.
2023-10-16  |   51      |   The core functionality of PIL is completed, and TAC planning begins.
2023-10-20  |   77      |   The core functionality of TAC is completed, and ASM planning begins.
2023-10-23  |   98      |   Completed the core functionality of ASM. The compiler performed its first source-to-assembly transformation.
2023-11-01  |   115     |   Implemented a compiler interface and better error messages and assembly output. Laid out roadmap for future updates.
2023-11-16  |   138     |   Improved code quality, implemented a few missing features and improved assembly code performance for literals.
2023-12-17  |   182     |   For the first time used in conjunction with assembler and virtual machine to run a program
