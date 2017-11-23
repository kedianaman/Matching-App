//
//  CircularCollectionViewLayout.swift
//  CircularCollectionView
//
//  Created by Naman Kedia on 7/25/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

// Class which allows the Collection View to be displayed like a spinning wheel. Adapted from raywenderlich.com.

import UIKit
class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    var angle: CGFloat = 0 {
        didSet {
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    override func copy(with zone: NSZone?) -> Any {
        let copiedAttributes: CircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
    
}

class CircularCollectionViewLayout: UICollectionViewLayout {
    var animatingBoundsChange = false
    let itemSize = CGSize(width: 360, height: 480)
    
    var angleAtExtreme: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ? -CGFloat(collectionView!.numberOfItems(inSection: 0)-1)*anglePerItem : 0
    }
    
    var angle: CGFloat {
        return angleAtExtreme*collectionView!.contentOffset.x/(collectionViewContentSize.width - collectionView!.bounds.width)
    }
    
    var radius: CGFloat = 1000 {
        didSet {
            invalidateLayout()
        }
    }
    
    var spacingMultiplier: CGFloat = 1.0 {
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        return atan(itemSize.width/radius) * spacingMultiplier
    }
    
    var attributesList = [CircularCollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width,
                          height: collectionView!.bounds.height)
            
        }
    }
    
    override func prepare() {
        super.prepare()
        let centerX = collectionView!.contentOffset.x + (collectionView!.bounds.width/2.0)
        let startIndex = 0
        let endIndex = collectionView!.numberOfItems(inSection: 0) - 1
        
        attributesList = (startIndex...endIndex).map { (i) -> CircularCollectionViewLayoutAttributes in
            let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            attributes.size = self.itemSize
            attributes.angle = self.angle + (self.anglePerItem*CGFloat(i))
            
            let anchorPoint = CGPoint(x: centerX, y: self.collectionView!.bounds.midY + radius)
            attributes.center = CGPoint(x: anchorPoint.x + radius * cos(.pi/2 - attributes.angle), y: anchorPoint.y - radius * sin(.pi/2 - attributes.angle))
            
            attributes.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            attributes.zIndex = i
            return attributes
        }
    }
    
    override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
        super.prepare(forAnimatedBoundsChange: oldBounds)
        animatingBoundsChange = true
    }
    
    override func finalizeAnimatedBoundsChange() {
        super.finalizeAnimatedBoundsChange()
        animatingBoundsChange = false
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if (animatingBoundsChange) {
            return nil
        }
        return super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if (animatingBoundsChange) {
            return nil
        }
        return super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            return attributesList[(indexPath as NSIndexPath).row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var finalContentOffset = proposedContentOffset
        let factor = -angleAtExtreme/(collectionViewContentSize.width - collectionView!.bounds.width)
        let proposedAngle = proposedContentOffset.x*factor
        let ratio = proposedAngle/anglePerItem
        var multiplier: CGFloat
        if (velocity.x > 0) {
            multiplier = ceil(ratio)
        } else if (velocity.x < 0) {
            multiplier = floor(ratio)
        } else {
            multiplier = round(ratio)
        }
        finalContentOffset.x = multiplier*anglePerItem/factor
        return finalContentOffset
    }
    
    

    func contentOffsetForIndex(index: Int) -> CGPoint {
        let factor = -angleAtExtreme/(collectionViewContentSize.width - collectionView!.bounds.width)
        return CGPoint(x: CGFloat(index) * anglePerItem / factor, y: 0)
    }
    
}
