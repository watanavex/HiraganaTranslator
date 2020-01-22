//
//  XMLParserTests.swift
//  HiraganaTranslatorTests
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import XCTest
@testable import HiraganaTranslator

class XMLParserTests: XCTestCase {
    
    func test_YahooAPIの正しいフォーマットのXMLをパースできること() {
        let data = """
        <?xml version="1.0" encoding="UTF-8"?>
        <ResultSet xmlns="urn:yahoo:jp:jlp:FuriganaService" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:yahoo:jp:jlp:FuriganaService https://jlp.yahooapis.jp/FuriganaService/V1/furigana.xsd">
          <Result>
            <WordList>
              <Word>
                <Surface>魑魅魍魎</Surface>
                <Furigana>ちみもうりょう</Furigana>
                <Roman>timimouryou</Roman>
              </Word>
              <Word>
                <Surface>が</Surface>
                <Furigana>が</Furigana>
                <Roman>ga</Roman>
              </Word>
              <Word>
                <Surface>やって来る</Surface>
                <Furigana>やってくる</Furigana>
                <Roman>yattekuru</Roman>
                <SubWordList>
                  <SubWord>
                    <Surface>やって</Surface>
                    <Furigana>やって</Furigana>
                    <Roman>yatte</Roman>
                  </SubWord>
                  <SubWord>
                    <Surface>来</Surface>
                    <Furigana>く</Furigana>
                    <Roman>ku</Roman>
                  </SubWord>
                  <SubWord>
                    <Surface>る</Surface>
                    <Furigana>る</Furigana>
                    <Roman>ru</Roman>
                  </SubWord>
                </SubWordList>
              </Word>
            </WordList>
          </Result>
        </ResultSet>
        """.data(using: .utf8)!
        let words = try! parseXML(data: data)
        XCTAssertEqual(words, [
            Word(surface: "魑魅魍魎", furigana: "ちみもうりょう"),
            Word(surface: "が", furigana: "が"),
            Word(surface: "やって来る", furigana: "やってくる")
        ])
    }
    
    func test_XMLでないDataを渡すとinvalidDataエラーがthrowされること() {
        XCTAssertThrowsError(try parseXML(data: Data())) { error in
            XCTAssertTrue(error is XMLParseError)
            
            switch error as! XMLParseError {
            case .invalidData: break
            default: XCTFail("error is not 'invalidData'")
            }
        }
    }
    
    func test_ルートノード（ResultSet）が存在しないとinvalidXMLエラーがthrowされること() {
        let data = #"{ "key" : "value" }"#.data(using: .utf8)!
        XCTAssertThrowsError(try parseXML(data: data)) { error in
            XCTAssertTrue(error is XMLParseError)
            
            switch error as! XMLParseError {
            case .invalidXML(let nodeName): XCTAssertEqual(nodeName, "Root")
            default: XCTFail("error is not 'invalidData'")
            }
        }
    }
    
    func test_Resultノードが存在しないとinvalidXMLエラーがthrowされること() {
        let data = "<ResultSet></ResultSet>".data(using: .utf8)!
        XCTAssertThrowsError(try parseXML(data: data)) { error in
            XCTAssertTrue(error is XMLParseError)
            
            switch error as! XMLParseError {
            case .invalidXML(let nodeName): XCTAssertEqual(nodeName, "ResultSet")
            default: XCTFail("error is not 'invalidData'")
            }
        }
    }
    
    func test_WordListノードが存在しないとinvalidXMLエラーがthrowされること() {
        let data = "<ResultSet><Result></Result></ResultSet>".data(using: .utf8)!
        XCTAssertThrowsError(try parseXML(data: data)) { error in
            XCTAssertTrue(error is XMLParseError)
            
            switch error as! XMLParseError {
            case .invalidXML(let nodeName): XCTAssertEqual(nodeName, "Result")
            default: XCTFail("error is not 'invalidData'")
            }
        }
    }
    
    func test_Surfaceノードが存在しないとinvalidXMLエラーがthrowされること() {
        let data = """
        <ResultSet>
          <Result>
            <WordList>
              <Word>
                <Furigana>ちみもうりょう</Furigana>
                <Roman>timimouryou</Roman>
              </Word>
            </WordList>
          </Result>
        </ResultSet>
        """.data(using: .utf8)!
        
        XCTAssertThrowsError(try parseXML(data: data)) { error in
            XCTAssertTrue(error is XMLParseError)
            
            switch error as! XMLParseError {
            case .invalidXML(let nodeName): XCTAssertEqual(nodeName, "Word")
            default: XCTFail("error is not 'invalidData'")
            }
        }
    }
    
    func test_Furiganaノードが存在しないとinvalidXMLエラーがthrowされること() {
        let data = """
        <ResultSet>
          <Result>
            <WordList>
              <Word>
                <Surface>魑魅魍魎</Surface>
                <Roman>timimouryou</Roman>
              </Word>
            </WordList>
          </Result>
        </ResultSet>
        """.data(using: .utf8)!
                
        XCTAssertThrowsError(try parseXML(data: data)) { error in
            XCTAssertTrue(error is XMLParseError)
            
            switch error as! XMLParseError {
            case .invalidXML(let nodeName): XCTAssertEqual(nodeName, "Word")
            default: XCTFail("error is not 'invalidData'")
            }
        }
    }
}
