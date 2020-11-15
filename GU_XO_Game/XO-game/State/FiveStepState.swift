//
//  FiveStepState.swift
//  XO-game
//
//  Created by Роман Колосов on 15.11.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class FiveStepState: GameState {
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
            gameViewController?.firstPlayerTurnLabel.text = "1st filling marks"
            gameViewController?.secondPlayerTurnLabel.isHidden = true
            gameViewController?.winnerLabel.isHidden = false
            gameViewController?.winnerLabel.text = "Keep pressing on the board"
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.text = "2nd filling marks"
            gameViewController?.winnerLabel.isHidden = false
            gameViewController?.winnerLabel.text = "Keep pressing on the board"
        case .firstAgainstComputer:
            return
        case .computer:
            return
        }
    }
    
    func addMark(at position: GameboardPosition) {
        Log(action: .playerSetMark(player: player, position: position))
        
        guard let gameBoardView = gameBoardView
        //gameBoardView.canPlaceMarkView(at: position)
        else { return }
        
        gameBoard?.setPlayer(player, at: position)
        gameBoardView.placeMarkView(markViewPrototype.copy(), at: position)
        //isMoveCompleted = true
    }
}


