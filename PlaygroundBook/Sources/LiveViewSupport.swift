//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import UIKit
import PlaygroundSupport

/// Instantiates a new instance of a live view.
///
/// By default, this loads an instance of `LiveViewController` from `LiveView.storyboard`.
public func instantiateLiveView() -> LiveViewController {
    let storyboard = UIStoryboard(name: "LiveView", bundle: nil)

    guard let viewController = storyboard.instantiateInitialViewController() else {
        fatalError("LiveView.storyboard does not have an initial scene; please set one or update this function")
    }

    guard let liveViewController = viewController as? LiveViewController else {
        fatalError("LiveView.storyboard's initial scene is not a LiveViewController; please either update the storyboard or this function")
    }

    return liveViewController
}

public class MessageHandler: PlaygroundRemoteLiveViewProxyDelegate {
    public init() {

    }
    public var handler: ((GameState) -> Int?)?
    public var updateHandler: ((GameState) -> Void)?
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {}
    public func remoteLiveViewProxy( _ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        print("Received a message from the always-on live view", message)
        if let game = GameState(playgroundValue: message) {
            if game.result() == .notFinished {
                if game.currentPlayer == .o {
                    remoteLiveViewProxy.send(StartStopMessage(allowInteraction: false).playgroundValue!)
                    if let nextMove = handler?(game) {
                        remoteLiveViewProxy.send(PlaygroundValue.integer(nextMove))
                    }
                    remoteLiveViewProxy.send(StartStopMessage(allowInteraction: true).playgroundValue!)
                }
            }
            updateHandler?(game)
        }
    }
}

public extension GameState {
    public init?(playgroundValue: PlaygroundValue) {
        guard case let .data(data) = playgroundValue else {
                return nil
        }
        if let game = try? JSONDecoder().decode(GameState.self, from: data) {
            self = game
        } else {
            return nil
        }
    }
    var playgroundValue: PlaygroundValue? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return PlaygroundValue.data(data)
    }
}

public struct ChangeEmojiMessage: Codable {
    var xEmoji: String
    var oEmoji: String
    public init(x: Character, o: Character) {
        self.xEmoji = "\(x)"
        self.oEmoji = "\(o)"
    }
    public init(x: String, o: String) {
        self.xEmoji = x
        self.oEmoji = o
    }
    public init?(playgroundValue: PlaygroundValue) {
        guard case let .data(data) = playgroundValue else {
            return nil
        }
        if let game = try? JSONDecoder().decode(ChangeEmojiMessage.self, from: data) {
            self = game
        } else {
            return nil
        }
    }
    public var playgroundValue: PlaygroundValue? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return PlaygroundValue.data(data)
    }
}

public struct StartStopMessage: Codable {
    var canInteract: Bool
    public init(allowInteraction: Bool) {
        self.canInteract = allowInteraction
    }
    public init?(playgroundValue: PlaygroundValue) {
        guard case let .data(data) = playgroundValue else {
            return nil
        }
        if let game = try? JSONDecoder().decode(StartStopMessage.self, from: data) {
            self = game
        } else {
            return nil
        }
    }
    public var playgroundValue: PlaygroundValue? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return PlaygroundValue.data(data)
    }
}
