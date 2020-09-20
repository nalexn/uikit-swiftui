//
//  ContainersForPreview.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 20.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

struct FakeLoginStageContainer: LoginStageContainer {
    let authService: AuthService = FakeAuthService()
}

struct FakeSessionStageContainer: SessionStageContainer {
    
    let userService: UserService
    let transactionsService: TransactionsService
    
    init(authToken: AuthToken) {
        self.userService = FakeUserService(token: authToken)
        self.transactionsService = FakeTransactionsService(token: authToken)
    }
    
    init() {
        self.init(authToken: AuthToken(value: ""))
    }
}
