//
//  MenuViewModel.swift
//  HiraganaTranslator
//
//  Created by susan on 2020/01/22
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//
import UIKit
import RxSwift

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
}
