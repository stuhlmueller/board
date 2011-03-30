#!r6rs

(library

 (board scenario)

 (export make-scenario
         scenario-avoid
         scenario-match
         scenario-match-avoid
         scenario-match-avoid-2)

 (import (rnrs))

 (define scenario-header
   '(
     (define (utility-match a b)
       (if (eq? a b)
           1
           .1))

     (define (utility-avoid a b)
       (if (eq? a b)
           .1
           1))

     (define (sample-action p)
       (if (flip p)
           (first actions)
           (second actions)))

     (define (uniform-action)
       (sample-action .5))
     
     ))

 (define (make-scenario scenario-defs)
   (append scenario-header
           scenario-defs))

 (define scenario-match
   (make-scenario
    '(
      (define A-game-0
        (game utility-match (solve B-game-0)))

      (define B-game-0
        (game utility-match (solve A-game-0)))
      )))

 (define scenario-avoid
   (make-scenario
    '(
      (define A-game-0
        (game utility-avoid (solve B-game-0)))

      (define B-game-0
        (game utility-avoid (solve A-game-0)))
      )))

 (define scenario-match-avoid
   (make-scenario
    '(
      (define match-avoid
        (game utility-avoid (solve B-game-0)))

      (define B-game-0
        (game utility-match (solve A-game-0)))

      (define A-game-0
        (game utility-match (solve B-game-0)))
      )))

 (define scenario-match-avoid-2
   (make-scenario
    '(
      (define B-game-1
        (game utility-match (solve A-game-1)))
      
      (define A-game-1
        (game utility-avoid (solve B-game-0)))
      
      (define B-game-0
        (game utility-match (solve A-game-0)))
      
      (define A-game-0
        (game utility-match (solve B-game-1)))
      )))

 )