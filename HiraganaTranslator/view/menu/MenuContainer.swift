//
//  MenuContainer.swift
//  HiraganaTranslator
//
//  Created by susan on 2020/01/22
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//
import UIKit
import Swinject
import SwinjectAutoregistration

let sharedMenuContainer: Container = Container(parent: AppContainer.container) { container in
    container.autoregister(MenuViewModel.self, initializer: MenuViewModel.init)
        .inObjectScope(.transient)

    container.autoregister(MenuViewController.self, initializer: MenuViewController.init)
        .inObjectScope(.transient)
}
