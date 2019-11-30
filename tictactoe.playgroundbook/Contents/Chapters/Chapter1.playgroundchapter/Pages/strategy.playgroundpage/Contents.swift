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
 # A simple strategy

 Consider the following scenario:

     O's turn:
     .-----------.
     | X |   |   |
     |---+---+---|
     |   | X | O |
     |---+---+---|
     | X |   | O |
     `-----------'

 Clearly, it is best if O plays in the upper right corner and win. However, if we play
 randomly, we would miss that opportunity!

 Let's modify our function to seize such opportunities: if we find a square that would score a win, return it without considering the remaining options.

 */

func play(game: GameState) -> Int? {
    // Indices of the squares that are still free
    var possibleMoves: [Int] = []
    // For every possible move:
    for move in game.emptyCells {
        // What the game would look like if we played that move
        var newGame = game
        newGame.cells[move] = game.currentPlayer
        // Check the result of that hypothetical game
        switch newGame.result() {
        case .oWin, .xWin:
/*:
* Callout(Your task):
We know that playing at square `move` would let us win. Return that variable!
*/
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, return, move)
            //#-editable-code

            //#-end-editable-code
        case .tie:
            // If the game ends in a tie, we have no other options but play in the only remaining square
            return move
        case .notFinished:
            possibleMoves.append(move)

        }
    }

    return /*#-editable-code*//*#-copy-destination("random", random)*/ /*#-end-copy-destination*//*#-end-editable-code*/
}


/*:
 Now, tap "Run My Code" and play your move. Do not play in the upper right -- let the iPad win!
 */
//#-hidden-code
handler.handler = { game -> Int? in
    return play(game: game)
}
handler.updateHandler = { game -> Void in
    if game.result() == .oWin {
        PlaygroundPage.current.assessmentStatus = .pass(message: "Good job! Move on to the [next page](@next)")
    } else if game.result() == .xWin || game.result() == .tie {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["When you play, let player O win!",
            "If player O does not play, look over your code!"], solution: nil)
    }
}
//#-end-hidden-code
