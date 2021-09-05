//
//  MainViewModel.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 04/05/2021.
//

import Foundation

protocol MainCoordinatorDelegate: class {
    func startButtonTapped()
}

protocol MainViewDelegate: class {

}

class MainViewModel {
    
    weak var coordinatorDelegate: MainCoordinatorDelegate?
    weak var viewDelegate: MainViewDelegate?
    
    func startGameButtonTapped(){
        coordinatorDelegate?.startButtonTapped()
    }
}
