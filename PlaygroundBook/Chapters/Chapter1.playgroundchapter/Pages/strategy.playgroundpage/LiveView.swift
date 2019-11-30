//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Instantiates a live view and passes it to the PlaygroundSupport framework.
//

import UIKit
import PlaygroundSupport

// Instantiate a new instance of the live view from the book's auxiliary sources and pass it to PlaygroundSupport.
let board = instantiateLiveView()
board.game.cells = [.x, nil, nil, nil, .x, .o, nil, nil, .o]
board.defaultGame.cells = [.x, nil, nil, nil, .x, .o, nil, nil, .o]
PlaygroundPage.current.liveView = board
