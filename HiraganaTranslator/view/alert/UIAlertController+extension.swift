//
//  UIAlertController+extension.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

/*
 
 参考元: https://github.com/devxoul/AlertReactor
 
 */

import UIKit
import RxSwift
import RxCocoa

protocol RxAlertActionType {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}

struct CloseAlertAction: RxAlertActionType {
    let title = "とじる"
    let style: UIAlertAction.Style = .default
}

enum YesOrNoAlertAction: RxAlertActionType {
    case ok
    case cancel
    
    var title: String {
        switch self {
        case .ok: return "はい"
        case .cancel: return "いいえ"
        }
    }
    var style: UIAlertAction.Style {
        switch self {
        case .ok: return .default
        case .cancel: return .cancel
        }
    }
}

extension UIAlertController {
    
    static func present<AlertAction: RxAlertActionType>(
        viewController: UIViewController,
        title: String? = nil,
        message: String,
        preferredStyle: UIAlertController.Style = .alert,
        animated: Bool = true,
        actions: [AlertAction]) -> Observable<AlertAction> {
        return Observable<AlertAction>.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            
            actions.map { rxAction in
                    UIAlertAction(title: rxAction.title, style: rxAction.style, handler: { _ in
                        observer.onNext(rxAction)
                        observer.onCompleted()
                    })
                }
                .forEach(alertController.addAction)
            
            viewController.present(alertController, animated: animated, completion: nil)
            
            return Disposables.create {
                alertController.dismiss(animated: animated, completion: nil)
            }
        }
    }
}
