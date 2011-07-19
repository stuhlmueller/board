# Board

This is an example of how to use Board to compute policies for simple games:

    #!r6rs
    
    (import (board)
            (rnrs))
    
    (define my-scenario
      (make-scenario
       '(
         (define actions
           '(popular-bar other-bar))
    
         (define (jim-1)
           (solve goal-avoid
                  identity-world
                  (list john-0)))
         
         (define (jim-0)
           (solve goal-match
                  identity-world
                  (list john-0)
                  (lambda () (sample-action .6))))
         
         (define (john-0)
           (solve goal-match
                  identity-world
                  (list jim-0)
                  (lambda () (sample-action .6))))
         )))
    
    (run-scenario my-scenario
                  (recursion-solver 5 2))

Running the above code in [Ikarus Scheme](http://ikarus-scheme.org/) or [Vicare Scheme](https://github.com/marcomaggi/vicare) results in the following output:

    jim-1
      other-bar: 0.9999999999878807
      popular-bar: 1.2087651728459907e-11
    
    jim-0
      other-bar: 8.058434485672552e-12
      popular-bar: 0.9999999999919361
    
    john-0
      other-bar: 8.058434485672552e-12
      popular-bar: 0.9999999999919361
