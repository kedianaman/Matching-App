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
    
    private var matched = false
    private var isCurrentlySelected = false
    
    // Function which reduces the opacity and size of the cell, if the cell is highlighted.
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
    
    func isMatched() -> Bool {
        return matched
    }
    
    func setMatched() {
        matched = true
        UIView.animate(withDuration: 0.5 + Double(arc4random_uniform(5)) * 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.alpha = 0.0
        }, completion: nil)
        self.isUserInteractionEnabled = false
//        UIView.transition(with: self, duration: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: {
//            self.alpha = 0.0
//            }, completion: nil)
//        self.isUserInteractionEnabled = false
    }
    
    func reset() {

        if isCurrentlySelected == true || matched == true {
            self.isUserInteractionEnabled = true
            matched = false
            isCurrentlySelected = false

        }
    }
}

// function to shake the cards to indicate an incorrect answer. 
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.duration = 0.6
        animation.values = [-10.0, 10.0, -8.0, 8.0, -6.0, 6.0, -4, 4.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}



