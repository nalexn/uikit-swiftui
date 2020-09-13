//
//  LoginViewModel.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

final class LoginViewModel {
    
    private let authService: AuthService
    
    let textIO = TextIO()
    let progress = Progress()
    let loginButton = LoginButton()
    
    init(container: LoginStageContainer) {
        self.authService = container.authService
        textIO.bind(with: self)
        progress.bind(with: self)
        loginButton.bind(with: self)
    }
}

// MARK: - Elements

extension LoginViewModel {
    class TextIO {
        
        @Property var login: String = ""
        @Property var password: String = ""
        @Property private(set) var message: String = ""
        
        func bind(with viewModel: LoginViewModel) {
            viewModel.progress.$status.observe(with: self) { (vm, status) in
                switch status {
                case .notRequested:
                    vm.message = "Welcome!\nType any login and password"
                case .loaded:
                    vm.message = ""
                case .isLoading:
                    vm.message = "Logging in..."
                case .failed(let error):
                    vm.message = "Error: " + error.localizedDescription
                }
            }
        }
    }
    
    class Progress {
        
        @Property fileprivate(set) var status: Loadable<AuthToken> = .notRequested
        @Property private(set) var isLoading = false
        
        func bind(with viewModel: LoginViewModel) {
            $status.observe(with: self) { (vm, status) in
                switch status {
                case .isLoading:
                    vm.isLoading = true
                default:
                    vm.isLoading = false
                }
            }
        }
    }

    class LoginButton {
        @Property private(set) var status: Status = .disabledLogin
        @Property private(set) var title: String = ""
        @Property private(set) var isEnabled: Bool = false
        
        func bind(with viewModel: LoginViewModel) {
            viewModel.textIO.$login
                .combine(with: viewModel.textIO.$password)
                .combine(with: viewModel.progress.$isLoading)
                .observe(with: self) { (vm, combination) in
                    let ((login, password), isLoading) = combination
                    if isLoading {
                        vm.status = .loading
                    } else {
                        vm.status = login.count > 0 && password.count > 0 ?
                            .enabledLogin : .disabledLogin
                    }
                }
            $status.observe(with: self) { (vm, status) in
                vm.isEnabled = status != .disabledLogin
                vm.title = status == .loading ? "Cancel" : "Log In"
            }
        }
    }
}

extension LoginViewModel.LoginButton {
    enum Status {
        case disabledLogin
        case enabledLogin
        case loading
    }
}

// MARK: - Side Effects

extension LoginViewModel {
    
    func authenticate() {
        let token = authService
            .authenticate(login: textIO.login, password: textIO.password)
            .complete { [weak self] result in
                switch result {
                case .success(let authToken):
                    self?.progress.status = .loaded(authToken)
                case .failure(let error):
                    self?.progress.status = .failed(error)
                }
            }
        progress.status.setIsLoading(cancelToken: token)
    }
    
    func cancelLoading() {
        progress.status.cancelLoading()
    }
}
