//
//  ThemeButton.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/23.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit

@IBDesignable
class ThemeButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setup()
    }
    
    private func setup() {
        let themeColor = UIColor.systemOrange
        let highlightedColor = self.highlightedColor(from: themeColor)

        self.setTitleColor(themeColor, for: .normal)
        self.setTitleColor(highlightedColor, for: .highlighted)
        self.tintColor = themeColor
        self.titleLabel?.font = R.font.miniWakuwaku(size: 28)

        if self.image(for: .normal) != nil {
            let contentPadding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            let imageTitlePadding: CGFloat = 8
            self.contentEdgeInsets = UIEdgeInsets(
                top: contentPadding.top,
                left: contentPadding.left,
                bottom: contentPadding.bottom,
                right: contentPadding.right + imageTitlePadding
            )
            self.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: imageTitlePadding,
                bottom: 0,
                right: -imageTitlePadding
            )
        }
    }
    
    private func highlightedColor(from normalColor: UIColor) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor.systemOrange.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness * 0.6, alpha: alpha)
    }
}
