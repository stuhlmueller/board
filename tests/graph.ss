#!r6rs

(import (rnrs)
        (board)
        (board syntax)
        (board graph)
        (scheme-tools)
        (scheme-tools property)
        (scheme-tools graph)
        (scheme-tools graph utils))

(define bar-game
  (make-game
   '(
     (define actions
       '(popular-bar other-bar))

     (define (jim-1)
       (solve goal-avoid
              identity-world
              (list john-0)))
     
     (define (jim-0)
       (solve goal-match
              identity-world
              (list john-0)
              (lambda () (sample-action .6))))
     
     (define (john-0)
       (solve goal-match
              identity-world
              (list jim-0)
              (lambda () (sample-action .6))))
     )))


;; metadata example

(set-property! 'john-0 'readable-name "John/0")
(set-property! 'jim-0 'readable-name "Jim/0")
(set-property! 'jim-1 'readable-name "Jim/1")

(set-property! 'goal-match 'readable-name "match")
(set-property! 'goal-avoid 'readable-name "avoid")

(define (readable-policy policy-name)
  (get-property policy-name 'readable-name))

(define (readable-goal goal-name)
  (get-property goal-name 'readable-name))


;; game graph example

(define (policy-name->policy-goal policy-name)
  (policy-def->goal-name (policy-name->policy-def policy-name)))

(define/curry (display-component graph component)
  (apply pe
         `("\nGroup: " ,component "\n"
           ,@(apply append
                    (map (lambda (policy-name)
                           `("  " ,(readable-policy policy-name) " plays against "
                             ,@(map readable-policy (graph:children graph policy-name))
                             ", wants to " ,(readable-goal (policy-name->policy-goal policy-name)) "\n"))
                         component)))))

(define (display-game-info game)
  (let* ([graph (game->graph game)]
         [components (graph->components graph)])
    (for-each (display-component graph)
              components)))

(display-game-info bar-game)