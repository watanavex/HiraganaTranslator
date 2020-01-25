//
//  TranslateResultViewController+TextView.swift
//  HiraganaTranslator
//
//  Created by C02W61D9HV2H on 2020/01/24.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit
import RxSwift

extension TranslateResultViewController {
    
    func setupSyncScroll() {
        self.syncScroll(primaryTextView: self.surfaceTextView,
                        secondaryTextView: self.furiganaTextView,
                        primarySentences: self.translateResult.surfaceCentence,
                        primaryWordIndexes: self.translateResult.surfaceWordIndexes,
                        secondaryWordBeginIndexes: self.translateResult.furiganaWordInitialIndexes)
        
        self.syncScroll(primaryTextView: self.furiganaTextView,
                        secondaryTextView: self.surfaceTextView,
                        primarySentences: self.translateResult.furiganaCentence,
                        primaryWordIndexes: self.translateResult.furiganaWordIndexes,
                        secondaryWordBeginIndexes: self.translateResult.surfaceWordInitialIndexes)
    }
    
    private func syncScroll(primaryTextView: UITextView, secondaryTextView: UITextView, primarySentences: String, primaryWordIndexes: [Int], secondaryWordBeginIndexes: [Int]) {
        primaryTextView.rx.didScrollByUser()
            .throttle(.milliseconds(300), latest: true, scheduler: MainScheduler.instance)
            .bind { contentOffset in
                let characterIndex = primaryTextView.layoutManager.characterIndex(for: contentOffset,
                                                                                  in: primaryTextView.textContainer,
                                                                                  fractionOfDistanceBetweenInsertionPoints: nil)
                
                let wordIndex = primaryWordIndexes[characterIndex]
                let secondaryCharactorIndex = secondaryWordBeginIndexes[wordIndex]
                
                let secandaryCharacterRange = NSRange(location: secondaryCharactorIndex, length: 1)
                let glyphRange = secondaryTextView.layoutManager.glyphRange(forCharacterRange: secandaryCharacterRange, actualCharacterRange: nil)
                
                var boundingRect = secondaryTextView.layoutManager.boundingRect(forGlyphRange: glyphRange, in: secondaryTextView.textContainer)
                boundingRect.origin.x += secondaryTextView.textContainerInset.left
                boundingRect.origin.y += secondaryTextView.textContainerInset.top
  
                // デバッグ用
                #if DEBUG
                let mark = secondaryTextView.subviews.first ?? {
                    let mark = UIView()
                    secondaryTextView.addSubview(mark)
                    return mark
                }()
                mark.frame = boundingRect
                mark.backgroundColor = UIColor.blue
                #endif
                
                secondaryTextView.setContentOffset(CGPoint(x: 0, y: boundingRect.minY), animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}

extension Reactive where Base: UIScrollView {
    
    fileprivate func didScrollByUser() -> Observable<CGPoint> {
        let dragAndDecelerate = Observable.merge(
            self.willBeginDragging.map { _ in true },
            self.didEndDragging.map { willDecelerating in willDecelerating },
            self.didEndDecelerating.map { _ in false }
        )
        return Observable.combineLatest(
                dragAndDecelerate,
                self.didScroll.map { [base] _ in base.contentOffset }
            )
            .filter { (isDragging, _) in isDragging }
            .map { (_, contentOffset) in contentOffset }
    }
    
}
