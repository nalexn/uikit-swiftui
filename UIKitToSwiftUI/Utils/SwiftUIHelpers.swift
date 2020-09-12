//
//  SwiftUIHelpers.swift
//  SwiftUIApp
//
//  Created by Alexey Naumov on 13.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import SwiftUI
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

extension SubscriptionPoint {
    func assign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Value>, on object: Root) -> AnyCancellable where Root: AnyObject {
        let subject = PassthroughSubject<Value, Never>()
        observe(with: object) { (object, value) in
            subject.send(value)
        }
        return subject.assign(to: keyPath, on: object)
    }
}
