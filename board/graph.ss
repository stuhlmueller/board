#!r6rs

;; Given a game in the board language, compute graph structures with
;; metadata that makes explicit what connections between players (and
;; groups of players) exist.

(library

 (board graph)

 (export game->graph
         graph->components
         policy-name->policy-def
         children-outside-component
         policy-name->causal-model
         policy-name->policy-goal)

 (import (board syntax)
         (rnrs)
         (scheme-tools)
         (scheme-tools graph)
         (scheme-tools graph components)
         (scheme-tools property)
         (scheme-tools srfi-compat :1))

 (define (graph:add-child!/unlabelled graph node child)
   (graph:add-child! graph node child child 1.0))

 ;; Go through all policy definitions, store in graph for each policy
 ;; names what other policy names it refers to ("opponents"). Store
 ;; complete definition of policy as a property associated with the
 ;; name.
 (define (game->graph game)
   (let ([graph (make-graph)])
     (for-each (lambda (policy-def)
                 (let ([policy-name (policy-def->policy-name policy-def)])
                   (graph:add-node! graph policy-name)
                   (set-property! policy-name 'policy-def policy-def)
                   (for-each (lambda (other-name)
                               (graph:add-child!/unlabelled graph policy-name other-name))
                             (policy-def->other-policy-names policy-def))))
               (game->policy-defs game))
     graph))

 ;; Return a list of strongly connected components of the game graph
 ;; in reverse topological order (i.e., if there is a link from A to
 ;; B, B comes first.)
 (define (graph->components graph)
   (strongly-connected-components graph))

 (define (policy-name->policy-def policy-name)
   (get-property policy-name 'policy-def))

 (define (policy-name->causal-model policy-name)
   (policy-def->causal-model-name (policy-name->policy-def policy-name)))

 (define (policy-name->policy-goal policy-name)
   (policy-def->goal-name (policy-name->policy-def policy-name)))

 (define (belongs-to-list x b)
   (cond ((null? b) #f)
         ((equal? x (first b)) #t)
         (else (belongs-to-list x (rest b)))))

 (define (list-difference a b)
   (cond ((null? a) '())
         ((belongs-to-list (first a) b) (list-difference (rest a) b))
         (else (pair (first a) (list-difference (rest a) b)))))

 (define (children-outside-component graph component policy-name)
   (let ([children (graph:children graph policy-name)])
     (list-difference children component)))

 )
