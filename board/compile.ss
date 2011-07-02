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

 (define (get-policy-names scenario)
   (if (null? scenario)
       '()
       (let ([expr (first scenario)]
             [policy-names (get-policy-names (rest scenario))])
         (if (policy-definition? expr)
             (pair (policy-definition->policy-name expr) policy-names)
             policy-names))))
 
 (define (compile-expr solver expr)
   (if (policy-definition? expr)
       (solver expr)
       expr))

 (define (make-perspectives solver policy-names code)
   (map (lambda (policy)
          (make-perspective policy
                            (append code
                                    `( ,(solver policy-names `(,policy)) ))))
        policy-names))
 
 (define (compile scenario solver)
   (let* ([policy-names (get-policy-names scenario)]
          [code (map (lambda (expr) (compile-expr (solver policy-names) expr))
                     scenario)])
     ;; (for-each ppe code)
     (make-perspectives solver policy-names code)))

 )