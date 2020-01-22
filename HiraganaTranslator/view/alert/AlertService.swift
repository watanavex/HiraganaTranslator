//
//  AlertService.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit
import RxSwift

protocol AlertService {
    func present<AlertAction: RxAlertActionType>(viewController: UIViewController, message: String, actions: [AlertAction]) -> Observable<AlertAction>
    func present<AlertAction: RxAlertActionType>(viewController: UIViewController, title: String?, message: String, preferredStyle: UIAlertController.Style, actions: [AlertAction]) -> Observable<AlertAction>
}

open class AlertServiceImpl: AlertService {
    
    public init() {}
    
    func present<AlertAction: RxAlertActionType>(viewController: UIViewController, message: String, actions: [AlertAction]) -> Observable<AlertAction> {
        return UIAlertController.present(viewController: viewController, message: message, actions: actions)
    }
    
    func present<AlertAction: RxAlertActionType>(viewController: UIViewController, title: String?, message: String, preferredStyle: UIAlertController.Style, actions: [AlertAction]) -> Observable<AlertAction> {
        return UIAlertController.present(viewController: viewController, title: title, message: message, preferredStyle: preferredStyle, animated: true, actions: actions)
    }
    
}

#if DEBUG
open class AlertServiceStub: AlertService {
    
    public init() {}
    
    open var alertSubject = PublishSubject<Any>()
    
    open var lastViewController: UIViewController?
    open var lastMessage: String?
    open var lastActionTitles: [String]?
    open var lastStyle: UIAlertController.Style?
    
    func present<AlertAction: RxAlertActionType>(viewController: UIViewController, message: String, actions: [AlertAction]) -> Observable<AlertAction> {
        self.lastViewController = viewController
        self.lastMessage = message
        self.lastActionTitles = actions.map { $0.title }
        self.lastStyle = .alert
        return self.alertSubject.map { $0 as! AlertAction }.take(1)
    }
    
    func present<AlertAction: RxAlertActionType>(viewController: UIViewController, title: String?, message: String, preferredStyle: UIAlertController.Style, actions: [AlertAction]) -> Observable<AlertAction> {
        self.lastViewController = viewController
        self.lastMessage = message
        self.lastActionTitles = actions.map { $0.title }
        self.lastStyle = preferredStyle
        return self.alertSubject.map { $0 as! AlertAction }.take(1)
    }
    
}
#endif
