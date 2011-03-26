Example:

    #!r6rs
    
    (import (board)
            (rnrs))
    
    (define my-scenario
      (make-scenario
       '(
         (define (policy-A1)
           (solve utility-avoid
                  policy-B0
                  ))
    
         (define (policy-B0)
           (solve utility-match
                  policy-A0
                  (lambda () (sample-action .6))
                  ))
    
         (define (policy-A0)
           (solve utility-match
                  policy-B0
                  (lambda () (sample-action .6))))
         )))
    
    ;; recursion depth 10
    ;; optimization strength 2
    (run-scenario my-scenario
                  (recursion-solver 10 2))

Result:

    policy-A1
    (action-2 . 0.9999999979242495)
    (action-1 . 2.061340791863192e-9)
    
    policy-B0
    (action-2 . 2.061340791863192e-9)
    (action-1 . 0.9999999979242495)
    
    policy-A0
    (action-2 . 2.061340791863192e-9)
    (action-1 . 0.9999999979242495)
