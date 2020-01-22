//
//  main.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    NSStringFromClass(UIApplication.self),
    NSStringFromClass(NSClassFromString("HiraganaTranslatorTests.TestAppDelegate") ?? AppDelegate.self)
)
