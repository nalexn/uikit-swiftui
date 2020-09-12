//
//  UserService.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Foundation

class RealUserService: UserService {
    
    private let token: AuthToken
    
    required init(token: AuthToken) {
        self.token = token
    }
    
    func loadUser() -> Promise<User> {
        
        return Promise<User> { forward in
            // Simulating actual network request
            async(after: 1.5) {
                forward(.success(User(name: "John Smith", balance: 242352)))
            }
        }
    }
}
