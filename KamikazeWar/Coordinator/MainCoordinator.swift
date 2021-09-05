//
//  MainCoordinator.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 04/05/2021.
//

import UIKit

class MainCoordinator: Coordinator {
    
    let presenter: UINavigationController
    var mainViewModel: MainViewModel?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    override func start() {
        let mainViewModel = MainViewModel()
        let mainViewController = MainViewController(viewModel: mainViewModel)
        mainViewModel.viewDelegate = mainViewController
        mainViewModel.coordinatorDelegate = self
        self.mainViewModel = mainViewModel
        presenter.pushViewController(mainViewController, animated: false)
    }
    
    override func finish() {}
    
}


extension MainCoordinator: MainCoordinatorDelegate {
    
    func startButtonTapped() {
        let gameViewModel = GameViewModel()
        gameViewModel.coordinatorDelegate = self
        let gameViewController = GameViewController(viewModel: gameViewModel)
        gameViewModel.viewDelegate = gameViewController
        presenter.pushViewController(gameViewController, animated: false)
    }
    
    func exitButtonTapped() {
        presenter.popViewController(animated: true)
    }
    
}

extension MainCoordinator: GameCoordinatorDelegate {
    func performGameOver(finalScore: Int) {
        let gameOverCoordinator = GameOverCoordinator(presenter: presenter)
        addChildCoordinator(gameOverCoordinator)
        gameOverCoordinator.performGameOver(finalScore: finalScore)
    }
}
