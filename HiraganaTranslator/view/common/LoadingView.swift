//
//  LoadingView.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/24.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit
import SnapKit

class LoadingView: UIView {

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.7)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor.systemOrange
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
