#!r6rs

(library

 (board scenario)

 (export make-scenario)

 (import (rnrs))

 (define scenario-header
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

 (define (make-scenario scenario-defs)
   (append scenario-header
           scenario-defs))

 )