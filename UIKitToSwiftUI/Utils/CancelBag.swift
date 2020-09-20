//
//  CancelBag.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 16.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Combine

typealias CancelBag = Set<AnyCancellable>

extension CancelBag {
    mutating func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        formUnion(cancellables())
    }

    @_functionBuilder
    struct Builder {
        static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            return cancellables
        }
    }
}
