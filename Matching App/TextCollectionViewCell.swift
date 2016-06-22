//
//  TextCollectionViewCell.swift
//  Matching App
//
//  Created by Naman Kedia on 6/21/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class TextCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func setHighlighted(selected: Bool) {
        if selected == true {
            self.alpha = 0.5
        } else {
            self.alpha = 1.0
        }
    }
    
    func setMatched() {
        UIView.transition(with: self.contentView, duration: 0.4, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
            self.nameLabel.removeFromSuperview()
            }, completion: nil)
        self.alpha = 1.0
        self.isUserInteractionEnabled = false
    }
    
    func incorrectShake() {
        self.shake()
        
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.4
        animation.values = [-10.0, 10.0, -10.0, 10.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    
}
