//
//  HomeViewCoordinator.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UIKit

final class HomeViewCoordinator: BaseCoordinator {
    
    private let container: SessionStageContainer
    private weak var parent: UIViewController?
    
    @Signal private(set) var endUserSession: Accepts<Void>
    
    init(container: SessionStageContainer, parent: UIViewController) {
        self.container = container
        self.parent = parent
    }
    
    override func start() {
        
    }
}
