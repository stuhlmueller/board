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