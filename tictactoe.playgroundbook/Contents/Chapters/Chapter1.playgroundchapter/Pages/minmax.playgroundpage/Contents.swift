//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
import PlaygroundSupport
import Dispatch
PlaygroundPage.current.needsIndefiniteExecution = true

guard let remoteView = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
    fatalError("Always-on live view not configured in this page's LiveView.swift.")
}

let handler = MessageHandler()
remoteView.delegate = handler

/**
 Given a game, decide which is the best move that would let us entually win, or, at least, tie
 - Returns: `(move: Int, score: Int)`, where `move` is the move that works best, and `score` is an integer related to how good the move is: 10 if it leads to winning, 0 if it leads to a tie, and -10 if it leads to a loss.
 */
//#-end-hidden-code
/*:
 # Almost there!
 Consider the following scenario:

     O's turn:
     .-----------.
     |   |   | X |
     |---+---+---|
     |   | X |   |
     |---+---+---|
     |   |   | O |
     `-----------'

 If we don't play the lower left square, then our opponent would be able to win at the next move!

 Clearly, we should put more thought into chosing a square. That's why the function on this
 page is slightly different -- read along with the code and fill in the gaps!


 */
func play(game: GameState) ->
    (move: Int, score: Int) {
/*:
 - Note: Now, along with the move, we return a score that shows us how
 good our move is: 10 points if it leads to winning, 0 points if it leads a tie, and -10 points if it leads to losing.

 */
//#-hidden-code
        // Hidden code for alpha-beta optimisation
        var alpha = game.alpha
        var beta = game.beta
        /// Whether to not recurse in case we eventually come across a terminal node
        var skipRecursion = false
        for option in game.emptyCells {
            var newGame = game
            newGame.cells[option] = game.currentPlayer
            switch newGame.result() {
            case .oWin, .xWin, .tie:
                skipRecursion = true
            case .notFinished:
                // Don't do anything if we're not finished
                ()
            }
        }
//#-end-hidden-code
        // A list to keep track of possible moves
        var moves: [(move: Int, score: Int)] = []

        // For every possible move:
        for move in game.emptyCells {
            var newGame = game
            newGame.cells[move] = game.currentPlayer

            switch newGame.result() {
            case .oWin, .xWin:
                // Playing at square `move` would let us win
/*:
 * Callout(Your task):
 Look up the note above and fill the appropriate score in!
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, -10, 0, 10)
                return (move: move, score: /*#-editable-code*/<#T##score##Int#>/*#-end-editable-code*/)
            case .tie:
                // The game ends in a tie
/*:
 * Callout(Your task):
 Look up the note above and fill the appropriate score in!
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, -10, 0, 10)
                return (move: move, score: /*#-editable-code*/<#T##score##Int#>/*#-end-editable-code*/)
            case .notFinished:
//#-hidden-code
                // Alpha-beta optimisation
                if beta < alpha || skipRecursion { continue }
                newGame.alpha = -beta
                newGame.beta = -alpha
//#-end-hidden-code
                newGame.currentPlayer = game.currentPlayer.opponent()
/*:
Let's calculate a score for this move before putting it in the list!

When we play, we don't take risks. That's why we always assume the opponent will take the
move that works best for them.

How do we know what move the opponent will made? Simple: since we always take the
best move, it's the same move we would make if we were in their position.

 Then, we look at the score of that move: if it's good for them, it's bad for us. Conversely, if it's bad for them, it's good for us!

 * Callout(Your task):
In the field below, calculate the negative of the score the opponent would get. That is, you need to call `play(game: )` with `newGame`, get the score (`.score`) and negate the whole expression by putting a minus sign in front.
 */
//#-code-completion(everything, hide)
//#-code-completion(everything, show, -)
//#-code-completion(identifier, show, play(game:), newGame, ., score)
                let score: Int = /*#-editable-code*//*#-end-editable-code*/

                moves.append((move: move, score: score))
//#-hidden-code
                alpha = max(alpha, score)
//#-end-hidden-code
            }
        }
        // Return the move with the highest score
        return moves.max { $0.score < $1.score }!
}


/*:
 Congratulations! You're done!  Now, tap "Run My Code" and see if you can beat your iPad
 */
//#-hidden-code
handler.handler = { game -> Int? in
    return play(game: game).move
}
handler.updateHandler = { game -> Void in
    if game.result() == .oWin || game.result() == .tie {
        PlaygroundPage.current.assessmentStatus = .pass(message: "Good job! Move on to the [next page](@next)")
    } else if game.result() == .xWin {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Oops, you shouldn't be able to win against this algorithm! Go back to check your code or check the answer key or the next page"], solution: nil)
    }
}
//#-end-hidden-code
