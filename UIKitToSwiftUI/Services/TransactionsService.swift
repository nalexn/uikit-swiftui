//
//  TransactionsService.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

class RealTransactionsService: TransactionsService {
    
    private let token: AuthToken
    
    required init(token: AuthToken) {
        self.token = token
    }
    
    func loadTransactions(user: User) -> Promise<[Transaction]> {
        
        return Promise<[Transaction]> { forward in
            // Simulating actual network request
            async(after: 1.5) {
                forward(.success([
                    Transaction(date: .init(timeIntervalSinceNow: -3000), amount: 53232, description: "Payrol from X inc."),
                    Transaction(date: .init(timeIntervalSinceNow: -2000), amount: -3261, description: "M & Coffee shop"),
                    Transaction(date: .init(timeIntervalSinceNow: -100), amount: -412, description: "Super B Taxi"),
                    ]))
            }
        }
    }
}
