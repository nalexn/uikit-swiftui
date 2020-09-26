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
    private var cancelBag = CancelBag()
    
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
        loginField.placeholder = viewModel.textIO.loginTitle
        passwordField.placeholder = viewModel.textIO.passwordTitle
        setupBindings()
    }
    
    private func setupBindings() {
        cancelBag.collect {
            viewModel.$textIO.map(\.message)
                .sink { [weak self] message in
                    self?.messageLabel.text = message
                }
            viewModel.$progress.map { $0.status.isLoading }
                .sink { [weak self] isLoading in
                    self?.loadingIndicator.animating = isLoading
                    [self?.loginField, self?.passwordField]
                        .forEach { $0?.isHidden = isLoading }
                }
            viewModel.$loginButton.map(\.title)
                .sink { [weak self] title in
                    self?.logInButton.setTitle(title, for: .normal)
                }
            viewModel.$loginButton.map(\.isEnabled)
                .sink { [weak self] isEnabled in
                    self?.logInButton.isEnabled = isEnabled
                }
            viewModel.$loginButton.map(\.status)
                .map { status -> (UIColor, UIColor) in
                    switch status {
                    case .disabledLogin:
                        return (.white, .systemGray)
                    case .enabledLogin:
                        return (.white, .systemBlue)
                    case .loading:
                        return (.darkText, .clear)
                    }
                }
                .sink { [weak self] (fgColor, bgColor) in
                    self?.logInButton.setTitleColor(fgColor, for: .normal)
                    self?.logInButton.backgroundColor = bgColor
                }
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
