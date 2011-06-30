#!r6rs

(library

 (board syntax)

 (export define?
         policy-call->name
         policy-call?
         policy-definition->base-policy-name
         policy-definition->other-policy-name
         policy-definition->policy-name
         policy-definition->goal-name
         policy-definition->causal-model-name
         policy-definition?
         solve?)

 (import (rnrs)
         (scheme-tools srfi-compat :1)
         (scheme-tools))

 (define (define? expr)
   (tagged-list? expr 'define))

 (define definition->name caadr)
 
 (define definition->body third) 

 (define (solve? expr)
   (tagged-list? expr 'solve))

 (define (policy-definition? expr)
   (and (define? expr)
        (> (length expr) 2)
        (solve? (third expr))))

 (define (policy-definition->policy-name expr)
   (definition->name expr))

 (define (policy-definition->goal-name expr)
   (second (definition->body expr)))

 (define (policy-definition->causal-model-name expr)
   (third (definition->body expr)))
 
 (define (policy-definition->base-policy-name expr)
   (if (> (length (definition->body expr)) 4)
       (fifth (definition->body expr))
       #f))
 
 (define (policy-definition->other-policy-name expr)
   (fourth (definition->body expr)))

 (define (policy-call? expr)
   (and (list? expr)
        (= (length expr) 1)
        (symbol? (first expr))))

 (define policy-call->name first) 

 )