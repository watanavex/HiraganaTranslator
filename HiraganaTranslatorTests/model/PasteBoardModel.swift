//
//  PasteBoardModel.swift
//  HiraganaTranslatorTests
//
//  Created by Yohta Watanave on 2020/01/25.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import XCTest
import MobileCoreServices
import RxBlocking
@testable import HiraganaTranslator

class PasteBoardModel: XCTestCase {

    override func setUp() {
        UIPasteboard.general.strings = []
        UIPasteboard.general.images = []
    }
    
    func test_共有クリップボードに格納されている文字列が取得出来ること() {
        let string = UUID().uuidString
        UIPasteboard.general.string = string
        let model = PasteBoardModelImpl()
        
        XCTAssertEqual(string, try! model.string().toBlocking().first())
    }
    
    func test_共有クリップボードに空文字が格納されているとエラーを通知すること() {
        UIPasteboard.general.string = ""
        let model = PasteBoardModelImpl()
        
        XCTAssertThrowsError(try model.string().toBlocking().first()) { error in
            XCTAssertTrue(error is PasteBoardNoStringError)
        }
    }


    func test_共有クリップボードに文字列が格納されていないとエラーを通知すること() {
        UIPasteboard.general.image = UIImage()
        let model = PasteBoardModelImpl()
        
        XCTAssertThrowsError(try model.string().toBlocking().first()) { error in
            XCTAssertTrue(error is PasteBoardNoStringError)
        }
    }
}
