//
//  TranslateResultViewControllerTests.swift
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

class TranslateResultViewControllerTests: FBSnapshotTestCase {

    var testScheduler: TestScheduler!
    var viewController: TranslateResultViewController!
    var viewModel: TranslateResultViewModel!
    var alertService: AlertServiceStub!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        self.recordMode = HiraganaTranslatorTests.recordMode
        
        self.testScheduler = TestScheduler(initialClock: 0)
        
        self.viewModel = TranslateResultViewModel(errorTranslator: ErrorTranslatorImpl())
        self.viewModel.isStubEnable = true
        self.alertService = AlertServiceStub()
        
        self.viewController = TranslateResultViewController(viewModel: self.viewModel, alertService: self.alertService)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window.rootViewController = self.viewController
        self.window.makeKeyAndVisible()
    }
    
    func test_ぶんしょうをなおすボタンをタップするとdismissの画面遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(TranslateResultViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)
        
        self.viewController.backButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(transition.events, [.next(0, .dismiss)])
    }
    
    func test_はじめにもどるボタンをタップすると変換結果の画面遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(TranslateResultViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)
        
        self.viewController.backToTopButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(transition.events, [.next(0, .menu)])
    }
    
    func test_snapshot() {
        snapshot(self.window)
    }

}
