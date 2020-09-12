//
//  LoginViewModel.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

final class LoginViewModel {
    
    private let authService: AuthService
    
    @Property private(set) var status: Loadable<Void> = .notRequested
    @Property private(set) var isLoginButtonEnabled = false
    @Signal private(set) var didLogIn: Accepts<AuthToken>
    @Property var login: String = ""
    @Property var password: String = ""
    
    init(container: LoginStageContainer) {
        self.authService = container.authService
        
        $login.observe(with: self) { (vm, login) in
            vm.updateLoginButton(login: login, password: vm.password)
        }
        $password.observe(with: self) { (vm, password) in
            vm.updateLoginButton(login: vm.login, password: password)
        }
    }
    
    private func updateLoginButton(login: String, password: String) {
        isLoginButtonEnabled = login.count > 0 && password.count > 0
    }
}

// MARK: - Side Effects

extension LoginViewModel {
    
    func authenticate() -> CancelToken {
        let token = authService
            .authenticate(login: login, password: password)
            .complete { [weak self] result in
                switch result {
                case .success(let authToken):
                    self?.status = .loaded(())
                    self?.didLogIn.send(authToken)
                case .failure(let error):
                    self?.status = .failed(error)
                }
            }
        status.setIsLoading(cancelToken: token)
        return token
    }
}
