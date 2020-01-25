//
//  TextInputViewControllerTests.swift
//  HiraganaTranslatorTests
//
//  Created by Yohta Watanave on 2020/01/23.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import Cuckoo
import FBSnapshotTestCase
@testable import HiraganaTranslator

class TextInputViewControllerTests: FBSnapshotTestCase {

    var testScheduler: TestScheduler!
    var viewController: TextInputViewController!
    var viewModel: MockTextInputViewModel!
    var alertService: AlertServiceStub!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        self.recordMode = HiraganaTranslatorTests.recordMode
        
        self.testScheduler = TestScheduler(initialClock: 0)
        
        self.viewModel = MockTextInputViewModel(
            errorTranslator: ErrorTranslatorStub(),
            translateApi: MockTranslateApi(),
            xmlParseModel: MockXMLParseModel())
        self.viewModel.isStubEnable = true
        self.alertService = AlertServiceStub()
        
        let initialText = "あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波。"
        self.viewController = TextInputViewController(viewModel: self.viewModel, alertService: self.alertService, initialText: initialText)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window.rootViewController = self.viewController
        self.window.makeKeyAndVisible()
    }
    
    func test_イニシャライザで渡された文字列がTextViewにセットされること() {
        let initialText = UUID().uuidString
        self.viewController = TextInputViewController(viewModel: self.viewModel, alertService: self.alertService, initialText: initialText)
        _ = self.viewController.view
        XCTAssertEqual(initialText, self.viewController.textView.text)
    }
    
    func test_もどるボタンをタップするとdismissの画面遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(TextInputViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)
        
        self.viewController.backButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(transition.events, [.next(0, .dismiss)])
    }
    
    func test_へんかんボタンをタップすると文字変換メソッドがコールされること() {
        stub(self.viewModel) { stub in
            stub.translate(sentence: any()).thenDoNothing()
        }
        
        self.viewController.textView.text = "test test"
        self.viewController.translateButton.sendActions(for: .touchUpInside)
        
        verify(self.viewModel, atLeastOnce()).translate(sentence: "test test")
    }
    
    func test_文章変換実行中が通知されるとLoadingViewが表示されること() {
        var state = self.viewModel.initialState
        state.translateResult = .loading
        self.viewModel.stateSubject.onNext(state)
        
        XCTAssertFalse(self.viewController.loadingView.isHidden)
    }
    
    func test_文章変換実行中以外が通知されるとLoadingViewが非表示になること() {
        var state = self.viewModel.initialState
        state.translateResult = .uninitialized
        self.viewModel.stateSubject.onNext(state)
        
        XCTAssertTrue(self.viewController.loadingView.isHidden)
    }
    
    func test_文章変換エラーが通知されるとアラートへの画面遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(TextInputViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)

        
        var state = self.viewModel.initialState
        state.translateResult = .fail(errorMessage: "error")
        self.viewModel.stateSubject.onNext(state)
        
        XCTAssertEqual(transition.events, [.next(0, .errorAlert("error"))])
    }
    
    func test_文章変換成功が通知されると文章入力画面への遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(TextInputViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)

        
        let result = TranslateResult(
            surfaceWordIndexes: [0, 0],
            furiganaWordIndexes: [1, 1],
            surfaceWordInitialIndexes: [0],
            furiganaWordInitialIndexes: [0],
            surfaceCentence: "漢字",
            furiganaCentence: "かんじ")
        var state = self.viewModel.initialState
        
        state.translateResult = .success(result)
        self.viewModel.stateSubject.onNext(state)
        
        XCTAssertEqual(transition.events, [.next(0, .translateResult(result))])
    }

    func test_snapshot() {
        snapshot(self.window)
    }
}
