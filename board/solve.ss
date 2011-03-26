#!r6rs

(library

 (board solve)

 (export recursion-solver)

 (import (board syntax)
         (rnrs)
         (scheme-tools)
         (scheme-tools srfi-compat :1))

 (define make-variable
   (symbol-maker 'v))
 
 (define (recursion-solver:compile-def hardness policies expr)
   (let ([depth-var (make-variable)]
         [policy-name (policy-definition->policy-name expr)]
         [other-policy-name (policy-definition->other-policy-name expr)]
         [base-policy-name (or (policy-definition->base-policy-name expr)
                               'uniform-action)]
         [action-name (make-variable)]
         [utility-name (policy-definition->utility-name expr)])
     `(define (,policy-name ,depth-var)
        (if (= ,depth-var 0)
            (,base-policy-name)
            (rejection-query
             (define ,action-name (uniform-action))
             ,action-name
             (and ,@(make-list hardness
                               `(flip (exp (,utility-name ,action-name
                                                          (,other-policy-name (- ,depth-var 1))))))))))))
 
  (define/curry (recursion-solver depth hardness policies expr)
   (cond [(policy-definition? expr) (recursion-solver:compile-def hardness policies expr)]
         [(policy-call? expr) `(,(policy-call->name expr) ,depth)]
         [else (error expr "recursion-solver: unknown expression type")]))

 )