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
    static let container = Container(defaultObjectScope: .container) { container in
        container.autoregister(ErrorTranslator.self, initializer: ErrorTranslatorImpl.init)
        container.autoregister(AlertService.self, initializer: AlertServiceImpl.init)
    }
}
