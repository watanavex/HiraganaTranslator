//
//  TranslateResultContainer.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/23
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//
import UIKit
import Swinject
import SwinjectAutoregistration

let sharedTranslateResultContainer: Container = Container(parent: AppContainer.container) { container in
    container.autoregister(TranslateResultViewModel.self, initializer: TranslateResultViewModel.init)
        .inObjectScope(.transient)

    container.register(TranslateResultViewController.self) { (resolver, translateResult: TranslateResult) -> TranslateResultViewController in
        let viewModel = resolver.resolve(TranslateResultViewModel.self)!
        let alertService = resolver.resolve(AlertService.self)!
        return TranslateResultViewController(viewModel: viewModel,
                                             alertService: alertService,
                                             translateResult: translateResult)
    }
    .inObjectScope(.transient)
}
