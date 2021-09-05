//
//  GameOverCoordinator.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 04/09/2021.
//

import UIKit

class GameOverCoordinator: Coordinator {
    
    let presenter: UINavigationController
    var gameOverViewModel: GameOverViewModel?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func performGameOver(finalScore: Int) {
        let gameOverViewModel = GameOverViewModel(finalScore: finalScore)
        let gameOverViewController = GameOverViewController(viewModel: gameOverViewModel)
        gameOverViewModel.viewDelegate = gameOverViewController
        gameOverViewModel.coordinatorDelegate = self
        self.gameOverViewModel = gameOverViewModel
        presenter.pushViewController(gameOverViewController, animated: false)
    }
    
    override func finish() {}
}

extension GameOverCoordinator: GameOverViewModelCoordinatorDelegate {
    func gameOverStartGameButtonTapped() {
        print("gotoMainScreenButtonTapped Coordinator")
        presenter.popViewController(animated: true)
    }

    func gameOverGotoMainScreenButtonTapped() {
        print("startGameButtonTapped coordinator")
        presenter.popToRootViewController(animated: true)
    }
}
