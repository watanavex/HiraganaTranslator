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
    /// [漢字交じり文章] 配列のIndexは文字数、配列の要素は単語のIndex
    /// N文字目はどの単語か？を判断するための配列
    let surfaceWordIndexes: [Int]
    /// [ひらがな変換文章] 配列のIndexは文字数、配列の要素は単語のIndex
    /// N文字目はどの単語か？を判断するための配列
    let furiganaWordIndexes: [Int]
    
    /// [漢字交じり文章] 配列のIndexは単語のIndex、配列の要素数は単語先頭文字が文章全体で何文字目か
    /// N番目の単語は何文字目から始まるかを判断するための配列
    let surfaceWordInitialIndexes: [Int]
    /// [ひらがな変換文章] 配列のIndexは単語のIndex、配列の要素数は単語先頭文字が文章全体で何文字目か
    /// N番目の単語は何文字目から始まるかを判断するための配列
    let furiganaWordInitialIndexes: [Int]
    
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
                var surfaceWordInitialIndexes = [Int]()
                var surfaceCentence = ""
                var furiganaWordIndexes = [Int]()
                var furiganaWordInitialIndexes = [Int]()
                var furiganaCentence = ""
                
                words.enumerated().forEach { (offset: Int, word: Word) in
                    let currentSurfaceIndexes = [Int](repeating: offset, count: word.surface.count)
                    surfaceWordIndexes.append(contentsOf: currentSurfaceIndexes)
                    surfaceWordInitialIndexes.append(surfaceCentence.count)
                    surfaceCentence.append(contentsOf: word.surface)
                    
                    let currentFuriganaIndexes = [Int](repeating: offset, count: word.furigana.count)
                    furiganaWordIndexes.append(contentsOf: currentFuriganaIndexes)
                    furiganaWordInitialIndexes.append(furiganaCentence.count)
                    furiganaCentence.append(contentsOf: word.furigana)
                }
                
                return TranslateResult(
                    surfaceWordIndexes: surfaceWordIndexes,
                    furiganaWordIndexes: furiganaWordIndexes,
                    surfaceWordInitialIndexes: surfaceWordInitialIndexes,
                    furiganaWordInitialIndexes: furiganaWordInitialIndexes,
                    surfaceCentence: surfaceCentence,
                    furiganaCentence: furiganaCentence
                )
            }
            .bind(to: self) { .translateResult($0) }
            .disposed(by: self.disposeBag)
    }
}
