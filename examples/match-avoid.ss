#!r6rs

(import (board)
        (rnrs))

(define bar-game
  (make-game
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

(run-game bar-game
          (recursion-solver 5 2))
