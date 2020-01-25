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
    container.register(TranslateResultViewController.self) { (_, translateResult: TranslateResult) -> TranslateResultViewController in
        return TranslateResultViewController(translateResult: translateResult)
    }
    .inObjectScope(.transient)
}
