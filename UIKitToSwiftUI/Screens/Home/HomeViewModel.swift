//
//  HomeViewModel.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 13.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    
    private let userService: UserService
    private let transactionsService: TransactionsService
    private var cancelBag = CancelBag()
    
    @Published var userInfo = UserInfo()
    @Published var transactions: [TransactionInfo] = []
    @Published var progress = Progress()
    
    @Published private var content = Content()
    
    init(container: SessionStageContainer) {
        self.userService = container.userService
        self.transactionsService = container.transactionsService
        
        cancelBag.collect {
            $content
                .map({ $0.data.user?.homeViewUserInfo ?? UserInfo() })
                .assign(to: \.userInfo, on: self)
            $content
                .map({ $0.data.transactions?.homeViewTransactionsInfo ?? [] })
                .assign(to: \.transactions, on: self)
            $content
                .map({ $0.data.mapToVoid })
                .assign(to: \.progress.status, on: self)
        }
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
            .sinkToLoadable { [weak self] data in
                self?.content.data = data
            }
        content.data.setIsLoading(cancelToken: token)
    }
}

// MARK: - Elements

extension HomeViewModel {
    struct UserInfo {
        var name: String = ""
        var balance: String = ""
    }
    
    struct TransactionInfo {
        var date: String
        var amount: String
        var description: String
    }
    
    struct Progress {
        var status: Loadable<Void> = .notRequested
    }
    
    private struct Content {
        var data: Loadable<(User, [Transaction])> = .notRequested
    }
}

// MARK: - Mapping

private extension Loadable where Value == (User, [Transaction]) {
    var mapToVoid: Loadable<Void> {
        map { _ in () }
    }
    var user: User? {
        return self.value?.0
    }
    var transactions: [Transaction]? {
        return self.value?.1
    }
}

private extension User {
    var homeViewUserInfo: HomeViewModel.UserInfo {
        let currencyFormatter = NumberFormatter.currency
        let amount = currencyFormatter.amount(cents: balance)
        return .init(name: name, balance: "Balance: " + amount)
    }
}

private extension Array where Element == Transaction {
    var homeViewTransactionsInfo: [HomeViewModel.TransactionInfo] {
        let currencyFormatter = NumberFormatter.currency
        let dateFormatter = DateFormatter.transaction
        return self.map {
            .init(date: dateFormatter.string(from: $0.date),
                  amount: currencyFormatter.amount(cents: $0.amount),
                  description: $0.description)
            }
    }
}
