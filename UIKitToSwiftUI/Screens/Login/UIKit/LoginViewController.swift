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
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [loginField, passwordField]
            .forEach {
                $0.addTarget(self, action: #selector(handleUpdatedText(_:)), for: .editingChanged)
            }
        viewModel.textIO.$message.observe(with: self) { (vc, message) in
            vc.messageLabel.text = message
        }
        viewModel.progress.$isLoading.observe(with: self) { (vc, isLoading) in
            vc.loadingIndicator.animating = isLoading
            [vc.loginField, vc.passwordField]
                .forEach { $0?.isHidden = isLoading }
        }
        viewModel.loginButton.$title.observe(with: self) { (vc, title) in
            vc.logInButton.setTitle(title, for: .normal)
        }
        viewModel.loginButton.$isEnabled.observe(with: self) { (vc, isEnabled) in
            vc.logInButton.isEnabled = isEnabled
        }
        viewModel.loginButton.$status.observe(with: self) { (vc, status) in
            let fgColor: UIColor, bgColor: UIColor
            switch status {
            case .disabledLogin:
                fgColor = .white
                bgColor = .systemGray
            case .enabledLogin:
                fgColor = .white
                bgColor = .systemBlue
            case .loading:
                fgColor = .darkText
                bgColor = .clear
//                fgColor = .white
//                bgColor = .systemBlue
            }
            vc.logInButton.setTitleColor(fgColor, for: .normal)
            vc.logInButton.backgroundColor = bgColor
        }
    }
    
    @objc private func handleUpdatedText(_ field: UITextField) {
        if field === loginField {
            viewModel.textIO.login = field.text ?? ""
        } else if field === passwordField {
            viewModel.textIO.password = field.text ?? ""
        }
    }
    
    @IBAction func handleLogInButtonPressed() {
        if viewModel.loginButton.status == .loading {
            viewModel.cancelLoading()
        } else {
            view.endEditing(true)
            viewModel.authenticate()
        }
    }
}
