#  Separation of Concerns

Today, the compiler is a very monolithic piece of software. This package, `PMaxCompiler`, translates the whole source file into its corresponding assembly code. Separating compilation from assembling is a good thing because it allows for a clear separation of concerns, improving clarity and compartmentalization. It is desirable to further divide the compiler into more standalone repositories because
(a) it introduces fewer bugs, since each module can be easily tested alone without considering the whole pipeline
(b) optimization passes can be more easily added if there is a clear protocol for communication between passes
(c) sifting out the syntactic frontend and generalizing the semantic checks will allow several languages to use the same code for semantic checks. Then, the compiler can be used not only by Hackerspace NTNU's breadboard computer project, but in other applications as well. 
(d) sifting out the backend allows for using an LLVM-like project to perform optimizations. Using a specialized library for optimizations is likely to result in better-performing code

The benefits of a library-based structure are clear. However, it will require much work to get such a model done right, which might present a challenge with the limited time of Hackerspace NTNU's breadboard computer project. Nevertheless, proper planning and external input on the needs of such libraries will make it doable.

Points (c) and (d) indicate the need for two major libraries:
- A semantic checker that performs type inference, type checking, scope resolution and more. This will replace today's PIL and (in part) TAC stages, and provide more functionality and better error messages, in addition to providing a standard interface so that more frontends can utilize it.
- An LLVM-like tool (significantly downscaled, of course) that serves as a code optimizer for many languages. Since no optimizations are present in today's PMax compiler, this won't replace any of the code in the `PMaxCompiler` package. This tool would use a generic instruction set that abstracts the physical machine and is easily optimizable.

In addition, some TAC- and all the ASM-related code would need to be replaced by a new tool that is
- compatible with the LLVM-like tool's IR
- specific to the breadboard computer's assembly language (like ASM is today)
