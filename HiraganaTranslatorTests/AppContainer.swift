//
//  AppContainer.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit
import Swinject
import SwinjectAutoregistration

struct AppContainer {
    private static let domainContainer = Container(defaultObjectScope: .container) { container in
        #if STUB
        container.autoregister(TextRecognizeModel.self, initializer: TextRecognizeModelStub.init)
        container.autoregister(TranslateApi.self, initializer: TranslateApiStub.init)
        #else
        container.autoregister(TextRecognizeModel.self, initializer: FirebaseTextRecognizeModel.init)
        container.autoregister(TranslateApi.self, initializer: TranslateApiImpl.init)
        #endif
    }
    
    static let container = Container(parent: domainContainer, defaultObjectScope: .container) { container in
        container.autoregister(ErrorTranslator.self, initializer: ErrorTranslatorImpl.init)
        container.autoregister(AlertService.self, initializer: AlertServiceImpl.init)
        container.autoregister(PasteBoardModel.self, initializer: PasteBoardModelImpl.init)
    }
}
