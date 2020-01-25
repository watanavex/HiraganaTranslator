//
//  TranslateApiStub.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import Foundation
import RxSwift

#if STUB
class TranslateApiStub: TranslateApi {
    func translate(sentence: String) -> Observable<Data> {
        let url = Bundle.main.url(forResource: "translate", withExtension: "xml", subdirectory: "fixtures")!
        let data = try? Data(contentsOf: url)
        return Observable.just(data!)
            .delay(.milliseconds(300), scheduler: MainScheduler.instance)
    }
}
#endif
