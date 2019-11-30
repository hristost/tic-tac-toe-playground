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
 # First steps

 Each square is represented by a number. Your goal is, given the state of the game, find the number for the best possible move.

      .-----------.
      | 0 | 1 | 2 |
      |---+---+---|
      | 3 | 4 | 5 |
      |---+---+---|
      | 6 | 7 | 8 |
      `-----------'

 The function below gets called every time the robot is about to play and returns the number of the best square.
 Your robot will play as player O. Normally, player X plays first, so we are giving advantage to the human opponent!

 Let's start by implementing a simple strategy: return any square that is free

 */

func play(game: GameState) -> Int? {
    // Indices of the squares that are still free
    let possibleMoves: [Int]
    possibleMoves = game.emptyCells
/*:
 * Callout(Your task):
 Return any element of `possibleMoves`. Feel free to use `possibleMoves.randomElement()` or simply always return the first element
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, possibleMoves, ., [Int], min(), max(), randomElement())
    return /*#-copy-source(random)*//*#-editable-code*/ /*#-end-editable-code*//*#-end-copy-source*/
}

/*:
 Now, tap "Run My Code" and play a game. Congratulations, you just programmed your iPad to play against you! However,
 by playing randomly we miss some good opportunities to win -- learn how to seize them on the [next page](@next)
 */
//#-hidden-code
var played = false
handler.updateHandler = { game -> Void in
    if played {
        PlaygroundPage.current.assessmentStatus = .pass(message: "Good move! Move to the [next page](@next) to learn how to make your algorithm more clever")
    }
}
handler.handler = { game -> Int? in
    if let move = play(game: game) {
        played = true
        return move
    }
    return nil
}
//#-end-hidden-code
