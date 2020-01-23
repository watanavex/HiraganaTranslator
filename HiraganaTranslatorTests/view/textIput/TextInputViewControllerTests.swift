//
//  TextInputViewControllerTests.swift
//  HiraganaTranslatorTests
//
//  Created by Yohta Watanave on 2020/01/23.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import FBSnapshotTestCase
@testable import HiraganaTranslator

class TextInputViewControllerTests: FBSnapshotTestCase {

    var testScheduler: TestScheduler!
    var viewController: TextInputViewController!
    var viewModel: TextInputViewModel!
    var alertService: AlertServiceStub!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        self.recordMode = HiraganaTranslatorTests.recordMode
        
        self.testScheduler = TestScheduler(initialClock: 0)
        
        self.viewModel = TextInputViewModel(errorTranslator: ErrorTranslatorImpl())
        self.viewModel.isStubEnable = true
        self.alertService = AlertServiceStub()
        
        self.viewController = TextInputViewController(viewModel: self.viewModel, alertService: self.alertService)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window.rootViewController = self.viewController
        self.window.makeKeyAndVisible()
    }
    
    func test_もどるボタンをタップするとdismissの画面遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(TextInputViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)
        
        self.viewController.backButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(transition.events, [.next(0, .dismiss)])
    }
    
    func test_へんかんボタンをタップすると変換結果の画面遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(TextInputViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)
        
        self.viewController.translateButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(transition.events, [.next(0, .translateResult)])
    }

    func test_snapshot() {
        snapshot(self.window)
    }
}
