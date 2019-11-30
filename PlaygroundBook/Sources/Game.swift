//
//  Game.swift
//  Book_Sources
//
//  Created by Hristo Staykov on 16.03.19.
//

import Foundation

public enum Player: String, Codable {
    /// Player X
    case x
    /// Player O
    case o
    /// The player's opponent -- i.e. the player who is next to play
    public func opponent() -> Player {
        return (self == .o) ? .x : .o
    }
}

public struct GameState: Codable {
    /// The nine squares in the game
    ///
    ///     .-----------.
    ///     | 0 | 1 | 2 |
    ///     |---+---+---|
    ///     | 3 | 4 | 5 |
    ///     |---+---+---|
    ///     | 6 | 7 | 8 |
    ///     `-----------'
    ///
    /// If no player has played in the square, its value is `nil`. Otherwise, its value is either `.x` or `.o`
    public var cells: [Player?] = [Player?](repeating: nil, count: 9)

    /// The indices of the squares that are not occupied
    public var emptyCells: [Int] {
        return cells.enumerated().compactMap({ (i, e) -> Int? in
            return e == nil ? i : nil
        })
    }
    /// The player whose turn it is
    public var currentPlayer: Player = .x

    /// Variable used for alpha-beta optimisation
    public var alpha: Int = Int.min + 1
    /// Variable used for alpha-beta optimisation
    public var beta: Int = Int.max - 1

    public init() {

    }

    /// A set of three squares occupied by the same player that win the board
    /// - Returns: The winning player, and an array of the indices that form a winning line / diagonal
    public func getWinningSquares() -> (Player, [Int])? {
        let winningCombinations: [[Int]] = [
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 4, 8], [2, 4, 6]
        ]
        for combination in winningCombinations {
            // If the first square in the combination is occupied
            if let firstIndex = combination.first, let player = self.cells[firstIndex] {
                // Chefk if all squares in the sequence are occupied by the same character
                let win = combination.reduce(true) { (result, index) -> Bool in
                    result && self.cells[index] == player
                }
                if win {
                    return (player, combination)
                }
            }
        }
        return nil
    }

    /// The result of the game
    public func result() -> GameOutcome {
        if let (player, _) = getWinningSquares() {
            return player == .x ? .xWin : .oWin
        }
        if cells.compactMap( {$0} ).count == 9 {
            return .tie
        }
        return .notFinished
    }
}

public enum GameOutcome: Equatable {
    /// X has won the game
    case xWin
    /// Y has won the game
    case oWin
    /// The game has finished in a tie
    case tie
    /// The game has yet to finish
    case notFinished
}
