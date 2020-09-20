//
//  UserService.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Combine

typealias RealUserService = FakeUserService

class FakeUserService: UserService {
    
    private let token: AuthToken
    
    required init(token: AuthToken) {
        self.token = token
    }
    
    func loadUser() -> Promise<User> {
        return Future<User, Error> { promise in
            // Simulating actual network request
            async(after: 2.5) {
                promise(.success(User(name: "John Smith", balance: 242352)))
            }
        }.eraseToAnyPublisher()
    }
}
