#!r6rs

(library

 (board)

 (export make-scenario
         recursion-solver
         run-scenario)
 
 (import (board compile)
         (board scenario)
         (board solve)
         (cosh)
         (rnrs)
         (scheme-tools srfi-compat :1)
         (scheme-tools))

 (define (run-scenario scenario solver)
   (let ([perspectives (compile scenario solver)])
     (for-each (lambda (perspective)
                 (let ([marginals (cosh (perspective->code perspective))])
                   (pe "\n" (perspective->name perspective) "\n")
                   (for-each (lambda (marg) (pe "  " (first marg) ": "(exp (rest marg)) "\n"))
                             marginals)))
               perspectives)))

 )