//
//  TextInputContainer.swift
//  HiraganaTranslator
//
//  Created by susan on 2020/01/23
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//
import UIKit
import Swinject
import SwinjectAutoregistration

let sharedTextInputContainer: Container = Container(parent: AppContainer.container) { container in
    container.autoregister(TextInputViewModel.self, initializer: TextInputViewModel.init)
        .inObjectScope(.transient)

    container.autoregister(TextInputViewController.self, initializer: TextInputViewController.init)
        .inObjectScope(.transient)
}
