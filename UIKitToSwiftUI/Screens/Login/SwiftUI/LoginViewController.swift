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
        super.init(rootView: LoginView(viewModel: viewModel))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack {
            TextField("Login", text: $viewModel.textIO.login)
                .modifier(TextFieldAppearance())
            TextField("Password", text: $viewModel.textIO.password)
                .modifier(TextFieldAppearance())
            Button(action: { self.viewModel.authenticate() },
                   label: { Text("Log In").foregroundColor(Color(.systemBackground)) })
                .modifier(LoginButtonAppearance(isEnabled: $viewModel.loginButton.isEnabled))
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
                .disabled(!isEnabled)
        }
    }
}

// MARK: - Preview

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: .init(container: FakeLoginStageContainer()))
    }
}
