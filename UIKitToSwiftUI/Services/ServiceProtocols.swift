//
//  ServiceProtocols.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Foundation

protocol AuthService {
    func authenticate(login: String, password: String) -> Promise<AuthToken>
}

protocol UserService {
    init(token: AuthToken)
    func loadUser() -> Promise<User>
}

protocol TransactionsService {
    init(token: AuthToken)
    func loadTransactions(user: User) -> Promise<[Transaction]>
}
