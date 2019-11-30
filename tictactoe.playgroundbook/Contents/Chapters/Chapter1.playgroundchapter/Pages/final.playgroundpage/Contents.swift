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
//#-end-hidden-code
/*:
# Congratulations! You just coded an unbeatable noughts and crosses AI! 🎉

This algorithm is also known as the *Min-max algorithm* in Game Theory. The name refers to minimising the
maximum possible loss. By playing in this way, our algorithm is unbeatable!

The Min-max algorithm can be opitmised and adapted for many other games, and is an important decision-making rule in game theory and artifical intelligence. If you want to learn more, feel free to google "zero-sum games".

Thanks for following along!


 */
func play(game: GameState) ->
    (move: Int, score: Int) {
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
                return (move: move, score: /*#-editable-code*/10/*#-end-editable-code*/)
            case .tie:
                // The game ends in a tie
                return (move: move, score: /*#-editable-code*/0/*#-end-editable-code*/)
            case .notFinished:
//#-hidden-code
                // Alpha-beta optimisation
                if beta < alpha || skipRecursion { continue }
                newGame.alpha = -beta
                newGame.beta = -alpha
//#-end-hidden-code
                newGame.currentPlayer = game.currentPlayer.opponent()
                let score: Int = /*#-editable-code*/-play(game: newGame).score/*#-end-editable-code*/

                moves.append((move: move, score: score))
//#-hidden-code
                alpha = max(alpha, score)
//#-end-hidden-code
            }
        }
        // Return the move with the highest score
        return moves.max { $0.score < $1.score }!
}


//#-hidden-code
handler.handler = { game -> Int? in
    return play(game: game).move
}
//#-end-hidden-code
