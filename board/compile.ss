#!r6rs

;; Given a game in the board language, compile it to church code (with
;; one variant per player).

(library

 (board compile)

 (export compile
         make-perspective
         perspective->code
         perspective->name)

 (import (board syntax)
         (rnrs)
         (scheme-tools)
         (scheme-tools srfi-compat :1))

 (define-record-type perspective
   (fields (immutable name perspective->name)
           (immutable code perspective->code)))

 (define (get-policies scenario)
   (if (null? scenario)
       '()
       (let ([expr (first scenario)]
             [policies (get-policies (rest scenario))])
         (if (policy-definition? expr)
             (pair (policy-definition->policy-name expr) policies)
             policies))))
 
 (define (compile-expr solver expr)
   (if (policy-definition? expr)
       (solver expr)
       expr))

 (define (make-perspectives solver policies code)
   (map (lambda (policy)
          (make-perspective policy
                            (append code
                                    `( ,(solver policies `(,policy)) ))))
        policies))
 
 (define (compile scenario solver)
   (let* ([policies (get-policies scenario)]
          [code (map (lambda (expr) (compile-expr (solver policies) expr))
                     scenario)])
     ;; (for-each ppe code)
     (make-perspectives solver policies code)))

 )