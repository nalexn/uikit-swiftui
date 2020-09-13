//
//  Promise.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Foundation

final class Promise<Value> {
    
    typealias Completion = (Result<Value, Error>) -> Void
    private let task: (@escaping Completion) -> Void
    private let cancelToken: CancelToken
    
    convenience init(task: @escaping (@escaping Completion) -> Void) {
        self.init(cancelToken: CancelToken(), task: task)
    }
    
    init(cancelToken: CancelToken, task: @escaping (@escaping Completion) -> Void) {
        self.task = task
        self.cancelToken = cancelToken
    }
    
    @discardableResult
    func complete(_ result: @escaping Completion) -> CancelToken {
        task(result)
        return cancelToken
    }
    
    func then<T>(_ promise: @escaping (Value) -> Promise<T>) -> Promise<T> {
        return Promise<T>(cancelToken: cancelToken) { forwardResult in
            guard !self.cancelToken.isCancelled else {
                forwardResult(.failure(NSError.userCancelled))
                return
            }
            self.task({ currentResult in
                guard !self.cancelToken.isCancelled else {
                    forwardResult(.failure(NSError.userCancelled))
                    return
                }
                switch currentResult {
                case .success(let currentValue):
                    promise(currentValue).task({ nextResult in
                        switch nextResult {
                        case .success(let nextValue):
                            forwardResult(.success(nextValue))
                        case .failure(let nextError):
                            forwardResult(.failure(nextError))
                        }
                    })
                case .failure(let currentError):
                    forwardResult(.failure(currentError))
                }
            })
        }
    }
    
    func map<T>(_ transform: @escaping (Value) -> T) -> Promise<T> {
        return then { value -> Promise<T> in
            return Promise<T> { forwardResult in
                forwardResult(.success(transform(value)))
            }
        }
    }
}

extension Promise where Value == Void {
    static func startWith<T>(_ promise: @escaping (()) -> Promise<T>) -> Promise<T> {
        return Promise<Void>(task: { $0(.success(())) }).then(promise)
    }
}

class CancelToken {
    
    private(set) var isCancelled: Bool = false
    
    func cancel() {
        isCancelled = true
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
