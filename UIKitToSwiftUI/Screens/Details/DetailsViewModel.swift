//
//  DetailsViewModel.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 27.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Combine
import Foundation

final class DetailsViewModel: ObservableObject {
    
    let textIO: TextIO
    let onClose = PassthroughSubject<Void, Never>()
    let onFinish = PassthroughSubject<Void, Never>()
    
    init(container: SessionStageContainer, transaction: Transaction) {
        textIO = .init(transaction: transaction)
    }
    
    func close() {
        onClose.send(())
    }
    
    deinit {
        onFinish.send(())
    }
}

// MARK: - Elements

extension DetailsViewModel {
    
    struct TextIO {
       
        let date: String
        let amount: String
        let description: String
        let closeTitle: String
        
        init(transaction: Transaction) {
            let currencyFormatter = NumberFormatter.currency
            let dateFormatter = DateFormatter.transaction
            date = dateFormatter.string(from: transaction.date)
            amount = currencyFormatter.amount(cents: transaction.amount)
            description = transaction.description
            closeTitle = "Close"
        }
    }
}
