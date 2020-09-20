//
//  Loadable.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Combine
import Foundation

enum Loadable<Value> {
    
    typealias CancelToken = AnyCancellable

    case notRequested
    case isLoading(last: Value?, cancelToken: CancelToken)
    case loaded(Value)
    case failed(Error)

    var value: Value? {
        switch self {
        case let .loaded(value): return value
        case let .isLoading(last, _): return last
        default: return nil
        }
    }
    var isLoading: Bool {
        switch self {
        case .isLoading: return true
        default: return false
        }
    }
    var error: Error? {
        switch self {
        case let .failed(error): return error
        default: return nil
        }
    }
}

extension Loadable {
    
    mutating func setIsLoading(cancelToken: CancelToken) {
        self = .isLoading(last: value, cancelToken: cancelToken)
    }
    
    mutating func cancelLoading() {
        switch self {
        case let .isLoading(last, cancelToken):
            cancelToken.cancel()
            if let last = last {
                self = .loaded(last)
            } else {
                self = .failed(NSError.userCancelled)
            }
        default: break
        }
    }
}

extension Loadable: Equatable where Value: Equatable {
    static func == (lhs: Loadable<Value>, rhs: Loadable<Value>) -> Bool {
        switch (lhs, rhs) {
        case (.notRequested, .notRequested): return true
        case let (.isLoading(lhsV, _), .isLoading(rhsV, _)): return lhsV == rhsV
        case let (.loaded(lhsV), .loaded(rhsV)): return lhsV == rhsV
        case let (.failed(lhsE), .failed(rhsE)):
            return lhsE.localizedDescription == rhsE.localizedDescription
        default: return false
        }
    }
}

extension NSError {
    static var userCancelled: NSError {
        return NSError(
            domain: NSCocoaErrorDomain, code: NSUserCancelledError,
            userInfo: [NSLocalizedDescriptionKey:
                NSLocalizedString("Canceled by user", comment: "")])
    }
}
