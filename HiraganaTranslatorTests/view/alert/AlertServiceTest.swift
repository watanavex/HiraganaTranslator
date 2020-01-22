//
//  AlertServiceTest.swift
//  HiraganaTranslatorTests
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import XCTest
import RxSwift
@testable import HiraganaTranslator

class AlertServiceTest: XCTestCase {

    var viewController: UIViewController!
    
    override func setUp() {
        self.viewController = UIApplication.shared.windows.first!.rootViewController!
        if let presentedViewController = self.viewController.presentedViewController {
            presentedViewController.dismiss(animated: false, completion: nil)
        }
        waitFor { self.viewController.presentedViewController == nil }
    }

    func test_presentメソッドから返却されるObservableを購読するとAlertControllerがPresentされること() {
        let alertService = AlertServiceImpl()
        let disposable = alertService.present(viewController: viewController,
                             message: "message",
                             actions: [CloseAlertAction()])
            .subscribe()
        
        XCTAssertNotNil(viewController.presentedViewController)
        XCTAssertTrue(viewController.presentedViewController is UIAlertController)
        
        disposable.dispose()
    }
    
    func test_presentメソッドから返却されるObservableを購読しないとAlertControllerがPresentされないこと() {
        let viewController = UIApplication.shared.windows.first!.rootViewController!
        let alertService = AlertServiceImpl()
        _ = alertService.present(viewController: viewController,
                             message: "message",
                             actions: [CloseAlertAction()])
        
        XCTAssertNil(viewController.presentedViewController)
    }
    
    func test_presentメソッドから返却されるObservableの購読をやめるとAlertControllerがDismissされること() {
        let viewController = UIApplication.shared.windows.first!.rootViewController!
        let alertService = AlertServiceImpl()
        let disposable = alertService.present(viewController: viewController,
                             message: "message",
                             actions: [CloseAlertAction()])
            .subscribe()
        
        XCTAssertNotNil(viewController.presentedViewController)
        disposable.dispose()
        waitFor { [viewController] in viewController.presentedViewController == nil }
        
        XCTAssertNil(viewController.presentedViewController)
    }

}
