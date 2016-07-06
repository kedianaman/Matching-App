//
//  GamePlayCollectionViewCell.swift
//  Matching App
//
//  Created by Naman Kedia on 7/5/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class GamePlayCollectionViewCell: UICollectionViewCell {
    
    private var matched = false
    private var isCurrentlySelected = false
    
    func setHighlighted(selected: Bool) {
        if selected == true {
            isCurrentlySelected = true
            if self.transform.isIdentity {
                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    self.alpha = 0.5
                    }, completion: nil)
            }
        } else {
            isCurrentlySelected = false
            if self.transform.isIdentity == false {
                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.alpha = 1.0
                    }, completion: nil)
            }
            
        }
    }
    
    func setMatched() {
        matched = true
        UIView.transition(with: self.contentView, duration: 0.4, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        self.alpha = 1.0
        self.isUserInteractionEnabled = false
    }
    
    func reset() {
        if matched == true || isCurrentlySelected == true {
            self.alpha = 1.0
            self.isUserInteractionEnabled = true
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
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

