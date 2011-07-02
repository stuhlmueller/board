#!r6rs

(library

 (board solve)

 (export recursion-solver
         recursion-solver:compile-def)

 (import (board syntax)
         (rnrs)
         (scheme-tools)
         (scheme-tools srfi-compat :1))

 (define make-variable
   (symbol-maker 'v))
 
 (define (recursion-solver:compile-def hardness policies expr)
   (let* ([depth-var (make-variable)]
         [policy-name (policy-definition->policy-name expr)]
         [other-policies (policy-definition->other-policies expr depth-var)]
         [base-policy-name (or (policy-definition->base-policy-name expr)
                               'uniform-action)]
         [action-name (make-variable)]
         [goal-name (policy-definition->goal-name expr)]
         [causal-model-name (policy-definition->causal-model-name expr)])
     `(define (,policy-name ,depth-var)
        (if (= ,depth-var 0)
            (,base-policy-name)
            (rejection-query
             (define ,action-name (uniform-action))
             ,action-name
             (and ,@(make-list hardness
                               `(,goal-name (,causal-model-name ,action-name
                                                     ,@other-policies)))))))))
 
  (define/curry (recursion-solver depth hardness policies expr)
   (cond [(policy-definition? expr) (recursion-solver:compile-def hardness policies expr)]
         [(policy-call? expr) `(,(policy-call->name expr) ,depth)]
         [else (error expr "recursion-solver: unknown expression type")]))



 )