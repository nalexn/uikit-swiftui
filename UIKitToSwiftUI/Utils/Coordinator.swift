//
//  Coordinator.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

class BaseCoordinator {
    
    private weak var parent: BaseCoordinator?
    private var children: [BaseCoordinator] = []
    
    func coordinate(to coordinator: BaseCoordinator) {
        coordinator.parent = self
        children.append(coordinator)
        coordinator.start()
    }
    
    func start() {
        
    }
    
    func complete() {
        parent?.remove(coordinator: self)
    }
    
    var onComplete: Void = () {
        didSet { complete() }
    }
    
    // MARK: - Private
    
    private func remove(coordinator: BaseCoordinator) {
        if let index = children.firstIndex(where: { $0 === coordinator}) {
            children.remove(at: index)
        }
        coordinator.parent = nil
    }
}
