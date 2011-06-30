#!r6rs

(library

 (board scenario)

 (export make-scenario)

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

 

 )