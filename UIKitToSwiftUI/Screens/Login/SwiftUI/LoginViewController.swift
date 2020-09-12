//
//  LoginViewController.swift
//  SwiftUIApp
//
//  Created by Alexey Naumov on 13.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import SwiftUI
import UIKit

class LoginViewController: UIHostingController<LoginView> {
    
    init(viewModel: LoginViewModel) {
        let _vm = LoginView.ViewModel()
        super.init(rootView: LoginView(viewModel: _vm))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ObservableObject

extension LoginView {
    class ViewModel: ObservableObject {
        @Published var login: String = ""
        @Published var password: String = ""
        @Published var loginButtonEnabled = false
        
        func handleLoginButtonPressed() {
            
        }
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
            Button(action: { self.viewModel.handleLoginButtonPressed() },
                   label: { Text("Log In").foregroundColor(Color(.systemBackground)) })
                .modifier(LoginButtonAppearance())
                .disabled(!viewModel.loginButtonEnabled)
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
        func body(content: Content) -> some View {
            content
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemBlue)))
        }
    }
}

// MARK: - Preview

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginView.ViewModel())
    }
}
