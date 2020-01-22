//
//  CAGradientLayer+extension.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/23.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    func setSkyGradientColor() {
        self.colors = [
            R.color.skyColor1()!.cgColor,
            R.color.skyColor2()!.cgColor
        ]
        self.locations = [
            0.2,
            1.0
        ]
    }
    
}
