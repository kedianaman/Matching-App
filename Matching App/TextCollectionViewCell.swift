//
//  TextCollectionViewCell.swift
//  Matching App
//
//  Created by Naman Kedia on 6/21/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//
// Collection View Cell for the Text. 

import UIKit

class TextCollectionViewCell: GamePlayCollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func customContentView() -> UIView? {
        return self.nameLabel
    }
}



