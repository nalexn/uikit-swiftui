//
//  LoginViewCoordinator.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UIKit
import Combine

final class LoginViewCoordinator: BaseCoordinator {
    
    private let container: LoginStageContainer
    private weak var parent: UIViewController?
    private var cancelBag = CancelBag()
    let startUserSession = PassthroughSubject<AuthToken, Never>()
    
    init(container: LoginStageContainer, parent: UIViewController) {
        self.container = container
        self.parent = parent
    }
    
    override func start() {
        super.start()
        guard let parent = parent else { return }
        let viewModel = LoginViewModel(container: container)
        cancelBag.collect {
            viewModel.$progress
                .map(\.status)
                .compactMap { $0.value }
                .subscribe(startUserSession)
            startUserSession.first()
                .map { _ in () }
                .assign(to: \.onComplete, on: self)
        }
        
        let viewController = LoginViewController(viewModel: viewModel)
        parent.setContentViewController(viewController)
    }
    
    override func complete() {
        super.complete()
        guard let vc = self.parent?.children
            .compactMap({ $0 as? LoginViewController })
            .first else { return }
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}
