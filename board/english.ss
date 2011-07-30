#!r6rs

(library

 (board english)

 (export set-game-knowledge
         get-player-knowledge)

 (import    (rnrs)
            (board)
            (board syntax)
            (board graph)
            (scheme-tools)
            (scheme-tools property)
            (scheme-tools graph)
            (scheme-tools graph utils)
            (scheme-tools srfi-compat :1))

 (define (readable-policy policy-name)
   (get-property policy-name 'readable-name))

 (define (readable-goal goal-name)
   (get-property goal-name 'readable-name))

 (define (readable-causal-model causal-model-name)
   (get-property causal-model-name 'readable-name))

 (define (get-player-knowledge policy-name)
   (get-property policy-name 'player-knowledge))

 (define (get-player-common-knowledge policy-name)
   (get-property policy-name 'player-common-knowledge))

 (define (set-player-knowledge policy-name graph component)
   (let* ([children (children-outside-component graph component policy-name)]
          [children-knowledge
           (map (lambda (child-name)
                  (apply string-append (list " " (readable-policy child-name) " thinks that " (get-player-common-knowledge child-name))))
                children)])
     (set-property! policy-name 'player-knowledge (apply string-append `(,(readable-policy policy-name)
                                                                         " wants to " ,(readable-goal (policy-name->policy-goal policy-name))
                   ;;use when there are non-trivial beliefs about world: " and believes that " ,(readable-causal-model (policy-name->causal-model policy-name))
                                                                         ,(if (equal? children-knowledge (list ))
                                                                              ""
                                                                              (apply string-append `(" and believes that:" ,@children-knowledge))))))))

 (define (set-component-knowledge graph component)
   (let ((component-players (apply string-append (map readable-policy component))))
     (for-each (lambda (policy-name) (set-player-knowledge policy-name graph component))
               component)
     (for-each (lambda (player-name) (set-property! player-name 'player-common-knowledge
                                                    (apply string-append `("it is common knowledge among " ,component-players " that: "
                                                                           ,@(map (lambda (player-name)
                                                                                    (apply string-append `(,(get-player-knowledge player-name) ", ")))
                                                                                  component)))))
               component)))

 (define (set-game-knowledge game)
   (let* ([graph (game->graph game)]
          [components (graph->components graph)])
     (for-each (lambda (component) (set-component-knowledge graph component))
               components)))

 )
