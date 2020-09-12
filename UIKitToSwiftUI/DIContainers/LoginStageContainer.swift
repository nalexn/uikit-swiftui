//
//  LoginStageContainer.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Foundation

struct RealLoginStageContainer: LoginStageContainer {
    
    let authService: AuthService
    
    init() {
        authService = RealAuthService()
    }
}
