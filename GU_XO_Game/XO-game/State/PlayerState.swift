//
//  PlayerState.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 11/6/20.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class PlayerState: GameState {
    var isMoveCompleted: Bool = false
    
    public let player: Player
    private weak var gameViewController: GameViewController?
    private weak var gameBoard: Gameboard?
    private weak var gameBoardView: GameboardView?
    
    public let markViewPrototype: MarkView
    
    init(player: Player, gameViewController: GameViewController,
         gameBoard: Gameboard, gameBoardView: GameboardView, markViewPrototype: MarkView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameBoard = gameBoard
        self.gameBoardView = gameBoardView
        self.markViewPrototype = markViewPrototype
    }
    
    func begin() {
        switch player {
        
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.firstPlayerTurnLabel.text = "1st player's turn"
            gameViewController?.secondPlayerTurnLabel.isHidden = true
            gameViewController?.winnerLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.text = "2nd player's turn"
            gameViewController?.winnerLabel.isHidden = true
        case .firstAgainstComputer:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.firstPlayerTurnLabel.text = "Your turn"
            gameViewController?.secondPlayerTurnLabel.isHidden = true
            gameViewController?.winnerLabel.isHidden = true
        case .computer:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.text = "Computer's turn"
            gameViewController?.winnerLabel.isHidden = false
            gameViewController?.winnerLabel.text = "Please, press on the board"
        }
    }
    
    func addMark(at position: GameboardPosition) {
        Log(action: .playerSetMark(player: player, position: position))
        
        guard let gameBoardView = gameBoardView, gameBoardView.canPlaceMarkView(at: position) else {
            return
        }
        //Before Prototype
        
//        let markView: MarkView
//
//        switch player {
//        case .first:
//            markView = XView()
//        case .second:
//            markView = OView()
//        }
//
        gameBoard?.setPlayer(player, at: position)
        gameBoardView.placeMarkView(markViewPrototype.copy(), at: position)
        isMoveCompleted = true
    }
}
