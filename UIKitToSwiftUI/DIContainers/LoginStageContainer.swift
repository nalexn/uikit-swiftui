//
//  LoginStageContainer.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

struct RealLoginStageContainer: LoginStageContainer {
    let authService: AuthService = RealAuthService()
}

#if DEBUG
struct FakeLoginStageContainer: LoginStageContainer {
    let authService: AuthService = FakeAuthService()
}
#endif
