//
//  GameOverViewModel.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 04/09/2021.
//

import Foundation

protocol GameOverViewModelCoordinatorDelegate: class {
    func gameOverStartGameButtonTapped()
    func gameOverGotoMainScreenButtonTapped()
}

protocol GameOverViewDelegate: class {
    
}

class GameOverViewModel {
    weak var coordinatorDelegate: GameOverViewModelCoordinatorDelegate?
    weak var viewDelegate: GameOverViewDelegate?
    var finalScore: Int
    
    init(finalScore: Int) {
        self.finalScore = finalScore
    }
    
    func startGameButtonTapped() {
        print("startGameButtonTapped VM")
        coordinatorDelegate?.gameOverStartGameButtonTapped()
    }
    
    func gotoMainScreenButtonTapped() {
        print("gotoMainScreenButtonTapped VM")
        coordinatorDelegate?.gameOverGotoMainScreenButtonTapped()
    }
}
