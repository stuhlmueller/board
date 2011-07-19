# Board

Board is a thin layer of syntactic sugar on top of [Church](http://projects.csail.mit.edu/church/) and [Cosh](https://github.com/stuhlmueller/cosh) that makes it easy to represent and solve simple coordination games. Board ...

- separates the definition of games from the solution method 
- enforces factorization of policies into goal predicates and world models
- allows computing the policies for all players simultaneously

## Installation

1. Install [cosh](https://github.com/stuhlmueller/cosh).
2. Check out board: `git clone git://github.com/stuhlmueller/board.git`
3. Add the board directory to your `$VICARE_LIBRARY_PATH`.

## Example

This is an example of how to use board to compute policies for a simple coordination game. We model the following situation:

> John and Jim agreed to meet at a bar, but did not specify which of two bars to go to, the popular bar or the  unpopular bar. John wants to meet Jim. Jim doesn't want to meet John, but John doesn't know this. Which bar will John and Jim  choose?

    #!r6rs
    
    (import (board)
            (rnrs))
    
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
    
    (run-game bar-game
              (recursion-solver 5 2))

Running the above code in [Ikarus Scheme](http://ikarus-scheme.org/) or [Vicare Scheme](https://github.com/marcomaggi/vicare) results in the following output:

    jim-1
      other-bar: 0.9999999999878807
      popular-bar: 1.2087651728459907e-11
    
    jim-0
      other-bar: 8.058434485672552e-12
      popular-bar: 0.9999999999919361
    
    john-0
      other-bar: 8.058434485672552e-12
      popular-bar: 0.9999999999919361

For more examples, see the `examples/` directory.

## Syntax

The template for a simple board game looks like this:

    #!r6rs
    
    (import (board) 
            (rnrs))
    
    (define my-game 
      (make-game [game-definition]))
      
    (run-game my-game [solver])

A **game definition** is a list of policy definitions and definitions of arbitrary other variables and functions that are used within the policies.

A **policy definition** has the following form:

    (define (policy-name)
      (solve goal
             world
             policies
             action-prior))

The arguments to `solve` must satisfy the following interface:

- `goal` is a function that takes as input a state and returns a Boolean depending on whether the state satisfies the goal.
- `world` is a function that takes as input an action for the current player (first argument) and for the other players (remaining arguments) and returns a state.
- `policies` is a list of all players (policies) that the current player interacts with. This specifies the order of the remaining arguments to `world`.
- `action-prior` is optional. If given, it is a thunk that returns an action. If not given, actions will be sampled uniformly from the list referenced by the variable `actions`.

Currently, the only supported **solver** is `recursion-solver`. It takes two arguments, `depth` of recursion and `hardness` of the conditions (optimization strength).
