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
    
    let endUserSession = PassthroughSubject<AuthToken, Never>()
    
    init(container: SessionStageContainer, parent: UIViewController) {
        self.container = container
        self.parent = parent
    }
    
    override func start() {
        
    }
}
