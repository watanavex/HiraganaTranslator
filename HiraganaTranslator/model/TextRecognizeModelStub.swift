//
//  TextRecognizeModelStub.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/24.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit
import RxSwift

#if STUB
class TextRecognizeModelStub: TextRecognizeModel {
    
    func recognize(_ uiImage: UIImage) -> Single<String> {
        return Single.just("魑魅魍魎がやって来る")
            .delay(.milliseconds(300), scheduler: MainScheduler.instance)
    }
    
}
#endif
