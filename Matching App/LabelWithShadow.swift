//
//  LabelWithShadow.swift
//  Matching App
//
//  Created by Naman Kedia on 7/5/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class LabelWithShadow: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.shadowOffset = CGSize(width: 0, height: 2);
        self.layer.shadowRadius = 4;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowColor = UIColor.black().cgColor;
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main().scale
    }
}

extension UIView {
    func addShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 2);
        self.layer.shadowRadius = 4;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowColor = UIColor.black().cgColor;
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main().scale

    }
}
