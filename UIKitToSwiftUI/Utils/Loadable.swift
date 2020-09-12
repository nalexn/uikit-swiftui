//
//  Loadable.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Foundation

enum Loadable<Value> {

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
    
    func map<V>(_ transform: (Value) throws -> V) -> Loadable<V> {
        do {
            switch self {
            case .notRequested: return .notRequested
            case let .failed(error): return .failed(error)
            case let .isLoading(value, cancelToken):
                return .isLoading(last: try value.map { try transform($0) },
                                  cancelToken: cancelToken)
            case let .loaded(value):
                return .loaded(try transform(value))
            }
        } catch {
            return .failed(error)
        }
    }
}

protocol SomeOptional {
    associatedtype Wrapped
    func unwrap() throws -> Wrapped
}

struct ValueIsMissingError: Error {
    var localizedDescription: String {
        NSLocalizedString("Data is missing", comment: "")
    }
}

extension Optional: SomeOptional {
    func unwrap() throws -> Wrapped {
        switch self {
        case let .some(value): return value
        case .none: throw ValueIsMissingError()
        }
    }
}

extension Loadable where Value: SomeOptional {
    func unwrap() -> Loadable<Value.Wrapped> {
        map { try $0.unwrap() }
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
