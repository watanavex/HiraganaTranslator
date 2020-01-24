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

    container.register(TextInputViewController.self) { (resolver, initialText: String) -> TextInputViewController in
        let viewModel = resolver.resolve(TextInputViewModel.self)!
        let alertService = resolver.resolve(AlertService.self)!
        return TextInputViewController(viewModel: viewModel, alertService: alertService, initialText: initialText)
    }
    .inObjectScope(.transient)
}
