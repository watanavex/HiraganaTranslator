//
//  ErrorTranslator.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import Foundation

protocol ErrorTranslator {
    func translate(error: Error) -> String
}

class ErrorTranslatorImpl: ErrorTranslator {
    
    func translate(error: Error) -> String {
        return "Error"
    }
    
}
