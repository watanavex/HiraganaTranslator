//
//  MenuViewControllerTests.swift
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

class MenuViewControllerTests: FBSnapshotTestCase {

    var testScheduler: TestScheduler!
    var viewController: MenuViewController!
    var viewModel: MockMenuViewModel!
    var alertService: AlertServiceStub!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        self.recordMode = HiraganaTranslatorTests.recordMode
        
        self.testScheduler = TestScheduler(initialClock: 0)
        
        self.viewModel = MockMenuViewModel(
                errorTranslator: ErrorTranslatorStub(),
                pasteBoardModel: PasteBoardModelImpl(),
                textRecognizeModel: MockTextRecognizeModel()
            )
            .withEnabledSuperclassSpy()
        self.viewModel.isStubEnable = true
        self.alertService = AlertServiceStub()
        
        self.viewController = MenuViewController(viewModel: self.viewModel, alertService: self.alertService)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window.rootViewController = self.viewController
        self.window.makeKeyAndVisible()
    }
    
    func test_カメラボタンをタップするとカメラへの画面遷移命令が通知されること() {
        stub(self.viewModel) { stub in
            stub.textRecognize(any()).thenDoNothing()
        }
        let transition = self.testScheduler.createObserver(MenuViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)
        
        self.viewController.cameraButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(transition.events, [.next(0, .camera)])
    }
    
    func test_クリップボードボタンをタップするとクリップボード取得メソッドがコールされること() {
        stub(self.viewModel) { stub in
            stub.getStringFromPasteboard().thenDoNothing()
        }
        
        let transition = self.testScheduler.createObserver(MenuViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)
        
        self.viewController.clipboardButton.sendActions(for: .touchUpInside)
        
        verify(self.viewModel, atLeastOnce()).getStringFromPasteboard()
    }
    
    func test_キーボードボタンをタップすると文字入力画面への遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(MenuViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)
        
        self.viewController.keyboardButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(transition.events, [.next(0, .textInput(initialText: ""))])
    }
    
    func test_クリップボード取得エラーが通知されるとアラートへの遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(MenuViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)
        
        var state = self.viewModel.initialState
        state.pasteboardResult = .fail(errorMessage: "error")
        self.viewModel.stateSubject.onNext(state)
        
        XCTAssertEqual(transition.events, [.next(0, .errorAlert("error"))])
    }
    
    func test_クリップボード取得成功が通知されると文章入力画面への遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(MenuViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)
        
        var state = self.viewModel.initialState
        state.pasteboardResult = .success("text")
        self.viewModel.stateSubject.onNext(state)
        
        XCTAssertEqual(transition.events, [.next(0, .textInput(initialText: "text"))])
    }
    
    func test_写真を撮影すると文字認識メソッドがコールされること() {
        stub(self.viewModel) { stub in
            stub.textRecognize(any()).thenDoNothing()
        }
        let image = UIImage()
        let imagePicker = UIImagePickerController()
        let info = [UIImagePickerController.InfoKey.originalImage: image as Any]
        self.viewController.imagePickerController(imagePicker, didFinishPickingMediaWithInfo: info)

        verify(self.viewModel, atLeastOnce()).textRecognize(equal(to: image))
    }
    
    func test_文字認識実行中が通知されるとLoadingViewが表示されること() {
        var state = self.viewModel.initialState
        state.textRecognizeResult = .loading
        self.viewModel.stateSubject.onNext(state)
        
        XCTAssertFalse(self.viewController.loadingView.isHidden)
    }
    
    func test_文字認識実行中以外が通知されるとLoadingViewが非表示になること() {
        var state = self.viewModel.initialState
        state.textRecognizeResult = .uninitialized
        self.viewModel.stateSubject.onNext(state)
        
        XCTAssertTrue(self.viewController.loadingView.isHidden)
    }
    
    func test_文字認識エラーが通知されるとアラートへの画面遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(MenuViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)

        
        var state = self.viewModel.initialState
        state.textRecognizeResult = .fail(errorMessage: "error")
        self.viewModel.stateSubject.onNext(state)
        
        XCTAssertEqual(transition.events, [.next(0, .errorAlert("error"))])
    }
    
    func test_文字認識成功が通知されると文章入力画面への遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(MenuViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)

        
        var state = self.viewModel.initialState
        state.textRecognizeResult = .success("text")
        self.viewModel.stateSubject.onNext(state)
        
        XCTAssertEqual(transition.events, [.next(0, .textInput(initialText: "text"))])
    }
    
    func test_snapshot() {
        snapshot(self.window)
    }
}
