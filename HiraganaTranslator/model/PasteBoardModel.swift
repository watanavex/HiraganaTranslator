//
//  PasteBoardModel.swift
//  HiraganaTranslator
//
//  Created by susan on 2020/01/24.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit
import RxSwift
import MobileCoreServices

protocol PasteBoardModel {
    func string() -> Single<String>
}

struct PasteBoardNoStringError: Error { }

class PasteBoardModelImpl: PasteBoardModel {
    
    func string() -> Single<String> {
        return Single.deferred {
            let value = UIPasteboard.general.value(forPasteboardType: kUTTypeUTF8PlainText as String)
            
            guard let planeText = value as? String else {
                return Single.error(PasteBoardNoStringError())
            }
            if planeText.isEmpty {
                return Single.error(PasteBoardNoStringError())
            }
            
            return Single.just(planeText)
        }
    }
}
