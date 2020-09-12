//
//  RootCoordinator.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UIKit

final class RootCoordinator: BaseCoordinator {
    
    private lazy var window = UIWindow(frame: UIScreen.main.bounds)
    private lazy var rootVC = UIViewController()
    
    override func start() {
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        coordinateToLogIn()
    }
    
    private func coordinateToLogIn() {
        let container = RealLoginStageContainer()
        let loginCoordinator = LoginViewCoordinator(container: container, parent: rootVC)
        loginCoordinator.$startUserSession.observe(with: self) { (coordinator, authToken) in
            coordinator.coordinateToHome(authToken: authToken)
        }
        coordinate(to: loginCoordinator)
    }
    
    private func coordinateToHome(authToken: AuthToken) {
        let container = RealSessionStageContainer(authToken: authToken)
        let sessionCoordinator = HomeViewCoordinator(container: container, parent: rootVC)
        sessionCoordinator.$endUserSession.observe(with: self) { (coordinator, _) in
            coordinator.coordinateToLogIn()
        }
        coordinate(to: sessionCoordinator)
    }
}
