//
//  TextInputViewModel.swift
//  HiraganaTranslator
//
//  Created by susan on 2020/01/23
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//
import UIKit
import RxSwift

struct TranslateResult: Equatable {
    let words: [Word]
    // 配列のIndexは文字数、配列の要素は単語のIndex
    // N文字目はどの単語か？を判断するための配列
    let surfaceWordIndexes: [Int]
    let furiganaWordIndexes: [Int]
    let surfaceCentence: String
    let furiganaCentence: String
}

class TextInputViewModel: AutoGenerateViewModel {

    // MARK: - State
    struct State {
        var translateResult: Async<TranslateResult>
    }

    // MARK: - Members
    let initialState = State(translateResult: .uninitialized)
    let errorTranslator: ErrorTranslator
    let translateApi: TranslateApi
    let xmlParseModel: XMLParseModel

    init(errorTranslator: ErrorTranslator, translateApi: TranslateApi, xmlParseModel: XMLParseModel) {
        self.errorTranslator = errorTranslator
        self.translateApi = translateApi
        self.xmlParseModel = xmlParseModel
    }

    // MARK: - Processor
    func translate(sentence: String) {
        self.translateApi.translate(sentence: sentence)
            .asSingle()
            .map { [xmlParseModel] data in try xmlParseModel.parse(data: data) }
            .map { words -> TranslateResult in
                var surfaceWordIndexes = [Int]()
                var furiganaWordIndexes = [Int]()
                var furiganaCentence = ""
                
                words.enumerated().forEach { (offset: Int, word: Word) in
                    let currentSurfaceIndexes = [Int](repeating: word.surface.count, count: offset)
                    surfaceWordIndexes.append(contentsOf: currentSurfaceIndexes)
                    let currentFuriganaIndexes = [Int](repeating: word.furigana.count, count: offset)
                    furiganaWordIndexes.append(contentsOf: currentFuriganaIndexes)
                    furiganaCentence.append(contentsOf: word.furigana)
                }
                
                return TranslateResult(
                    words: words,
                    surfaceWordIndexes: surfaceWordIndexes,
                    furiganaWordIndexes: furiganaWordIndexes,
                    surfaceCentence: sentence,
                    furiganaCentence: furiganaCentence
                )
            }
            .bind(to: self) { .translateResult($0) }
            .disposed(by: self.disposeBag)
    }
}
