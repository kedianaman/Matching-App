//
//  File.swift
//  Matching App
//
//  Created by Naman Kedia on 8/6/17.
//  Copyright © 2017 Naman Kedia. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addParalaxToView() {
        let amount = 10
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        self.addMotionEffect(group)
    }

}

