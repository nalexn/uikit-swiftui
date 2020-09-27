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
    private let containerBuilder: ContainerBuilder
    private var cancelbag = CancelBag()
    
    init(containerBuilder: ContainerBuilder) {
        self.containerBuilder = containerBuilder
    }
    
    override func start() {
        super.start()
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        // Alternatively, you can launch right from the home screen:
        // coordinateToHome(authToken: AuthToken(value: ""))
        
        coordinateToLogIn()
    }
    
    private func coordinateToLogIn() {
        let container = containerBuilder.login()
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
        let container = containerBuilder.session(authToken)
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
