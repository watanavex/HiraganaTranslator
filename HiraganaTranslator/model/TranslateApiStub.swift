//
//  TranslateApiStub.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import Foundation
import RxSwift

#if STUB
private let xmlData = """
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

class TranslateApiStub: TranslateApi {
    func translate(sentence: String) -> Observable<Data> {
        return Observable.just(xmlData)
            .delay(.milliseconds(300), scheduler: MainScheduler.instance)
    }
}
#endif
