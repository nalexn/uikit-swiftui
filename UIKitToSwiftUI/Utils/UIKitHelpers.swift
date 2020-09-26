//
//  UIKitHelpers.swift
//  UIKitApp
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UIKit

func async(after timeInterval: TimeInterval, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval, execute: execute)
}

extension UIViewController {
    
    func setContentViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: self)
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = true
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}

extension UIActivityIndicatorView {
    var animating: Bool {
        get { isAnimating }
        set {
            if newValue {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }
}

extension UITableView {
    func reuse<C>(_ cellType: C.Type) where C: UITableViewCell {
        let reuseId = String(describing: cellType)
        register(cellType, forCellReuseIdentifier: reuseId)
    }
    
    func dequeue<C>(_ cellType: C.Type) -> C where C: UITableViewCell {
        let reuseId = String(describing: cellType)
        guard let cell = dequeueReusableCell(withIdentifier: reuseId) as? C
            else { fatalError("Unable to dequeue \(reuseId)") }
        return cell
    }
}
