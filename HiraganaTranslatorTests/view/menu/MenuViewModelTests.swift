//
//  MenuViewModelTests.swift
//  HiraganaTranslatorTests
//
//  Created by Yohta Watanave on 2020/01/25.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import Cuckoo
@testable import HiraganaTranslator

class MenuViewModelTests: XCTestCase {

    var testScheduler: TestScheduler!
    var viewModel: MenuViewModel!
    var pasteBoardModel: MockPasteBoardModel!
    var textRecognizeModel: MockTextRecognizeModel!
    
    override func setUp() {
        self.testScheduler = TestScheduler(initialClock: 0)
        
        self.pasteBoardModel = MockPasteBoardModel()
        self.textRecognizeModel = MockTextRecognizeModel()
        self.viewModel = MenuViewModel(
            errorTranslator: ErrorTranslatorImpl(),
            pasteBoardModel: self.pasteBoardModel,
            textRecognizeModel: self.textRecognizeModel
        )
    }

    func test_クリップボード取得メソッドが成功を通知したらStateがsuccessに更新されること() {
        stub(self.pasteBoardModel) { stub in
            stub.string().then { Single.just("test test") }
        }
        let state = self.testScheduler.createObserver(Async<String>.self)
        _ = self.viewModel.state.map { $0.pasteboardResult }.subscribe(state)
        
        self.viewModel.getStringFromPasteboard()
        
        XCTAssertEqual(state.events, [
            .next(0, .uninitialized),
            .next(0, .loading),
            .next(0, .success("test test"))]
        )
    }

    func test_クリップボード取得メソッドがエラーを通知したらStateがfailに更新されること() {
        stub(self.pasteBoardModel) { stub in
            stub.string().then { Single.error(PasteBoardNoStringError()) }
        }
        let state = self.testScheduler.createObserver(Async<String>.self)
        _ = self.viewModel.state.map { $0.pasteboardResult }.subscribe(state)
        
        self.viewModel.getStringFromPasteboard()
        
        XCTAssertEqual(state.events, [
            .next(0, .uninitialized),
            .next(0, .loading),
            .next(0, .fail(errorMessage: "Error"))]
        )
    }
    
    func test_文字認識メソッドが成功を通知したらStateがsuccessに更新されること() {
        stub(self.textRecognizeModel) { stub in
            stub.recognize(any()).then { _ in Single.just("test test") }
        }
        let state = self.testScheduler.createObserver(Async<String>.self)
        _ = self.viewModel.state.map { $0.textRecognizeResult }.subscribe(state)
        
        self.viewModel.textRecognize(UIImage())
        
        XCTAssertEqual(state.events, [
            .next(0, .uninitialized),
            .next(0, .loading),
            .next(0, .success("test test"))]
        )
    }
    
    func test_文字認識メソッドがエラーを通知したらStateがfailに更新されること() {
        stub(self.textRecognizeModel) { stub in
            stub.recognize(any()).then { _ in Single.error(TextRecognizeError.recognizeFaild(cause: nil)) }
        }
        let state = self.testScheduler.createObserver(Async<String>.self)
        _ = self.viewModel.state.map { $0.textRecognizeResult }.subscribe(state)
        
        self.viewModel.textRecognize(UIImage())
        
        XCTAssertEqual(state.events, [
            .next(0, .uninitialized),
            .next(0, .loading),
            .next(0, .fail(errorMessage: "Error"))]
        )
    }
}
