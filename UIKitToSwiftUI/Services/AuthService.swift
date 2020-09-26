//
//  AuthService.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Combine

typealias RealAuthService = FakeAuthService

class FakeAuthService: AuthService {
    
    func authenticate(login: String, password: String) -> Promise<AuthToken> {
        return Future<AuthToken, Error> { promise in
            // Simulating actual network request
            async(after: 1.5) {
                promise(.success(AuthToken(value: "token_123456789")))
            }
        }.eraseToAnyPublisher()
    }
}
