#!r6rs

(library

 (board)

 (export make-game
         run-game
         recursion-solver)
 
 (import (board compile)
         (board game)
         (board solve)
         (cosh)
         (rnrs)
         (scheme-tools srfi-compat :1)
         (scheme-tools))

 (define (run-game game solver)
   (let ([perspectives (compile game solver)])
     (for-each (lambda (perspective)
                 (let ([marginals (cosh (perspective->code perspective))])
                   (pe "\n" (perspective->name perspective) "\n")
                   (for-each (lambda (marg) (pe "  " (first marg) ": "(exp (rest marg)) "\n"))
                             marginals)))
               perspectives)))

 )