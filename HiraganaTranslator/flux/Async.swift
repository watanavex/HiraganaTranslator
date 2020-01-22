//
//  Async.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import Foundation
import RxSwift

enum Async<T> {
    case uninitialized
    case loading
    case success(T)
    case fail(errorMessage: String)
    
    var value: T? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }
    var errorMessage: String? {
        switch self {
        case .fail(let errorMessage):
            return errorMessage
        default:
            return nil
        }
    }
    var isUninitialized: Bool {
        switch self {
        case .uninitialized:
            return true
        default:
            return false
        }
    }
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
    var isError: Bool {
        switch self {
        case .fail:
            return true
        default:
            return false
        }
    }
}

extension Async: Equatable where T: Equatable {
}

extension ObservableType {
    
    func distinctUntilChanged<T>(_ comparer: @escaping (T, T) throws -> Bool) -> Observable<Self.Element> where Self.Element == Async<T> {
        return self.distinctUntilChanged { (lhs, rhs) -> Bool in
            switch (lhs, rhs) {
            case (.uninitialized, .uninitialized):
                return true
            case (.loading, .loading):
                return true
            case (.fail(let lmsg), .fail(let rmsg)):
                return lmsg == rmsg
            case (.success(let lvalue), .success(let rvalue)):
                return try comparer(lvalue, rvalue)
            default:
                return false
            }
        }
    }
    
    func loading<T>() -> Observable<Bool> where Self.Element == Async<T> {
        return self.map { $0.isLoading }
            .distinctUntilChanged()
    }
    
    func success<T>() -> Observable<T> where Self.Element == Async<T>, T: Equatable {
        return self.distinctUntilChanged()
            .filter { $0.isSuccess }
            .map { $0.value! }
    }

    func fail<T>() -> Observable<String> where Self.Element == Async<T>, T: Equatable {
        return self.distinctUntilChanged()
            .filter { $0.isError }
            .map { $0.errorMessage! }
    }
}

extension PrimitiveSequenceType where Self.Trait == RxSwift.SingleTrait {
    
    func bind<VM, Action>(to viewModel: VM, actionTransformer: @escaping (Async<Element>) -> Action) -> Disposable where VM: ViewModel, VM.Action == Action {
        return self.bind(to: viewModel.dispatcher, errorTranslator: viewModel.errorTranslator, actionTransformer: actionTransformer)
    }
    
    fileprivate func bind<Action>(to dispatcher: PublishSubject<Action>, errorTranslator: ErrorTranslator, actionTransformer: @escaping (Async<Element>) -> Action) -> Disposable {
        return self.do(onSubscribe: {
                dispatcher.onNext(actionTransformer(Async.loading))
            })
            .subscribe(
                onSuccess: { [dispatcher] value in
                    dispatcher.onNext(
                        actionTransformer(Async.success(value))
                    )
                },
                onError: { [dispatcher] error in
                    dispatcher.onNext(
                        actionTransformer(Async.fail(errorMessage: errorTranslator.translate(error: error)))
                    )
                }
        )
    }
}

extension PrimitiveSequenceType where Self.Element == Never, Self.Trait == RxSwift.CompletableTrait {
    
    func bind<VM, Action>(to viewModel: VM, actionTransformer: @escaping (Async<Void>) -> Action) -> Disposable where VM: ViewModel, VM.Action == Action {
        return self.bind(to: viewModel.dispatcher, errorTranslator: viewModel.errorTranslator, actionTransformer: actionTransformer)
    }
    
    fileprivate func bind<Action>(to dispatcher: PublishSubject<Action>, errorTranslator: ErrorTranslator, actionTransformer: @escaping (Async<Void>) -> Action) -> Disposable {
        return self.do(onSubscribe: {
                dispatcher.onNext(actionTransformer(Async.loading))
            })
            .subscribe(
                onCompleted: { [dispatcher] in
                    dispatcher.onNext(
                        actionTransformer(Async.success(()))
                    )
                },
                onError: { [dispatcher] error in
                    dispatcher.onNext(
                        actionTransformer(Async.fail(errorMessage: errorTranslator.translate(error: error)))
                    )
                }
        )
    }
}
