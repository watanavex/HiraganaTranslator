//
//  ErrorTranslatorTests.swift
//  HiraganaTranslatorTests
//
//  Created by Yohta Watanave on 2020/01/25.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import XCTest
@testable import HiraganaTranslator

class ErrorTranslatorTests: XCTestCase {

    func test_TranslateApiInvalidParamsError() {
        let error = TranslateApiInvalidParamsError()
        let message = ErrorTranslatorImpl().translate(error: error)
        XCTAssertEqual(message, "へんかんしたい ぶんしょうを にゅうりょくしてね")
    }
    
    func test_CreateRequestFailed() {
        let error = TranslateApiImpl.CreateRequestFailed(cause: nil)
        let message = ErrorTranslatorImpl().translate(error: error)
        XCTAssertEqual(message, "へんかんに しっぱいしました")
    }

    func test_XMLParseError() {
        var error = XMLParseError.invalidData
        var message = ErrorTranslatorImpl().translate(error: error)
        XCTAssertEqual(message, "へんかんに しっぱいしました")
        
        error = XMLParseError.invalidContent(nodeName: nil)
        message = ErrorTranslatorImpl().translate(error: error)
        XCTAssertEqual(message, "へんかんに しっぱいしました")
        
        error = XMLParseError.invalidXML(nodeName: nil)
        message = ErrorTranslatorImpl().translate(error: error)
        XCTAssertEqual(message, "へんかんに しっぱいしました")
    }
    
    func test_TextRecognizeError() {
        let error = TextRecognizeError.recognizeFaild(cause: nil)
        let message = ErrorTranslatorImpl().translate(error: error)
        XCTAssertEqual(message, "じが よめませんでした")
    }
    
    func test_PasteBoardNoStringError() {
        let error = PasteBoardNoStringError()
        let message = ErrorTranslatorImpl().translate(error: error)
        XCTAssertEqual(message, "へんかんしたい ぶんしょうを こぴーしてね")
    }
}
