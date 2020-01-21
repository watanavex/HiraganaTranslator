//
//  ViewController.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/20.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit
import TesseractOCR
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var primaryTextView: UITextView!
    @IBOutlet weak var secondaryTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let tesseract = G8Tesseract(language: "jpn")
        let image = R.image.sample()!
        print(image)
        tesseract?.image = R.image.sample()
        print(tesseract?.recognizedText ?? "nil")

        let string1 = ["1漢字", "かな交じり", "文", "に", "ふりがな", "を", "振ること。",
                       "2漢字", "かな交じり", "文", "に", "ふりがな", "を", "振ること。",
                       "3漢字", "かな交じり", "文", "に", "ふりがな", "を", "振ること。",
                       "4漢字", "かな交じり", "文", "に", "ふりがな", "を", "振ること。",
                       "5漢字", "かな交じり", "文", "に", "ふりがな", "を", "振ること。",
                       "6漢字", "かな交じり", "文", "に", "ふりがな", "を", "振ること。",
                       "7漢字", "かな交じり", "文", "に", "ふりがな", "を", "振ること。",
                       "8漢字", "かな交じり", "文", "に", "ふりがな", "を", "振ること。",
                       "9漢字", "かな交じり", "文", "に", "ふりがな", "を", "振ること。",
                       "10漢字", "かな交じり", "文", "に", "ふりがな", "を", "振ること。",
                       "11漢字", "かな交じり", "文", "に", "ふりがな", "を", "振ること。",
                       "12漢字", "かな交じり", "文", "に", "ふりがな", "を", "振ること。",
                       "13漢字", "かな交じり", "文", "に", "ふりがな", "を", "振ること。",
                       "14漢字", "かな交じり", "文", "に", "ふりがな", "を", "振ること。"]
        let string2 = ["1かんじ", "かなまじり", "ぶん", "に", "ふりがな", "を", "ふること。",
                       "2かんじ", "かなまじり", "ぶん", "に", "ふりがな", "を", "ふること。",
                       "3かんじ", "かなまじり", "ぶん", "に", "ふりがな", "を", "ふること。",
                       "4かんじ", "かなまじり", "ぶん", "に", "ふりがな", "を", "ふること。",
                       "5かんじ", "かなまじり", "ぶん", "に", "ふりがな", "を", "ふること。",
                       "6かんじ", "かなまじり", "ぶん", "に", "ふりがな", "を", "ふること。",
                       "7かんじ", "かなまじり", "ぶん", "に", "ふりがな", "を", "ふること。",
                       "8かんじ", "かなまじり", "ぶん", "に", "ふりがな", "を", "ふること。",
                       "9かんじ", "かなまじり", "ぶん", "に", "ふりがな", "を", "ふること。",
                       "10かんじ", "かなまじり", "ぶん", "に", "ふりがな", "を", "ふること。",
                       "11かんじ", "かなまじり", "ぶん", "に", "ふりがな", "を", "ふること。",
                       "12かんじ", "かなまじり", "ぶん", "に", "ふりがな", "を", "ふること。",
                       "13かんじ", "かなまじり", "ぶん", "に", "ふりがな", "を", "ふること。",
                       "14かんじ", "かなまじり", "ぶん", "に", "ふりがな", "を", "ふること。"]
        
        let sentences1 = Sentences.sentence(from: string1)
        let sentences2 = Sentences.sentence(from: string2)
        
        self.primaryTextView.text = sentences1.text
        self.secondaryTextView.text = sentences2.text
        
        syncScroll(primaryTextView: self.primaryTextView,
                   secondaryTextView: self.secondaryTextView,
                   primarySentences: sentences1,
                   secondarySentences: sentences2)
        syncScroll(primaryTextView: self.secondaryTextView,
                   secondaryTextView: self.primaryTextView,
                   primarySentences: sentences2,
                   secondarySentences: sentences1)
    }
}

func syncScroll(primaryTextView: UITextView, secondaryTextView: UITextView, primarySentences: Sentences, secondarySentences: Sentences) {
    _ = Observable.combineLatest(
            Observable.merge(
                primaryTextView.rx.willBeginDragging.map { _ in true },
                primaryTextView.rx.didEndDragging.map { willDecelerating in willDecelerating },
                primaryTextView.rx.didEndDecelerating.map { _ in false }
            ),
            primaryTextView.rx.didScroll.map { _ in primaryTextView.contentOffset }
        )
        .filter { (isDragging, _) in isDragging }
        .throttle(.milliseconds(300), latest: true, scheduler: MainScheduler.instance)
        .bind { (_, contentOffset) in
            let characterIndex = primaryTextView.layoutManager.characterIndex(for: contentOffset,
                                                                              in: primaryTextView.textContainer,
                                                                              fractionOfDistanceBetweenInsertionPoints: nil)
            
            let rangeIndex = primarySentences.words.firstIndex { range -> Bool in
                range.contains(characterIndex)
            }
            
            let secandaryCharacterRange = secondarySentences.words[rangeIndex!]
            let glyphRange = secondaryTextView.layoutManager.glyphRange(forCharacterRange: secandaryCharacterRange, actualCharacterRange: nil)
            var boundingRect = secondaryTextView.layoutManager.boundingRect(forGlyphRange: glyphRange, in: secondaryTextView.textContainer)
            boundingRect.origin.x += secondaryTextView.textContainerInset.left
            boundingRect.origin.y += secondaryTextView.textContainerInset.top
            
            var mark = secondaryTextView.subviews.first
            if (mark == nil) { mark = UIView(); secondaryTextView.addSubview(mark!) }
            mark!.frame = boundingRect
            mark!.backgroundColor = UIColor.blue
            
            secondaryTextView.setContentOffset(CGPoint(x: 0, y: boundingRect.minY), animated: true)
    }
}

struct Sentences {
    let text: String
    let words: [NSRange]
    
    static func sentence(from words: [String]) -> Sentences {
        var joinString = ""
        var ranges = [NSRange]()
        words.forEach { aWord in
            ranges.append(NSRange(location: joinString.count, length: aWord.count))
            joinString += aWord
        }
        return Sentences(text: joinString, words: ranges)
    }
}
