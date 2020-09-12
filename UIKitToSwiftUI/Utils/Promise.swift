//
//  Promise.swift
//  UIKitToSwiftUI
//
//  Created by Alexey Naumov on 12.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

class Promise<Value> {
    
    typealias Completion = (Result<Value, Error>) -> Void
    private let task: (@escaping Completion) -> Void
    
    init(task: @escaping (@escaping Completion) -> Void) {
        self.task = task
    }
    
    func complete(_ result: @escaping Completion) {
        task(result)
    }
    
    func then<T>(promise: @escaping (Value) -> Promise<T>) -> Promise<T> {
        return Promise<T> { forwardResult in
            self.task({ currentResult in
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
}
