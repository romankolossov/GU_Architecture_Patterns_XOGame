//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // Some properties
    private let gameBoard = Gameboard()
    private lazy var referee = Referee(gameboard: gameBoard)
    private var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    private var counter: Int = 0
    
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet weak var gameSegmentControl: UISegmentedControl!

    private var selectedGame: Game {
        switch gameSegmentControl.selectedSegmentIndex {
        case 0:
            return .normal
        case 1:
            return .withComputer
        case 2:
            return .computerBegins
        default:
            return .normal
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            
            var boardPosition: GameboardPosition = position
            
            self.counter += 1
            
            guard let playerInputState = self.currentState as? PlayerState else { return }
            
            let player = playerInputState.player
            
            if player == .computer {
                guard let gameBoardView = self.gameboardView else { return }
                
                repeat {
                    let randomColumn = Int.random(in: 0...2)
                    let randomRow = Int.random(in: 0...2)
                    
                    boardPosition = GameboardPosition(column: randomColumn, row: randomRow)
                } while !gameBoardView.canPlaceMarkView(at: boardPosition)
            }
            
            self.currentState.addMark(at: boardPosition)
            if self.currentState.isMoveCompleted {
                self.setNextState()
            }
            
            //            self.gameboardView.placeMarkView(XView(), at: position)
        }
    }
    
    // MARK: - Major methods
    
    private func setFirstState() {
        var player: Player
        
        switch selectedGame {
        case .normal:
            player = Player.first
        case .withComputer:
            player = Player.firstAgainstComputer
        case .computerBegins:
            player = Player.computer
        }
        
        currentState = PlayerState(player: player, gameViewController: self,
                                   gameBoard: gameBoard, gameBoardView: gameboardView,
                                   markViewPrototype: player.markViewPrototype)
    }
    
    private func setNextState() {
        if let winner = referee.determineWinner() {
            currentState = GameOverState(winner: winner, gameViewController: self)
            return
        }
        
        if counter >= 9 {
            currentState = GameOverState(winner: nil, gameViewController: self)
            return
        }
        
        if let playerInputState = currentState as? PlayerState {
            let player = playerInputState.player.next
            currentState = PlayerState(player: playerInputState.player.next, gameViewController: self,
                                       gameBoard: gameBoard, gameBoardView: gameboardView,
                                       markViewPrototype: player.markViewPrototype)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Log(action: .restartGame)
        
        gameboardView.clear()
        gameBoard.clear()
        setFirstState()
        counter = 0
    }
}

