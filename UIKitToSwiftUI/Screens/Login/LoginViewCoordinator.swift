//
//  LoginViewCoordinator.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UIKit

final class LoginViewCoordinator: BaseCoordinator {
    
    private let container: LoginStageContainer
    private weak var parent: UIViewController?
    
    @Signal private(set) var startUserSession: Accepts<AuthToken>
    
    init(container: LoginStageContainer, parent: UIViewController) {
        self.container = container
        self.parent = parent
    }
    
    override func start() {
        guard let parent = parent else { return }
        let viewModel = LoginViewModel(container: container)
        viewModel.$didLogIn.observe(with: self) { (coordinator, authToken) in
            coordinator.startUserSession.send(authToken)
            coordinator.complete()
        }
        let viewController = LoginViewController(viewModel: viewModel)
        parent.setContentViewController(viewController)
    }
    
    override func complete() {
        super.complete()
        guard let loginVC = self.parent?.children
            .compactMap({ $0 as? LoginViewController })
            .first else { return }
        loginVC.view.removeFromSuperview()
        loginVC.removeFromParent()
    }
}
