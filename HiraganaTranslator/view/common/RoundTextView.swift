//
//  RoundTextView.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/23.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit

class RoundTextView: UITextView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setup()
    }
    
    private func setup() {
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray.cgColor
    }
}
