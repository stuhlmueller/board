#!r6rs

(library

 (board game)

 (export make-game)

 (import (rnrs))

 (define game-header
   '(

     (define (goal-match state)
       (equal? (length (delete-duplicates state))
               1))
     
     (define (goal-avoid state)
       (equal? (length (delete-duplicates state))
               (length state)))

     (define (identity-world . actions)
       actions)
     
     (define (sample-action p)
       (if (flip p)
           (first actions)
           (second actions)))

     (define (uniform-action)
       (sample-action .5))
     
     ))

 (define (make-game game-defs)
   (append game-header
           game-defs))

 )