//
//  LoginViewController.swift
//  SwiftUIApp
//
//  Created by Alexey Naumov on 13.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

class LoginViewController: UIHostingController<LoginView> {
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(rootView: LoginView(viewModel: viewModel.adapt()))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginViewModel {
    func adapt() -> LoginView.ViewModel {
        let vm = LoginView.ViewModel()
        vm.cancelBag.collect {
            vm.$login.assign(to: \.login, on: self)
            vm.$password.assign(to: \.password, on: self)
            $isLoginButtonEnabled.assign(to: \.isLoginButtonEnabled, on: vm)
        }
        return vm
    }
}

// MARK: - ObservableObject

extension LoginView {
    class ViewModel: ObservableObject {
        
        @Published var login: String = ""
        @Published var password: String = ""
        @Published var isLoginButtonEnabled = false
        var cancelBag = CancelBag()
        
        let onLoginButtonPressed = PassthroughSubject<Void, Never>()
    }
}

// MARK: - View

struct LoginView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            TextField("Login", text: $viewModel.login)
                .modifier(TextFieldAppearance())
            TextField("Password", text: $viewModel.password)
                .modifier(TextFieldAppearance())
            Button(action: { self.viewModel.onLoginButtonPressed.send(()) },
                   label: { Text("Log In").foregroundColor(Color(.systemBackground)) })
                .modifier(LoginButtonAppearance(isEnabled: $viewModel.isLoginButtonEnabled))
                .disabled(!viewModel.isLoginButtonEnabled)
        }
        .frame(width: 200)
    }
}

extension LoginView {
    struct TextFieldAppearance: ViewModifier {
        
        func body(content: Content) -> some View {
            content
                .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(.separator), lineWidth: 1))
        }
    }
    struct LoginButtonAppearance: ViewModifier {
        
        @Binding var isEnabled: Bool
        
        func body(content: Content) -> some View {
            content
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(isEnabled ? .systemBlue : .systemGray)))
        }
    }
}

// MARK: - Preview

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginView.ViewModel())
    }
}
