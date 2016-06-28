//
//  TextTVCollectionViewCell.swift
//  Matching App
//
//  Created by Naman Kedia on 6/27/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class TextTVCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    func setHighlighted(selected: Bool) {
        if selected == true {
            self.alpha = 0.5
        } else {
            self.alpha = 1.0
        }
    }
    
    func setMatched() {
        self.nameLabel.alpha = 0.0
        UIView.transition(with: self.contentView, duration: 0.4, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
            
            }, completion: nil)
        self.alpha = 1.0
        self.isUserInteractionEnabled = false
    }
    
    func incorrectShake() {
        self.shake()
        
    }
    
}
