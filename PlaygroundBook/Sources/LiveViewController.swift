//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  An auxiliary source file which is part of the book-level auxiliary sources.
//  Provides the implementation of the "always-on" live view.
//

import UIKit
import PlaygroundSupport

@objc(Book_Sources_LiveViewController)
public class LiveViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
    @IBOutlet weak var player1NameLabel: UILabel!
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var tiesLabel: UILabel!
    @IBOutlet weak var player2NameLabel: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    /// The symbol used to represent player X on the board
    var playerXSymbol = "❌" {
        didSet {
            player1NameLabel?.text = "Player X (\(playerXSymbol))"
        }
    }
    /// The symbol used to represent player Y on the board
    var playerOSymbol = "⭕️" {
        didSet {
            player2NameLabel?.text = "Player O (\(playerOSymbol))"
        }
    }
    /// How many times player X has won
    var playerXWins: Int = 0 {
        didSet {
            player1ScoreLabel?.text = "\(playerXWins)"
        }
    }
    /// How many times player Y has won
    var playerOWins: Int = 0 {
        didSet {
            player2ScoreLabel?.text = "\(playerOWins)"
        }
    }
    /// How many times there's been a tie
    var ties: Int = 0 {
        didSet {
            tiesLabel?.text = "\(ties)"
        }
    }

    /// The game currently being played
    public var game = GameState()

    /// The game that should appear when the playground starts running
    public var defaultGame = GameState()

    public var allowInteraction: Bool = true

    /// The nine squares in the game. Each one has a tag representing its position:
    /// 
    ///     .-----------.
    ///     | 0 | 1 | 2 |
    ///     |---+---+---|
    ///     | 3 | 4 | 5 |
    ///     |---+---+---|
    ///     | 6 | 7 | 8 |
    ///     `-----------'
    ///     
    var cells: [UILabel] = []

    /// Vertical stack view containing the squares for the board
    @IBOutlet weak var boardStackView: UIStackView!

    /// Possible background colours for the squares. With every turn, the game changes colour
    var colors = [#colorLiteral(red: 0.5477632284, green: 0.8051860929, blue: 0.7956534028, alpha: 1), 
        #colorLiteral(red: 0.6292808219, green: 0.6850652825, blue: 0.9686274529, alpha: 1), 
        #colorLiteral(red: 0.5450980663, green: 0.8170558074, blue: 0.9568627477, alpha: 1), 
        #colorLiteral(red: 0.3787739625, green: 0.6374718377, blue: 0.8597228168, alpha: 1), 
        #colorLiteral(red: 0.7864241635, green: 0.7246192779, blue: 0.9372056935, alpha: 1)]

    /// Current background color for the squares
    var currentColor = #colorLiteral(red: 0.5477632284, green: 0.8051860929, blue: 0.7956534028, alpha: 1)
    
    public override func viewDidLoad() {
        if let emojiMessage = PlaygroundKeyValueStore.current["emoji"] {
            self.receive(emojiMessage)
        }

        // Create a UILabel for each square on the board
        for y in 0..<3 {
            // Create three UILabels to represent the cells
            let labels: [UILabel] = (3*y..<3*y+3).map{
                tag -> UILabel in
                let lbl = UILabel()
                lbl.tag = tag
                lbl.layer.cornerRadius = 16
                lbl.layer.masksToBounds = true
                lbl.backgroundColor = .clear            // We use layer.backgroundColor since it's animatable
                lbl.textAlignment = .center
                if #available(iOS 11.0, *) {
                    lbl.font = UIFont.preferredFont(forTextStyle: .largeTitle)
                }

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(sender:)))
                lbl.addGestureRecognizer(tapGesture)
                lbl.isUserInteractionEnabled = true
                return lbl
            }
            cells += labels
            // Create a horizontal stack view containing the new cells and append it to the board
            let row = UIStackView(arrangedSubviews: labels)
            row.distribution = .fillEqually
            row.axis = .horizontal
            row.spacing = boardStackView.spacing
            row.alignment = .fill
            boardStackView.addArrangedSubview(row)
        }
        self.view.backgroundColor = #colorLiteral(red: 0.25, green: 0.3875517996, blue: 0.5, alpha: 1)
        self.updateLabels()
        for cell in self.cells {
            cell.layer.backgroundColor = self.currentColor.cgColor
            cell.alpha = 1
        }
    }


    public func updateLabels() {
        for cell in self.cells {
            let val = game.cells[cell.tag]
            cell.text = val == .x ? playerXSymbol : val == .o ? playerOSymbol : ""
        }
        switch game.result() {
        case .xWin:
            infoLabel.text = "\(playerXSymbol) wins!"
        case .oWin:
            infoLabel.text = "\(playerOSymbol) wins!"
        case .tie:
            infoLabel.text = "Tie!"
        case .notFinished:
            let playerSymbol = game.currentPlayer
            if allowInteraction {
                infoLabel.text = "\(playerSymbol == .x ? playerXSymbol : playerOSymbol)'s move"
            } else {
                infoLabel.text = "Waiting for \(playerSymbol == .x ? playerXSymbol : playerOSymbol) to play..."
            }
        }
    }
    func changeColor() {
        let newColor = colors.filter { $0 != currentColor }.randomElement() ?? currentColor
        currentColor = newColor
    }
    @objc func cellTapped(sender: UITapGestureRecognizer) {
        guard game.result() == .notFinished else {
            restart()
            return
        }
        guard let tappedCell = sender.view as? UILabel else { return }
        let tag = tappedCell.tag
        play(move: tag, faux: !allowInteraction)
        if allowInteraction {
            self.send(game.playgroundValue!)
        }
    }
    func play(move: Int, faux: Bool = false) {
        if game.cells[move] == nil && !faux {
            changeColor()
            game.cells[move] = game.currentPlayer
            game.currentPlayer = game.currentPlayer.opponent()
            updateLabels()
        }
        self.cells[move].alpha = 0
        if let (_, winningSequence) = self.game.getWinningSquares() {
            UIView.animate(withDuration: 0.3, animations: {
                for cell in self.cells {
                    cell.layer.backgroundColor = self.currentColor.cgColor
                    cell.alpha = 1
                    cell.alpha = winningSequence.contains(cell.tag) ? 1 : 0.5
                }
            })
        } else {
            for cell in self.cells {
                let deltaX = abs(move % 3 - cell.tag % 3)
                let deltaY = abs(move / 3 - cell.tag / 3)
                let delay = 0.07 * sqrt(Double((deltaX * deltaX + deltaY * deltaY)))
                UIView.animate(withDuration: 0.3, delay: delay, options: [], animations: {
                    cell.layer.backgroundColor = self.currentColor.cgColor
                    cell.alpha = 1
                })
            }
        }
    }

    func restart() {
        switch game.result() {
        case .xWin:
            playerXWins += 1
        case .oWin:
            playerOWins += 1
        case .tie:
            ties += 1
        case.notFinished:
            return
        }
        changeColor()
        game = GameState()
        updateLabels()
        UIView.animate(withDuration: 0.3, animations: {
            for cell in self.cells {
                cell.layer.backgroundColor = self.currentColor.cgColor
                cell.alpha = 1
            }
        })
    }

    public func liveViewMessageConnectionOpened() {
        // Implement this method to be notified when the live view message connection is opened.
        // The connection will be opened when the process running Contents.swift starts running and listening for messages.
        self.game = self.defaultGame
        self.allowInteraction = true
        self.updateLabels()
        self.changeColor()
        UIView.animate(withDuration: 0.3, animations: {
            for cell in self.cells {
                cell.layer.backgroundColor = self.currentColor.cgColor
                cell.alpha = 1
            }
        })
    }


    public func liveViewMessageConnectionClosed() {
        // Implement this method to be notified when the live view message connection is closed.
        // The connection will be closed when the process running Contents.swift exits and is no longer listening for messages.
        // This happens when the user's code naturally finishes running, if the user presses Stop, or if there is a crash.
    }

    public func receive(_ message: PlaygroundValue) {
        // Implement this method to receive messages sent from the process running Contents.swift.
        // This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
        // Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
        if let emojiMessage = ChangeEmojiMessage(playgroundValue: message) {
            self.playerOSymbol = emojiMessage.oEmoji
            self.playerXSymbol = emojiMessage.xEmoji
            self.updateLabels()
        }
        if let interactionMessage = StartStopMessage(playgroundValue: message) {
            self.allowInteraction = interactionMessage.canInteract
            self.updateLabels()
        }

        switch message {
        case .integer(let nextMove):
            play(move: nextMove)
            self.send(game.playgroundValue!)
        default:
            ()
        }
    }



    // MARK: Parallax effect
    // Create a visual effect similar to when an Apple TV users moves their finger over a selection and it
    // changes transform. Code recycled from Amaziograph

    
    lazy var parallaxAnimator: UIViewPropertyAnimator = {
        let cubicParameters = UICubicTimingParameters(controlPoint1: CGPoint(x: 0, y: 0.5), controlPoint2: CGPoint(x: 1.0, y: 0.5))
        let animator = UIViewPropertyAnimator(duration: 0.2, timingParameters: cubicParameters)
        animator.isInterruptible = true
        return animator
    }()
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            self.setCellFocusEffect(touch: touch, animated: false)
        }

    }
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            self.setCellFocusEffect(touch: touch)
        }
    }
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        removeCellFocusEffect()
    }
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        removeCellFocusEffect()
    }
    func setCellFocusEffect(touch: UITouch, animated: Bool = true) {
        func setTransformations() {
            for cell in self.cells {
                let touchLocation = touch.location(in: cell)
                let containsTouch = cell.bounds.insetBy(dx: -0, dy: -0).contains(touchLocation)
                if containsTouch {
                    let x = 2 * touchLocation.x / cell.bounds.width - 1
                    let y = 2 * touchLocation.y / cell.bounds.height - 1
                    let xRotation: CGFloat = min(max(y, -1), 1) * .pi/10
                    let yRotation: CGFloat = min(max(x, -1), 1) * .pi/10
                    let scale: CGFloat = 0.95
                    var perspective = CATransform3DIdentity
                    perspective.m34 = -1 / 1000

                    perspective = CATransform3DRotate(perspective, -xRotation, 1, 0, 0)
                    perspective = CATransform3DRotate(perspective, yRotation, 0, 1, 0)
                    perspective = CATransform3DScale(perspective, scale, scale, scale)
                    cell.layer.transform = perspective
                    cell.layer.anchorPointZ = -10
                } else {
                    cell.layer.transform = CATransform3DIdentity
                }
            }
        }
        if parallaxAnimator.isRunning {
            parallaxAnimator.stopAnimation(true)
        }
        if animated {
            parallaxAnimator.addAnimations {
                setTransformations()
            }
            parallaxAnimator.startAnimation()
        } else {
            setTransformations()
        }
    }
    func removeCellFocusEffect() {
        if parallaxAnimator.isRunning {
            parallaxAnimator.stopAnimation(true)
        }
        parallaxAnimator.addAnimations {
            for cell in self.cells {
                cell.layer.transform = CATransform3DIdentity
            }
        }
        parallaxAnimator.startAnimation()
    }
}
