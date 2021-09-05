//
//  AppCoordinator.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 04/05/2021.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private var window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {

        let mainNavigationController = UINavigationController()
        let mainCoordinator = MainCoordinator(presenter: mainNavigationController)

        addChildCoordinator(mainCoordinator)
        mainCoordinator.start()

        window.rootViewController = mainNavigationController
        window.makeKeyAndVisible()
    }
    
    override func finish() {}
    
}
