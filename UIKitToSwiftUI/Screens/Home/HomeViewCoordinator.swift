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
    private weak var viewController: UIViewController?
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
            viewModel.onSelect.sink { [weak self] transaction in
                self?.showDetails(transaction: transaction)
            }
            viewModel.onLogOut
                .subscribe(endUserSession)
            endUserSession
                .assign(to: \.onComplete, on: self)
        }
        
        let viewController = HomeViewController(viewModel: viewModel)
        self.viewController = viewController
        parent.setContentViewController(viewController)
    }
    
    private func showDetails(transaction: Transaction) {
        guard let viewController = viewController
        else { return }
        let coordinator = DetailsViewCoordinator(
            container: container, parent: viewController, transaction: transaction)
        self.coordinate(to: coordinator)
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
