//
//  TestAppDelegate.swift
//  HiraganaTranslatorTests
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit
@testable import HiraganaTranslator

class TestAppDelegate: AppDelegate {
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIView.setAnimationsEnabled(false)
        
        return true
    }
    
    override func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        config.delegateClass = TestSceneDelegate.self
        return config
    }
}

class TestSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    }
}
