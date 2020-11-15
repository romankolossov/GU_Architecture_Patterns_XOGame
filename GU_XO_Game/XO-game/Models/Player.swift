//
//  Player.swift
//  XO-game
//
//  Created by Evgeny Kireev on 26/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

public enum Player: CaseIterable {
    case first
    case second
    case firstAgainstComputer
    case computer
    
    var next: Player {
        switch self {
        case .first: return .second
        case .second: return .first
        case .firstAgainstComputer: return .computer
        case .computer: return .firstAgainstComputer
        }
    }
    
    var markViewPrototype: MarkView {
        switch self {
        case .first:
            return XView()
        case .second:
            return OView()
        case .firstAgainstComputer:
            return XView()
        case .computer:
            return OView()
        }
    }
}
