#!r6rs

(import (board)
        (rnrs))

(define my-scenario
  (make-scenario
   '(

     (define actions '(left right))

     (define (kicker-utility self other)
       (cond
        [(and (eq? self 'left) (eq? other 'left)) 0.2]
        [(and (eq? self 'left) (eq? other 'right)) 0.6]
        [(and (eq? self 'right) (eq? other 'right)) 0.3]
        [(and (eq? self 'right) (eq? other 'left)) 0.7]
        [else (error (list self other) "unknown actions")]))

     (define (goalie-utility self other)
       (- 1.0 (kicker-utility other self)))
     
     (define (kicker-policy)
       (solve kicker-utility
              goalie-policy))

     (define (goalie-policy)
       (solve goalie-utility
              kicker-policy))

     )))

(run-scenario my-scenario
              (recursion-solver 10 1))