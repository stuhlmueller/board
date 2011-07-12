#!r6rs

(import (board)
        (rnrs))

(define my-scenario
  (make-scenario
   '(
     (define actions '(popular-bar other-bar))
     
     (define (jim-1)
       (solve (lambda (x) (equal? x 1))
              (lambda (y z1 z2) (if (equal? y z1) 0 1))
              (list john-0 john-0)))
     
     (define (jim-0)
       (solve (lambda (x) (equal? x 1))
              (lambda (y z1 z2) (if (equal? y z1) 0 1))
              (list john-0 john-0)
              (lambda () (sample-action .6))))
     
     (define (john-0)
       (solve (lambda (x) (equal? x 1))
              (lambda (y z1 z2) (if (equal? y z1) 0 1))
              (list jim-0 jim-0)
              (lambda () (sample-action .6))))
     )))

(run-scenario my-scenario
              (recursion-solver 5 2))