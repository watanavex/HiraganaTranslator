//
//  MenuViewModel.swift
//  HiraganaTranslator
//
//  Created by susan on 2020/01/22
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//
import UIKit
import RxSwift
import MobileCoreServices

class MenuViewModel: AutoGenerateViewModel {
    
    // MARK: - State
    struct State {
        var pasteboardResult: Async<String>
        var textRecognizeResult: Async<String>
    }

    // MARK: - Members
    let initialState = State(
        pasteboardResult: .uninitialized,
        textRecognizeResult: .uninitialized
    )
    let errorTranslator: ErrorTranslator
    let pasteBoardModel: PasteBoardModel
    let textRecognizeModel: TextRecognizeModel

    init(errorTranslator: ErrorTranslator, pasteBoardModel: PasteBoardModel, textRecognizeModel: TextRecognizeModel) {
        self.errorTranslator = errorTranslator
        self.pasteBoardModel = pasteBoardModel
        self.textRecognizeModel = textRecognizeModel
    }

    // MARK: - Processor
    func getStringFromPasteboard() {
        self.pasteBoardModel.string()
            .bind(to: self) { .pasteboardResult($0) }
            .disposed(by: self.disposeBag)
    }

    func textRecognize(_ image: UIImage) {
        self.textRecognizeModel.recognize(image)
            .bind(to: self) { .textRecognizeResult($0) }
            .disposed(by: self.disposeBag)
    }
}
