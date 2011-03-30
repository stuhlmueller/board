# Board

This is an example of how to use Board to compute policies for simple games:

    #!r6rs
    
    (import (board)
            (rnrs))
    
    (define my-scenario
      (make-scenario
       '(
         (define actions '(popular-bar other-bar))
         
         (define (jim-1)
           (solve utility-avoid
                  john-0))
         
         (define (jim-0)
           (solve utility-match
                  john-0
                  (lambda () (sample-action .6))))
         
         (define (john-0)
           (solve utility-match
                  jim-0
                  (lambda () (sample-action .6))))
         )))
    
    (run-scenario my-scenario
                  (recursion-solver 10 2))

Running the above code in [Ikarus Scheme](http://ikarus-scheme.org/) or [Vicare Scheme](https://github.com/marcomaggi/vicare) results in the following output:

    jim-1
    (other-bar . 0.987487235399809)
    (popular-bar . 0.012512764606264177)
    
    jim-0
    (other-bar . 0.012512764606264177)
    (popular-bar . 0.9874872353998092)
    
    john-0
    (other-bar . 0.012512764606264177)
    (popular-bar . 0.9874872353998092)
