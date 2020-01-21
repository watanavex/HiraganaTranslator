//
//  MenuViewController.swift
//  HiraganaTranslator
//
//  Created by C02W61D9HV2H on 2020/01/21.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var cameraButton: MenuButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradLayer = CAGradientLayer()
        gradLayer.frame = UIScreen.main.bounds
        gradLayer.colors = [
            #colorLiteral(red: 0.6024569869, green: 0.8282820582, blue: 0.9329900146, alpha: 1).cgColor,
            UIColor.white.cgColor,
        ]
//        gradLayer.colors = [
//            #colorLiteral(red: 0.02900779806, green: 0.0210517142, blue: 0.2218854725, alpha: 1).cgColor,
//            #colorLiteral(red: 0.03689582273, green: 0.0304875765, blue: 0.5850664377, alpha: 1).cgColor,
//        ]
        gradLayer.locations = [
            0.2,
            1
        ]
        view.layer.insertSublayer(gradLayer, at: 0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

@IBDesignable
class MenuButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let contentPadding = UIEdgeInsets(top: 16, left: 16, bottom: 8, right: 8)
        let imageTitlePadding: CGFloat = 16
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
