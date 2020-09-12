//
//  ContainerProtocols.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Foundation

// A container that is unlocked when the app starts:

protocol LoginStageContainer {
    
    var authService: AuthService { get }
}

// A container that gets unlocked for authenticated user:

protocol SessionStageContainer {
    
    init(authToken: AuthToken)
    
    var userService: UserService { get }
    var transactionsService: TransactionsService { get }
}
