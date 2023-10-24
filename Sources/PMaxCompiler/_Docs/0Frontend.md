#  Syntactic Frontend

The `Frontend` folder represents the compiler's syntactic frontend. It contains infrastructure for performing lexical analysis, creating a raw parse tree and converting that parse tree into a form that is more usable by the next stage. Consider, as an example, the source code

```
int main() {
    
    int a = 5;
    int b = 6;
    
    return a + b;
    
}
```

Lexical analysis touches on every single character in the input and results in an array of _tokens_, represented internally by the `Token` class. Each `Token` has a _type_ (first column) and some _content_ (second column). The class also stores information about where in the input it was found. This will become useful later for syntax highlighting and precise error messages.

<details>
    <summary>Generated tokens</summary>
    <code>
    identifier         int                   ln 1 col 0 -> ln 1 col 2   
    identifier         main                  ln 1 col 4 -> ln 1 col 7   
    (                  (                     ln 1 col 8 -> ln 1 col 8   
    )                  )                     ln 1 col 9 -> ln 1 col 9   
    {                  {                     ln 1 col 11 -> ln 1 col 11 
    identifier         int                   ln 3 col 4 -> ln 3 col 6   
    identifier         a                     ln 3 col 8 -> ln 3 col 8   
    =                  =                     ln 3 col 10 -> ln 3 col 10 
    integer            5                     ln 3 col 12 -> ln 3 col 12 
    ;                  ;                     ln 3 col 13 -> ln 3 col 13 
    identifier         int                   ln 4 col 4 -> ln 4 col 6   
    identifier         b                     ln 4 col 8 -> ln 4 col 8   
    =                  =                     ln 4 col 10 -> ln 4 col 10 
    integer            6                     ln 4 col 12 -> ln 4 col 12 
    ;                  ;                     ln 4 col 13 -> ln 4 col 13 
    return             return                ln 6 col 4 -> ln 6 col 9   
    identifier         a                     ln 6 col 11 -> ln 6 col 11 
    +                  +                     ln 6 col 13 -> ln 6 col 13 
    identifier         b                     ln 6 col 15 -> ln 6 col 15 
    ;                  ;                     ln 6 col 16 -> ln 6 col 16 
    }                  }                     ln 8 col 0 -> ln 8 col 0   
    </code>
</details>

Then comes the parsing stage, which uses an SLR parser to parse the tokens and return a tree that represents the input.

<details>
    <summary>Raw parse tree</summary>
    <code>
    TopLevelStatements                                       
    | TopLevelStatement                                      
    | | Function                                             
    | | | Type                                               
    | | | | identifier                                       
    | | | identifier                                         
    | | | (                                                  
    | | | Parameters                                         
    | | | )                                                  
    | | | {                                                  
    | | | FunctionBodyStatements                             
    | | | | FunctionBodyStatements                           
    | | | | | FunctionBodyStatements                         
    | | | | | | FunctionBodyStatement                        
    | | | | | | | Declaration                                
    | | | | | | | | Type                                     
    | | | | | | | | | identifier                             
    | | | | | | | | identifier                               
    | | | | | | | | =                                        
    | | | | | | | | Expression                               
    | | | | | | | | | CASEBExpression                        
    | | | | | | | | | | CASECExpression                      
    | | | | | | | | | | | CASEDExpression                    
    | | | | | | | | | | | | CASEEExpression                  
    | | | | | | | | | | | | | CASEFExpression                
    | | | | | | | | | | | | | | CASEGExpression              
    | | | | | | | | | | | | | | | CASEHExpression            
    | | | | | | | | | | | | | | | | CASEIExpression          
    | | | | | | | | | | | | | | | | | CASEJExpression        
    | | | | | | | | | | | | | | | | | | CASEKExpression      
    | | | | | | | | | | | | | | | | | | | CASELExpression    
    | | | | | | | | | | | | | | | | | | | | integer          
    | | | | | | | | ;                                        
    | | | | | FunctionBodyStatement                          
    | | | | | | Declaration                                  
    | | | | | | | Type                                       
    | | | | | | | | identifier                               
    | | | | | | | identifier                                 
    | | | | | | | =                                          
    | | | | | | | Expression                                 
    | | | | | | | | CASEBExpression                          
    | | | | | | | | | CASECExpression                        
    | | | | | | | | | | CASEDExpression                      
    | | | | | | | | | | | CASEEExpression                    
    | | | | | | | | | | | | CASEFExpression                  
    | | | | | | | | | | | | | CASEGExpression                
    | | | | | | | | | | | | | | CASEHExpression              
    | | | | | | | | | | | | | | | CASEIExpression            
    | | | | | | | | | | | | | | | | CASEJExpression          
    | | | | | | | | | | | | | | | | | CASEKExpression        
    | | | | | | | | | | | | | | | | | | CASELExpression      
    | | | | | | | | | | | | | | | | | | | integer            
    | | | | | | | ;                                          
    | | | | FunctionBodyStatement                            
    | | | | | Return                                         
    | | | | | | return                                       
    | | | | | | Expression                                   
    | | | | | | | CASEBExpression                            
    | | | | | | | | CASECExpression                          
    | | | | | | | | | CASEDExpression                        
    | | | | | | | | | | CASEEExpression                      
    | | | | | | | | | | | CASEFExpression                    
    | | | | | | | | | | | | CASEGExpression                  
    | | | | | | | | | | | | | CASEHExpression                
    | | | | | | | | | | | | | | CASEIExpression              
    | | | | | | | | | | | | | | | CASEIExpression            
    | | | | | | | | | | | | | | | | CASEJExpression          
    | | | | | | | | | | | | | | | | | CASEKExpression        
    | | | | | | | | | | | | | | | | | | CASELExpression      
    | | | | | | | | | | | | | | | | | | | identifier         
    | | | | | | | | | | | | | | | +                          
    | | | | | | | | | | | | | | | CASEJExpression            
    | | | | | | | | | | | | | | | | CASEKExpression          
    | | | | | | | | | | | | | | | | | CASELExpression        
    | | | | | | | | | | | | | | | | | | identifier           
    | | | | | | ;                                            
    | | | }
    </code>
</details>

From the tree, it is apparent that expressions are deeply nested. This is because the grammar contains a high number of indirections due to operator precedence rules.

The parse tree is then converted into classes and enumerations that can be used by later parts of the compiler. Most of the important constructs get their own class or enum. For example, declarations look like this:

<details>
    <summary>The <code>Declaration</code> class</summary>
    <code>
    public class Declaration: CustomStringConvertible {           <br>
                                                                  <br>
        let type: `Type`                                          <br>
        let name: String                                          <br>
        let value: Expression?                                    <br>
                                                                  <br>
        init(_ type: `Type`, _ name: String, _ value: Expression) {<br>
            self.type = type                                      <br>
            self.name = name                                      <br>
            self.value = value                                    <br>
        }                                                         <br>
                                                                  <br>
        init(_ type: `Type`, _ name: String) {                    <br>
            self.type = type                                      <br>
            self.name = name                                      <br>
            self.value = nil                                      <br>
        }                                                         <br>
                                                                  <br>
        public var description: String {                          <br>
            type.description + " " + name.description + " " + (value == nil ? "" : "= " + value!.description + " ") + "; "<br>
        }                                                         <br>
                                                                  <br>
    }
    </code>
</details>

The whole process of lexing, parsing and converting to a usable form is done automatically by [SwiftLex](https://github.com/Fleli/SwiftLex) and [SwiftParse](https://github.com/Fleli/SwiftParse).
