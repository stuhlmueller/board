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
            (scheme-tools graph components)
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

 (define (get-children-knowledge children)
   (let* ((common-knowledge-graph (nodes->common-knowledge-graph children))
          (common-knowledge-graph-components (graph->components common-knowledge-graph)))
   (map (lambda (component)
          (let ((children-names (apply string-append (map readable-policy component))))
          (apply string-append (list " " children-names " think that " (get-player-common-knowledge (first component))))))
        common-knowledge-graph-components)))

 (define (nodes->graph nodes get-node-information)
   (let ([graph (make-graph)])
     (for-each (lambda (policy-name)
                 (let ([player-information (get-node-information policy-name)])
                   (graph:add-node! graph policy-name)
                   (for-each (lambda (other-name)
                               (if (and (not (equal? policy-name other-name)) (equal? player-information (get-node-information other-name)))
                                   (graph:add-child!/unlabelled graph policy-name other-name)))
                             nodes)))
               nodes)
     graph))

 (define (component->knowledge-graph component)
   (nodes->graph component get-player-knowledge))

 (define (nodes->common-knowledge-graph children)
   (nodes->graph children get-player-common-knowledge))

 (define (get-player-knowledge-content policy-name children-knowledge)
   (apply string-append `(" wants to "
                          ,(readable-goal (policy-name->policy-goal policy-name))
                          ;;use when there are non-trivial beliefs about world: " and believes that " ,(readable-causal-model (policy-name->causal-model policy-name))
                          ,(if (equal? children-knowledge (list ))
                               ""
                               (apply string-append `(" and believes that:" ,@children-knowledge))))))

 (define (set-player-knowledge policy-name graph component)
   (let* ([children (children-outside-component graph component policy-name)]
          [children-knowledge (get-children-knowledge children)]
          [player-knowledge-content (get-player-knowledge-content policy-name children-knowledge)])
     (set-property! policy-name 'player-knowledge player-knowledge-content)))

 (define (set-player-common-knowledge player-name component component-players)
   (let* ((knowledge-graph (component->knowledge-graph component))
          (knowledge-graph-components (graph->components knowledge-graph)))
     (if (equal? (length component) 1)
         (set-property! player-name 'player-common-knowledge
                        (get-player-knowledge player-name))
         (set-property! player-name 'player-common-knowledge
                        (apply string-append `("it is common knowledge among " ,component-players " that: "
                                               ,@(map (lambda (knowledge-component)
                                                        (let ((knowledge-component-players (apply string-append (map readable-policy knowledge-component)))
                                                              (knowledge-component-knowledge (get-player-knowledge (first knowledge-component))))
                                                          (apply string-append `(,knowledge-component-players ,knowledge-component-knowledge ", "))))
                                                      knowledge-graph-components)))))))

 (define (set-component-knowledge graph component)
   (let ((component-players (apply string-append (map readable-policy component))))
     (for-each (lambda (policy-name) (set-player-knowledge policy-name graph component))
               component)
     (for-each (lambda (player-name)
                 (set-player-common-knowledge player-name component component-players))
               component)))

 (define (set-game-knowledge game)
   (let* ([graph (game->graph game)]
          [components (graph->components graph)])
     (for-each (lambda (component) (set-component-knowledge graph component))
               components)))

 )
