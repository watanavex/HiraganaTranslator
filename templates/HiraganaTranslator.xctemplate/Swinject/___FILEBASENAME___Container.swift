//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___USERNAME___ on ___DATE___
//  ___COPYRIGHT___
//
import UIKit
import Swinject
import SwinjectAutoregistration

let shared___VARIABLE_productName___Container: Container = Container(parent: ___VARIABLE_parentContainer___) { container in
    container.autoregister(___VARIABLE_productName___ViewModel.self, initializer: ___VARIABLE_productName___ViewModel.init)
        .inObjectScope(.transient)

    container.autoregister(___VARIABLE_productName___ViewController.self, initializer: ___VARIABLE_productName___ViewController.init)
        .inObjectScope(.transient)
}
