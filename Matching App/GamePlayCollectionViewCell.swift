//
//  GamePlayCollectionViewCell.swift
//  Matching App
//
//  Created by Naman Kedia on 7/5/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//
// Superclass for both Text and Image Cells. Holds a boolean matched, which indicates whether the cell is already matched.

import UIKit

class GamePlayCollectionViewCell: UICollectionViewCell {
    
    var matched = false {
        didSet {
            layoutCustomContentView(animated: true)
            self.isUserInteractionEnabled = !matched
        }
    }
    
    var paused: Bool = false {
        didSet {
            layoutCustomContentView(animated: false)
        }
    }
    
    var currentlySelected: Bool = false {
        didSet {
            layoutCustomContentView(animated: true)
        }
    }
    
    func customContentView() -> UIView? {
        return nil
    }
    
    func layoutCustomContentView(animated: Bool) {
        if (animated) {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.beginFromCurrentState, animations: {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let customContentView = self.customContentView() {
            var alpha: CGFloat = 1.0
            var scale: CGFloat = 1.0
            if (self.currentlySelected) {
                scale *= 0.9
                alpha *= 0.5
            }
            if (matched || paused) {
                scale *= 0.5
                alpha *= 0
            }
            
            customContentView.transform = CGAffineTransform(scaleX: scale, y: scale)
            customContentView.alpha = alpha
            
            customContentView.layer.cornerRadius = 20
            customContentView.clipsToBounds = true
        }
    }
    
    func reset() {
        matched = false
        currentlySelected = false
    }
}

// function to shake the cards to indicate an incorrect answer. 
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.duration = 0.6
        animation.values = [-10.0, 10.0, -8.0, 8.0, -6.0, 6.0, -4, 4.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}



