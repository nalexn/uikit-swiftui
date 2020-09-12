//
//  AuthService.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Foundation

class RealAuthService: AuthService {
    
    func authenticate(login: String, password: String) -> Promise<AuthToken> {
        
        return Promise<AuthToken> { forward in
            // Simulating actual network request
            async(after: 1.5) {
                forward(.success(AuthToken(value: "token_123456789")))
            }
        }
    }
}
