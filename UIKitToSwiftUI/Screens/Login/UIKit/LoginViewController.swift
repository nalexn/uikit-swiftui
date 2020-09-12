//
//  LoginViewController.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModel
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: nil)
        _ = view
        [loginField, passwordField]
            .forEach {
                $0.addTarget(self, action: #selector(handleUpdatedText(_:)), for: .editingChanged)
            }
        viewModel.$isLoginButtonEnabled.observe(with: self) { (viewController, isEnabled) in
            viewController.logInButton.isEnabled = isEnabled
            viewController.logInButton.backgroundColor = isEnabled ? .systemBlue : .systemGray
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleUpdatedText(_ field: UITextField) {
        if field === loginField {
            viewModel.login = field.text ?? ""
        } else if field === passwordField {
            viewModel.password = field.text ?? ""
        }
    }
    
    @IBAction func handleLogInButtonPressed() {
    }
}
