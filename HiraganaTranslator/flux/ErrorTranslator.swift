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
        if let error = error as? TranslateApiInvalidParamsError {
            return self.translate(error: error)
        }
        else if let error = error as? TranslateApiImpl.CreateRequestFailed {
            return self.translate(error: error)
        }
        else if let error = error as? XMLParseError {
            return self.translate(error: error)
        }
        else if let error = error as? TextRecognizeError {
            return self.translate(error: error)
        }
        else if let error = error as? PasteBoardNoStringError {
            return self.translate(error: error)
        }
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            return "いんたーねっとに つなげてね"
        }
        return "えらーがはっせいしました"
    }
    
    func translate(error: TranslateApiInvalidParamsError) -> String {
        return "へんかんしたい ぶんしょうを にゅうりょくしてね"
    }
    
    func translate(error: TranslateApiImpl.CreateRequestFailed) -> String {
        return "へんかんに しっぱいしました"
    }
    
    func translate(error: XMLParseError) -> String {
        return "へんかんに しっぱいしました"
    }
    
    func translate(error: TextRecognizeError) -> String {
        return "じが よめませんでした"
    }
    
    func translate(error: PasteBoardNoStringError) -> String {
        return "へんかんしたい ぶんしょうを こぴーしてね"
    }
}
