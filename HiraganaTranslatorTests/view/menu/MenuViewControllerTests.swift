//
//  MenuViewControllerTests.swift
//  HiraganaTranslatorTests
//
//  Created by Yohta Watanave on 2020/01/23.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import HiraganaTranslator

class MenuViewControllerTests: XCTestCase {

    var testScheduler: TestScheduler!
    var viewController: MenuViewController!
    var viewModel: MenuViewModel!
    var alertService: AlertServiceStub!
    var window: UIWindow!
    
    override func setUp() {
        self.testScheduler = TestScheduler(initialClock: 0)
        
        self.viewModel = MenuViewModel(errorTranslator: ErrorTranslatorImpl())
        self.viewModel.isStubEnable = true
        self.alertService = AlertServiceStub()
        
        self.viewController = MenuViewController(viewModel: self.viewModel, alertService: self.alertService)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window.rootViewController = self.viewController
        self.window.makeKeyAndVisible()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_カメラボタンをタップするとカメラへの画面遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(MenuViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)
        
        self.viewController.cameraButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(transition.events, [.next(0, .camera)])
    }
    
    func test_クリップボードボタンをタップすると文字入力画面への遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(MenuViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)
        
        self.viewController.clipboardButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(transition.events, [.next(0, .textInput)])
    }
    
    func test_キーボードボタンをタップすると文字入力画面への遷移命令が通知されること() {
        let transition = self.testScheduler.createObserver(MenuViewController.Transition.self)
        _ = self.viewController.transitionDispatcher
            .bind(to: transition)
        
        self.viewController.keyboardButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(transition.events, [.next(0, .textInput)])
    }
}
