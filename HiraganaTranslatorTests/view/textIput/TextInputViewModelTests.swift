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
        stub(self.translateApi) { stub in
            stub.translate(sentence: any()).then { _ in Observable.just(Data()) }
        }
        stub(self.xmlParseModel) { stub in
            stub.parse(data: any()).then { _ in
                [Word(surface: "魑魅魍魎", furigana: "ちみもうりょう"),
                Word(surface: "が", furigana: "が"),
                Word(surface: "、", furigana: "、"),
                Word(surface: "やって来る", furigana: "やってくる")]
            }
        }
        
        let state = self.testScheduler.createObserver(Async<TranslateResult>.self)
        _ = self.viewModel.state.map { $0.translateResult }.subscribe(state)
        
        self.viewModel.translate(sentence: "魑魅魍魎が、やって来る")
        
        XCTAssertEqual(state.events, [
            .next(0, .uninitialized),
            .next(0, .loading),
            .next(0, .success(TranslateResult(
                surfaceWordIndexes: [0, 0, 0, 0, 1, 2, 3, 3, 3, 3, 3],
                furiganaWordIndexes: [0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 3, 3, 3, 3],
                surfaceWordInitialIndexes: [0, 4, 5, 6],
                furiganaWordInitialIndexes: [0, 7, 8, 9],
                surfaceCentence: "魑魅魍魎が、やって来る",
                furiganaCentence: "ちみもうりょうが、やってくる")))]
        )
        
        verify(self.translateApi, atLeastOnce()).translate(sentence: "魑魅魍魎が、やって来る")
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

        self.viewModel.translate(sentence: "sentence")

        XCTAssertEqual(state.events, [
            .next(0, .uninitialized),
            .next(0, .loading),
            .next(0, .fail(errorMessage: "Error"))]
        )
        
        verify(self.translateApi, atLeastOnce()).translate(sentence: "sentence")
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

        self.viewModel.translate(sentence: "sentence")

        XCTAssertEqual(state.events, [
            .next(0, .uninitialized),
            .next(0, .loading),
            .next(0, .fail(errorMessage: "Error"))]
        )
        
        verify(self.translateApi, atLeastOnce()).translate(sentence: "sentence")
        verifyNoMoreInteractions(self.translateApi)
        verify(self.xmlParseModel, atLeastOnce()).parse(data: equal(to: Data()))
        verifyNoMoreInteractions(self.xmlParseModel)
    }
}
