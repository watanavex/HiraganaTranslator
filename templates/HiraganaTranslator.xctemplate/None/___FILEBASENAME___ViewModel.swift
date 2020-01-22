//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___USERNAME___ on ___DATE___
//  ___COPYRIGHT___
//
import UIKit
import RxSwift

class ___VARIABLE_productName___ViewModel: AutoGenerateViewModel {

    // MARK: - State
    struct State {
        var request: Async<Void>
    }

    // MARK: - Members
    let initialState = State(request: Async.uninitialized)
    let errorTranslator: ErrorTranslator

    init(errorTranslator: ErrorTranslator) {
        self.errorTranslator = errorTranslator
    }

    // MARK: - Processor
}
