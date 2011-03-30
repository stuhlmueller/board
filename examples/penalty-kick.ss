#!r6rs

(import (board)
        (rnrs))

(define my-scenario
  (make-scenario
   '(

     (define actions '(left right))

     (define (kicker-utility a b)
       (cond
        [(and (eq? a 'left) (eq? b 'left)) 0.2]
        [(and (eq? a 'left) (eq? b 'right)) 0.6]
        [(and (eq? a 'right) (eq? b 'right)) 0.3]
        [(and (eq? a 'right) (eq? b 'left)) 0.7]
        [else (error (list a b) "unknown actions")]))

     (define (goalie-utility a b)
       (- 1.0 (kicker-utility a b)))
     
     (define (kicker-policy)
       (solve kicker-utility
              goalie-policy))

     (define (goalie-policy)
       (solve goalie-utility
              kicker-policy))

     )))

(run-scenario my-scenario
              (recursion-solver 10 1))