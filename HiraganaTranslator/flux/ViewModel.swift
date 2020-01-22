//
//  ViewModel.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import Foundation
import RxSwift

private var currentStateKey = "currentState"
private var stateKey = "state"
private var disposeBagKey = "disposeBag"
private var dispatcherKey = "dispatcher"
private var stubKey = "stub"
private var stateSubjectKey = "stateSubject"

protocol ViewModel: class, AssociatedObjectStore {
    associatedtype Action
    associatedtype State
    
    var disposeBag: DisposeBag { get }
    var dispatcher: PublishSubject<Action> { get }
    var initialState: State { get }
    var currentState: State { get }
    var errorTranslator: ErrorTranslator { get }
    var state: Observable<State> { get }
    func reducer(state: State, action: Action) -> State
}

extension ViewModel {
    
    var disposeBag: DisposeBag {
        return self.associatedObject(forKey: &disposeBagKey, default: DisposeBag())
    }
    
    private(set) var currentState: State {
        get {
            return self.associatedObject(forKey: &currentStateKey, default: self.initialState)
        }
        set {
            self.setAssociatedObject(newValue, forKey: &currentStateKey)
        }
    }
    
    var dispatcher: PublishSubject<Action> {
        return self.associatedObject(forKey: &dispatcherKey, default: PublishSubject<Action>.init())
    }
    
    var state: Observable<State> {
        return self.associatedObject(forKey: &stateKey, default: self.createDefaultStream())
    }
    
    var stateSubject: BehaviorSubject<State> {
        return self.associatedObject(forKey: &stateSubjectKey, default: BehaviorSubject<State>(value: self.initialState))
    }
    
    var isStubEnable: Bool {
        get {
            return self.associatedObject(forKey: &stubKey, default: false)
        }
        set {
            #if DEBUG
            self.setAssociatedObject(newValue, forKey: &stubKey)
            #endif
        }
    }
    
    private func createDefaultStream() -> Observable<State> {
        #if DEBUG
        if self.isStubEnable {
            return self.stateSubject
                .do(onNext: { [weak self] state in
                    self?.currentState = state
                })
        }
        #endif
        let state = self.dispatcher
            .scan(self.initialState) { [weak self] state, action -> State in
                guard let `self` = self else { return state }
                return self.reducer(state: state, action: action)
            }
            .observeOn(MainScheduler.instance)
            .startWith(self.initialState)
            .do(onNext: { [weak self] state in
                self?.currentState = state
            })
            .replay(1)
        state.connect().disposed(by: self.disposeBag)
        return state
    }
}

protocol AutoGenerateViewModel: ViewModel {}
