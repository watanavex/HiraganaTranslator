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
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        self.recordMode = HiraganaTranslatorTests.recordMode
        
        self.testScheduler = TestScheduler(initialClock: 0)
        
        let translateResult = TranslateResult(
            surfaceWordIndexes: [0, 0],
            furiganaWordIndexes: [1, 1],
            surfaceWordInitialIndexes: [0],
            furiganaWordInitialIndexes: [0],
            surfaceCentence: "漢字",
            furiganaCentence: "かんじ")
        self.viewController = TranslateResultViewController(translateResult: translateResult)
        
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
        let translateResult = TranslateResult(
            surfaceWordIndexes: [0, 0],
            furiganaWordIndexes: [1, 1],
            surfaceWordInitialIndexes: [0],
            furiganaWordInitialIndexes: [0],
            surfaceCentence: "あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波。",
            furiganaCentence: "あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波。")

        
        self.viewController = TranslateResultViewController(translateResult: translateResult)
        self.window.rootViewController = self.viewController
        snapshot(self.window)
    }

}
