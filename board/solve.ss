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

 (define/curry (policy-name->policy-call depth-var policy-name)
   `(,policy-name (- ,depth-var ,1)))
 
 (define (recursion-solver:compile-def hardness policy-names expr)
   (let* ([depth-var (make-variable)]
          [policy-name (policy-def->policy-name expr)]
          [other-policy-names (policy-def->other-policy-names expr)]
          [other-policy-calls (map (policy-name->policy-call depth-var) other-policy-names)]
          [base-policy-name (or (policy-def->base-policy-name expr)
                                'uniform-action)]
          [action-name (make-variable)]
          [goal-name (policy-def->goal-name expr)]
          [causal-model-name (policy-def->causal-model-name expr)])
     `(define (,policy-name ,depth-var)
        (rejection-query
         (define ,action-name (,base-policy-name))
         ,action-name
         (or (= ,depth-var 0)
             (and ,@(make-list hardness
                               `(,goal-name (,causal-model-name ,action-name
                                                                ,@other-policy-calls)))))))))
 
 (define/curry (recursion-solver depth hardness policy-names expr)
   (cond [(policy-def? expr) (recursion-solver:compile-def hardness policy-names expr)]
         [(policy-call? expr) `(,(policy-call->name expr) ,depth)]
         [else (error expr "recursion-solver: unknown expression type")]))

 )