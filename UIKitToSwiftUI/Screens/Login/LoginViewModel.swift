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
    @Signal private(set) var didLogIn: Accepts<AuthToken>
    
    init(container: LoginStageContainer) {
        self.authService = container.authService
    }
    
    func authenticate(login: String, password: String) -> CancelToken {
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
