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

    enum PasteboardResult: Equatable {
        case uninitialized
        case some(pastBoardString: String)
        case fail(errorMessage: String)
    }
    
    // MARK: - State
    struct State {
        var pasteboardResult: PasteboardResult
    }

    // MARK: - Members
    let initialState = State(pasteboardResult: .uninitialized)
    let errorTranslator: ErrorTranslator

    init(errorTranslator: ErrorTranslator) {
        self.errorTranslator = errorTranslator
    }

    // MARK: - Processor
    func getStringFromPasteboard() {
        let errorMessage = "ひらがなに へんかんしたい ぶんしょうを こぴーしてね"
        self.dispatcher.onNext(.pasteboardResult(.uninitialized))
        
        let value = UIPasteboard.general.value(forPasteboardType: kUTTypeUTF8PlainText as String)
        guard let planeText = value as? String else {
            self.dispatcher.onNext(.pasteboardResult(.fail(errorMessage: errorMessage)))
            return
        }
        if planeText.isEmpty {
            self.dispatcher.onNext(.pasteboardResult(.fail(errorMessage: errorMessage)))
            return
        }
        self.dispatcher.onNext(.pasteboardResult(.some(pastBoardString: planeText)))
    }
}
