//
//  TextInputViewModelTests.swift
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

class TextInputViewModelTests: XCTestCase {

    var testScheduler: TestScheduler!
    var viewModel: TextInputViewModel!
    
    var translateApi: MockTranslateApi!
    var xmlParseModel: MockXMLParseModel!
    
    override func setUp() {
        self.testScheduler = TestScheduler(initialClock: 0)
        
        self.translateApi = MockTranslateApi()
        self.xmlParseModel = MockXMLParseModel()
        self.viewModel = TextInputViewModel(
            errorTranslator: ErrorTranslatorImpl(),
            translateApi: self.translateApi,
            xmlParseModel: self.xmlParseModel
        )
    }
    
    func test_文章変換メソッドとXMLパースが成功を通知したらStateがsuccessに更新されること() {
        let word = Word(surface: "", furigana: "")
        stub(self.translateApi) { stub in
            stub.translate(sentence: any()).then { _ in Observable.just(Data()) }
        }
        stub(self.xmlParseModel) { stub in
            stub.parse(data: any()).then { _ in [word] }
        }
        
        let state = self.testScheduler.createObserver(Async<TranslateResult>.self)
        _ = self.viewModel.state.map { $0.translateResult }.subscribe(state)
        
        self.viewModel.translate(sentence: "")
        
        XCTAssertEqual(state.events, [
            .next(0, .uninitialized),
            .next(0, .loading),
            .next(0, .success(TranslateResult(
                surfaceWordIndexes: [],
                furiganaWordIndexes: [],
                surfaceWordInitialIndexes: [0],
                furiganaWordInitialIndexes: [0],
                surfaceCentence: "",
                furiganaCentence: "")))]
        )
        
        verify(self.translateApi, atLeastOnce()).translate(sentence: "")
        verifyNoMoreInteractions(self.translateApi)
        verify(self.xmlParseModel, atLeastOnce()).parse(data: equal(to: Data()))
        verifyNoMoreInteractions(self.xmlParseModel)
    }

    func test_文章変換メソッドがエラーを通知したらStateがfailに更新されること() {
        let word = Word(surface: "", furigana: "")
        stub(self.translateApi) { stub in
            stub.translate(sentence: any())
                .then { _ in Observable<Data>.error(TranslateApiInvalidParamsError()) }
        }
        stub(self.xmlParseModel) { stub in
            stub.parse(data: any()).then { _ in [word] }
        }
        
        let state = self.testScheduler.createObserver(Async<TranslateResult>.self)
        _ = self.viewModel.state.map { $0.translateResult }.subscribe(state)

        self.viewModel.translate(sentence: "")

        XCTAssertEqual(state.events, [
            .next(0, .uninitialized),
            .next(0, .loading),
            .next(0, .fail(errorMessage: "Error"))]
        )
        
        verify(self.translateApi, atLeastOnce()).translate(sentence: "")
        verifyNoMoreInteractions(self.translateApi)
        verifyNoMoreInteractions(self.xmlParseModel)
    }

    func test_XMLパースがエラーを通知したらStateがfailに更新されること() {
        stub(self.translateApi) { stub in
            stub.translate(sentence: any()).then { _ in Observable.just(Data()) }
        }
        stub(self.xmlParseModel) { stub in
            stub.parse(data: any()).thenThrow(XMLParseError.invalidData)
        }
        
        let state = self.testScheduler.createObserver(Async<TranslateResult>.self)
        _ = self.viewModel.state.map { $0.translateResult }.subscribe(state)

        self.viewModel.translate(sentence: "")

        XCTAssertEqual(state.events, [
            .next(0, .uninitialized),
            .next(0, .loading),
            .next(0, .fail(errorMessage: "Error"))]
        )
        
        verify(self.translateApi, atLeastOnce()).translate(sentence: "")
        verifyNoMoreInteractions(self.translateApi)
        verify(self.xmlParseModel, atLeastOnce()).parse(data: equal(to: Data()))
        verifyNoMoreInteractions(self.xmlParseModel)
    }
}
