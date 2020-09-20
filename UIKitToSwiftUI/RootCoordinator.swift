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
    private var cancelbag = CancelBag()
    
    override func start() {
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        coordinateToLogIn()
    }
    
    private func coordinateToLogIn() {
        let container = RealLoginStageContainer()
        let loginCoordinator = LoginViewCoordinator(container: container, parent: rootVC)
        loginCoordinator.startUserSession
            .first()
            .sink { [weak self] authToken in
                self?.coordinateToHome(authToken: authToken)
            }
            .store(in: &cancelbag)
        coordinate(to: loginCoordinator)
    }
    
    private func coordinateToHome(authToken: AuthToken) {
        let container = RealSessionStageContainer(authToken: authToken)
        let sessionCoordinator = HomeViewCoordinator(container: container, parent: rootVC)
        sessionCoordinator.endUserSession
            .first()
            .sink { [weak self] _ in
                self?.coordinateToLogIn()
            }
            .store(in: &cancelbag)
        coordinate(to: sessionCoordinator)
    }
}
