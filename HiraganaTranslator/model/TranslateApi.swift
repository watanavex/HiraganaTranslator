//
//  TranslateApi.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofire

protocol TranslateApi {
    func translate(sentence: String) -> Observable<Data>
}

class TranslateApiImpl: TranslateApi {
    
    struct CreateRequestFailed: Error {
        let cause: Error?
    }
    
    func translate(sentence: String) -> Observable<Data> {
        let request: URLRequest
        do {
            request = try RxAlamofire.urlRequest(.get,
                                                 "https://jlp.yahooapis.jp/FuriganaService/V1/furigana",
                                                 parameters: ["appid": R.string.secret.appId(), "sentence": sentence])
        }
        catch let error {
            return Observable.error(CreateRequestFailed(cause: error))
        }
        
        return URLSession.shared.rx.data(request: request)
    }
}
