//
//  ImageCollectionViewCell.swift
//  Matching App
//
//  Created by Naman Kedia on 6/14/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentImageView: UIImageView!
    
    func setHighlighted(selected: Bool) {
        if selected == true {
            self.alpha = 0.5
        } else {
            self.alpha = 1.0
        }
    }
    
    func setMatched() {
        UIView.transition(with: self.contentView, duration: 0.4, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
//            self.contentImageView.image = 
            }, completion: nil)
        self.alpha = 1.0
        self.isUserInteractionEnabled = false
    }
    
    func reset() {
        self.isUserInteractionEnabled = true
    }
  
    
}
