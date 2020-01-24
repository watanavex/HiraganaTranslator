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
    }

    // MARK: - Members
    let initialState = State(pasteboardResult: .uninitialized)
    let errorTranslator: ErrorTranslator
    let pasteBoardModel: PasteBoardModel

    init(errorTranslator: ErrorTranslator, pasteBoardModel: PasteBoardModel) {
        self.errorTranslator = errorTranslator
        self.pasteBoardModel = pasteBoardModel
    }

    // MARK: - Processor
    func getStringFromPasteboard() {
        self.pasteBoardModel.string()
            .bind(to: self) { .pasteboardResult($0) }
            .disposed(by: self.disposeBag)
    }
}
