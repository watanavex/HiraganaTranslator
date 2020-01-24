//
//  TextRecognizeModel.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/24.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseMLVision

enum TextRecognizeError: Error {
    case recognizeFaild(cause: Error?)
}

protocol TextRecognizeModel {
    
    func recognize(_ uiImage: UIImage) -> Single<String>
    
}

class FirebaseTextRecognizeModel: TextRecognizeModel {
    
    func recognize(_ uiImage: UIImage) -> Single<String> {
        let vision = Vision.vision()
        
        let options = VisionCloudTextRecognizerOptions()
        options.languageHints = ["ja"]
        let textRecognizer = vision.cloudTextRecognizer(options: options)
        
        let visionImage = VisionImage(image: uiImage)

        return Single.create { emitter in
            textRecognizer.process(visionImage) { result, error in
                if let text = result?.text {
                    emitter(.success(text))
                }
                else {
                    emitter(.error(TextRecognizeError.recognizeFaild(cause: error)))
                }
            }
            return Disposables.create()
        }
    }
    
}
