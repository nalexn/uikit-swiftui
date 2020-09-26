//
//  Transaction.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Foundation

struct Transaction: Hashable, Codable {
    let id: String
    let date: Date
    let amount: Int
    let description: String
}
