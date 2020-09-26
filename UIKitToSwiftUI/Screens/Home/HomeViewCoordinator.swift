//
//  HomeViewCoordinator.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UIKit
import Combine

final class HomeViewCoordinator: BaseCoordinator {
    
    private let container: SessionStageContainer
    private weak var parent: UIViewController?
    private var cancelBag = CancelBag()
    let endUserSession = PassthroughSubject<Void, Never>()
    
    init(container: SessionStageContainer, parent: UIViewController) {
        self.container = container
        self.parent = parent
    }
    
    override func start() {
        guard let parent = parent else { return }
        let viewModel = HomeViewModel(container: container)
        
        cancelBag.collect {
            viewModel.onLogOut
                .subscribe(endUserSession)
            endUserSession
                .assign(to: \.onComplete, on: self)
        }
        
        let viewController = HomeViewController(viewModel: viewModel)
        parent.setContentViewController(viewController)
    }
    
    override func complete() {
        super.complete()
        guard let vc = self.parent?.children
            .compactMap({ $0 as? HomeViewController })
            .first else { return }
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}
