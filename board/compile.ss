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
 
 (define (get-policy-names game)
   (filter-map (lambda (expr)
                 (if (policy-definition? expr)
                     (policy-definition->policy-name expr)
                     #f))
               game))
 
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
 
 (define (compile game solver)
   (let* ([policy-names (get-policy-names game)]
          [code (map (lambda (expr) (compile-expr (solver policy-names) expr))
                     game)])
     ;; (for-each ppe code)
     (make-perspectives solver policy-names code)))

 )