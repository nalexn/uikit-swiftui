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
    private let parent: Any?
    
    convenience init(task: @escaping (@escaping Completion) -> Void) {
        self.init(parent: nil, task: task)
    }
    
    private init(parent: Any?, task: @escaping (@escaping Completion) -> Void) {
        self.task = task
        self.parent = parent
    }
    
    func complete(_ completion: @escaping Completion) -> CancelToken {
        task({ [weak self] result in
            if self != nil {
                completion(result)
            }
        })
        return CancelToken(parent: self)
    }
    
    func then<T>(_ promise: @escaping (Value) -> Promise<T>) -> Promise<T> {
        return Promise<T>(parent: self) { [weak self] forwardResult in
            self?.task({ currentResult in
                guard self != nil else { return }
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
    private var parent: Any?
    
    fileprivate init(parent: Any) {
        self.parent = parent
    }
    
    func cancel() {
        isCancelled = true
        parent = nil
    }
}
