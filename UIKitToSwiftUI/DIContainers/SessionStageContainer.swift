//
//  SessionStageContainer.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

struct RealSessionStageContainer: SessionStageContainer {
    
    let userService: UserService
    let transactionsService: TransactionsService
    
    init(authToken: AuthToken) {
        self.userService = RealUserService(token: authToken)
        self.transactionsService = RealTransactionsService(token: authToken)
    }
}
