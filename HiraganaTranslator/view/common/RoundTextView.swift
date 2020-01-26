//
//  RoundTextView.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/23.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit

@IBDesignable
class RoundTextView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setup()
    }
    
    private func setup() {
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray.cgColor
    }
}
