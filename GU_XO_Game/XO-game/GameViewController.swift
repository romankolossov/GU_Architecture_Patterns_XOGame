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
    
    private var positionsFirst: Array<GameboardPosition> = []
    private var positionsSecond: Array<GameboardPosition> = []
    
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
        
        //setFirstState()
        
        //ordinaryGame()
        setFirstStateFiveStepGame()
        fiveStepGame()
        
    }
    
    // MARK: - Major methods
    // MARK: - Ordinary game methods
    
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
    
    private func ordinaryGame() {
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
        }
    }
    
    // MARK: - FiveStepGame methods
    
    private func setFirstStateFiveStepGame() {
        let player: Player = .first
        
        currentState = FiveStepState(player: player, gameViewController: self, gameBoard: gameBoard, gameBoardView: gameboardView, markViewPrototype: player.markViewPrototype)
        
    }
    
    private func setNextStateFiveStepGame() {
        if let playerInputState = currentState as? FiveStepState {
            
            let player = playerInputState.player.next
            
            currentState = FiveStepState(player: player, gameViewController: self, gameBoard: gameBoard, gameBoardView: gameboardView, markViewPrototype: player.markViewPrototype)
        }
    }
    
    private func fiveStepGame() {
        var stepCounter: Int = 0
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            stepCounter += 1
            
            guard let playerInputState = self.currentState as? FiveStepState else { return }
            
            let player = playerInputState.player
            
            if player == .first {
                #if DEBUG
                print("hello from first")
                print(position)
                #endif
                self.positionsFirst.append(position)
            }
            else if player == .second {
                #if DEBUG
                print("hello from second")
                print(position)
                #endif
                self.positionsSecond.append(position)
                print(position)
            }
            
            if stepCounter == 5 && self.counter <= 1 {
                stepCounter = 0
                
                if self.counter < 1 {
                    self.setNextStateFiveStepGame()
                }
                self.counter += 1
            }
            else {
                if self.counter > 1 {
                    // place marks on the board with addMark() to determine a winner
                    self.setNextStateFiveStepGame()
                    
                    for position in self.positionsFirst {
                        self.currentState.addMark(at: position)
                    }
                    self.setNextStateFiveStepGame()
                    
                    for position in self.positionsSecond {
                        self.currentState.addMark(at: position)
                    }
                    // determine a winner
                    if let winner = self.referee.determineWinner() {
                        self.currentState = GameOverState(winner: winner, gameViewController: self)
                        return
                    }
                    self.gameBoard.clear()
                    
                    // put marks on the board just to show them correctly
                    for position in self.positionsFirst {
                        self.gameboardView.placeMarkView(XView(), at: position)
                    }
                    for position in self.positionsSecond {
                        self.gameboardView.placeMarkView(OView(), at: position)
                    }
                    // clear position storage
                    self.positionsFirst.removeAll()
                    self.positionsSecond.removeAll()
                }
            }
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

