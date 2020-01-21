//
//  ViewController.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/20.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController, G8TesseractDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tesseract = G8Tesseract(language: "jpn")
        tesseract?.delegate = self
        tesseract?.image = R.image.sample()
        print(tesseract?.recognizedText)
    }

}
