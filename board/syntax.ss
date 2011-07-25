#!r6rs

(library

 (board syntax)

 (export define?
         game->policy-names
         game->policy-defs
         policy-call->name
         policy-call?
         policy-def->base-policy-name         
         policy-def->policy-name
         policy-def->goal-name
         policy-def->causal-model-name
         policy-def->other-policy-names
         policy-def?
         solve?)

 (import (rnrs)
         (scheme-tools srfi-compat :1)
         (scheme-tools))

 (define (define? expr)
   (tagged-list? expr 'define))

 (define def->name caadr)
 
 (define def->body third) 

 (define (solve? expr)
   (tagged-list? expr 'solve))

 (define (policy-def? expr)
   (and (define? expr)
        (> (length expr) 2)
        (solve? (third expr))))

 (define (policy-def->policy-name expr)
   (def->name expr))

 (define (policy-def->goal-name expr)
   (second (def->body expr)))

 (define (policy-def->causal-model-name expr)
   (third (def->body expr)))
 
 (define (policy-def->base-policy-name expr)
   (if (> (length (def->body expr)) 4)
       (fifth (def->body expr))
       #f))
 
 (define (policy-def->other-policy-names expr)
   (rest (fourth (def->body expr))))
 
 (define (policy-call? expr)
   (and (list? expr)
        (= (length expr) 1)
        (symbol? (first expr))))

 (define policy-call->name first) 

 (define (game->policy-defs game)
   (filter policy-def? game))
 
 (define (game->policy-names game)
   (map policy-def->policy-name
        (game->policy-defs game)))

 )