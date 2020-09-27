//
//  DetailsViewCoordinator.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 27.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UIKit
import Combine

final class DetailsViewCoordinator: BaseCoordinator {
    
    private let container: SessionStageContainer
    private weak var parent: UIViewController?
    private let transaction: Transaction
    private var cancelBag = CancelBag()
    
    init(container: SessionStageContainer, parent: UIViewController, transaction: Transaction) {
        self.container = container
        self.parent = parent
        self.transaction = transaction
    }
    
    override func start() {
        super.start()
        guard let parent = parent else { return }
        let viewModel = DetailsViewModel(container: container, transaction: transaction)
        let viewController = DetailsViewController(viewModel: viewModel)
        parent.present(viewController, animated: true, completion: nil)
        viewModel.didFinish
            .assign(to: \.onComplete, on: self)
            .store(in: &cancelBag)
    }
}
