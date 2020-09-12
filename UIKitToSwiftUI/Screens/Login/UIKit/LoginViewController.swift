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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func handleLogInButtonPressed() {
    }
}
