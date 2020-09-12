//
//  UIKitHelpers.swift
//  UIKitApp
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setContentViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: self)
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = true
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}
