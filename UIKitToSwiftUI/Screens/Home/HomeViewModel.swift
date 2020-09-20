//
//  HomeViewModel.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 13.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Combine

final class HomeViewModel {
    
    private let userService: UserService
    private let transactionsService: TransactionsService
    
    @Published var content: Loadable<(user: User, transactions: [Transaction])> = .notRequested
    
    init(container: SessionStageContainer) {
        self.userService = container.userService
        self.transactionsService = container.transactionsService
    }
}

// MARK: - Side Effects

extension HomeViewModel {
    
    func loadContent() {
        let userService = self.userService
        let transactionsService = self.transactionsService
        let token = Just<Void>
            .withErrorType(Error.self)
            .flatMap {
                userService.loadUser()
            }
            .flatMap { user in
                transactionsService.loadTransactions(user: user)
                    .map { (user, $0) }
            }
            .sinkToLoadable { [weak self] content in
                self?.content = content
            }
        content.setIsLoading(cancelToken: token)
    }
}
