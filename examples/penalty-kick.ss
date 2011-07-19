#!r6rs

(import (board)
        (rnrs))

(define my-scenario
  (make-scenario
   '(

     (define actions '(left right))

     (define (goalie-goal state)
       (not (eq? state 'goal)))
     
     (define (kicker-goal state)
       (eq? state 'goal))

     (define (score p)
       (if (flip p)
           'goal
           'nogoal))
     
     (define (goalie-world goalie kicker)
       (cond
        [(and (eq? kicker 'left) (eq? goalie 'left)) (score 0.2)]
        [(and (eq? kicker 'left) (eq? goalie 'right)) (score 0.6)]
        [(and (eq? kicker 'right) (eq? goalie 'right)) (score 0.3)]
        [(and (eq? kicker 'right) (eq? goalie 'left)) (score 0.7)]
        [else (error (list kicker goalie) "unknown action(s)")]))

     (define (kicker-world kicker goalie)
       (goalie-world goalie kicker))
     
     (define (kicker-policy)
       (solve kicker-goal
              kicker-world
              (list goalie-policy)))

     (define (goalie-policy)
       (solve goalie-goal
              goalie-world
              (list kicker-policy)))

     )))

(run-scenario my-scenario
              (recursion-solver 10 1))