#!r6rs

(import (rnrs)

        (board)
        (board english)
        (scheme-tools)
        (scheme-tools property)
        (scheme-tools graph)
        (scheme-tools graph utils)
        (scheme-tools srfi-compat :1))

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

(set-property! 'identity-world 'readable-name "there is a popular bar and an unpopular bar")

(set-game-knowledge bar-game)
(pe (get-player-knowledge 'jim-1))
