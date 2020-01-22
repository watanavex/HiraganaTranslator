//
//  TestUtil.swift
//  HiraganaTranslatorTests
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import FBSnapshotTestCase

extension XCTestCase {
    func wait(_ time: Double) {
        let expection = self.expectation(description: #function)
        _ = Observable<Int>.timer(RxTimeInterval.milliseconds(1 + Int(time) * 1_000), scheduler: SerialDispatchQueueScheduler(qos: .default))
            .bind { _ in
                expection.fulfill()
            }
        self.wait(for: [expection], timeout: time * 2)
    }

    func waitFor(timeout: TimeInterval = 3.0, block: @escaping ()->Bool) {
        let expection = self.expectation(description: #function)
        _ = Observable<Int>.interval(RxTimeInterval.milliseconds(50), scheduler: SerialDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
            .filter { _ in block() }
            .take(1)
            .bind { _ in
                expection.fulfill()
        }
        self.wait(for: [expection], timeout: timeout * 2)
    }

}

let recordMode = false
extension FBSnapshotTestCase {
    
    func snapshot(_ view: UIView, identifier: String = "") {
        let size = "\(Int(view.bounds.width))x\(Int(view.bounds.height))"
        
        func mode() -> String {
            switch view.overrideUserInterfaceStyle {
            case .dark: return "dark"
            default: return "light"
            }
        }
        FBSnapshotVerifyView(view, identifier: "\(identifier)_\(mode())_\(size)")
    }
    
}
