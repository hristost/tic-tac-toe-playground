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

 # Teach your iPad to play tic-tac-toe!

 (Hristo Staykov, hristo.staykov@gmail.com)

 Hello! In this playground you will program a robot to play against you in a game of noughts and crosses! In the process,
 you will learn about a popular algorithm in game theory.


 - Note:
 First, a refresher:
 Noughts and crosses is a game played on a 3x3 square grid. Two players (X and O) alternate placing their marks in empty
 squares. A player wins the game when they have a row, column, or a diagonal of the grid filled with their marks. If all
 nine squares get full without anyone winning, the game ends in a tie.
 */
// The symbol used to represent player X
var playerXSymbol: Character = /*#-editable-code*/"❌"/*#-end-editable-code*/
// The symbol used to represent player O (this will be the robot!)
var playerOSymbol: Character = /*#-editable-code*/"⭕️"/*#-end-editable-code*/
/*:
 - Experiment: 
 Feel free to change the emojis used for X and O: edit the lines below with two of your favourite emojis, and then tap "Run My Code".
 */
/*:
 Ready to begin coding? Go to the [next page](@next)!
*/
//#-hidden-code
if let message = ChangeEmojiMessage(x: playerXSymbol, o: playerOSymbol).playgroundValue {
    remoteView.send(message)
    PlaygroundKeyValueStore.current["emoji"] = message

}
handler.updateHandler = { game -> Void in
    if game.result() != .notFinished {
        PlaygroundPage.current.assessmentStatus = .pass(message: "Enough playing 😛 Move on to the [next page](@next) to start coding")
    }
}
//#-end-hidden-code
