//
//  HomeViewModel.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 13.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

final class HomeViewModel {
    
    private let userService: UserService
    private let transactionsService: TransactionsService
    
    @Property private(set) var content: Loadable<(User, [Transaction])> = .notRequested
    
    init(container: SessionStageContainer) {
        self.userService = container.userService
        self.transactionsService = container.transactionsService
    }
}

// MARK: - Side Effects

extension HomeViewModel {
    
    func loadContent() -> CancelToken {
        let userService = self.userService
        let transactionsService = self.transactionsService
        let token = Promise
            .startWith {
                userService.loadUser()
            }
            .then { user in
                transactionsService.loadTransactions(user: user)
                    .map { (user, $0) }
            }
            .assign(to: \.content, on: self)
        content.setIsLoading(cancelToken: token)
        return token
    }
}
