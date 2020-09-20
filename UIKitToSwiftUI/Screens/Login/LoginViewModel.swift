//
//  LoginViewModel.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Combine

final class LoginViewModel: ObservableObject {
    
    private let authService: AuthService
    private var cancelBag = CancelBag()
    
    @Published var textIO = TextIO()
    @Published var progress = Progress()
    @Published var loginButton = LoginButton()
    
    init(container: LoginStageContainer) {
        self.authService = container.authService
        
        let statusUpdates = $progress
            .map(\.status)
            .removeDuplicates()
        let isLoading = statusUpdates.map { $0.isLoading }
        cancelBag.collect {
            statusUpdates
                .map { $0.statusMessage }
                .assign(to: \.textIO.message, on: self)
            Publishers.CombineLatest3($textIO.map(\.login), $textIO.map(\.password), isLoading)
                .map { (login, password, isLoading) -> LoginViewModel.LoginButton.Status in
                    if isLoading {
                        return .loading
                    }
                    return login.count > 0 && password.count > 0 ?
                        .enabledLogin : .disabledLogin
                }
                .assign(to: \.loginButton.status, on: self)
        }
    }
}

// MARK: - Elements

extension LoginViewModel {
    struct TextIO {
        var login: String = ""
        var password: String = ""
        var message: String = ""
    }
    
    struct Progress {
        var status: Loadable<AuthToken> = .notRequested
    }

    struct LoginButton {
        var title: String = ""
        var isEnabled: Bool = false
        var status: Status = .disabledLogin {
            didSet {
                isEnabled = status != .disabledLogin
                title = status == .loading ? "Cancel" : "Log In"
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

fileprivate extension Loadable {
    var statusMessage: String {
        switch self {
        case .notRequested:
            return "Welcome!\nType any login and password"
        case .loaded:
            return ""
        case .isLoading:
            return "Logging in..."
        case .failed(let error):
            return "Error: " + error.localizedDescription
        }
    }
}

// MARK: - Side Effects

extension LoginViewModel {
    
    func authenticate() {
        let token = authService
            .authenticate(login: textIO.login, password: textIO.password)
            .sinkToLoadable { [weak self] status in
                self?.progress.status = status
            }
        progress.status.setIsLoading(cancelToken: token)
    }
    
    func cancelLoading() {
        progress.status.cancelLoading()
    }
}
