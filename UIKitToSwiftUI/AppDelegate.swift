//
//  AppDelegate.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var rootCoordinator: BaseCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let builder = ContainerBuilder(login: {
            RealLoginStageContainer()
        }, session: { authToken in
            RealSessionStageContainer(authToken: authToken)
        })

        rootCoordinator = RootCoordinator(containerBuilder: builder)
        rootCoordinator?.start()
        return true
    }
}
