//
//  ImageFlowLayout.swift
//  Matching App
//
//  Created by Naman Kedia on 7/26/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class ImageFlowLayout: UICollectionViewFlowLayout {
    
    let ZOOM_FACTOR:CGFloat = 0.2
    let ACTIVE_DISTANCE:CGFloat = 200
    
    var insertIndexPaths = NSMutableArray()
    var deleteIndexPaths = NSMutableArray()
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.sectionInset = UIEdgeInsetsMake(50, 100, 50, 100)
    }
    
    override func prepare() {
        let width = 400
        let height = 500
        self.itemSize = CGSize(width: width, height: height)
        self.minimumLineSpacing = 100
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesArray = super.layoutAttributesForElements(in: rect)
        var attributesArrayCopy = [UICollectionViewLayoutAttributes]()
        
        
        var visibleRect = CGRect()
        visibleRect.origin = self.collectionView!.contentOffset
        visibleRect.size = self.collectionView!.bounds.size
        
        for attributes in attributesArray! {
            let attributesCopy = attributes.copy() as! UICollectionViewLayoutAttributes
            if (attributes.frame.intersects(rect)) {
                let distance = visibleRect.midX - attributesCopy.center.x
                let normalizedDistance = distance / ACTIVE_DISTANCE
                if abs(distance) < 200 {
                    let zoom: CGFloat = 1 + ZOOM_FACTOR*(1.0-abs(normalizedDistance))
                    attributesCopy.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                    
                }
                attributesArrayCopy.append(attributesCopy)
            }
        }
        return attributesArrayCopy
        
    }
    
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjusment = CGFloat(MAXFLOAT)
        let horizontalCenter = proposedContentOffset.x + (self.collectionView!.bounds.width / 2.0)
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0.0, width: self.collectionView!.bounds.size.width, height: self.collectionView!.bounds.height)
        
        let array = layoutAttributesForElements(in: targetRect)
        
        for layoutAttributes in array! {
            let itemHorizontalCenter = layoutAttributes.center.x
            if abs(itemHorizontalCenter - horizontalCenter) < abs(CGFloat(offsetAdjusment)) {
                offsetAdjusment = itemHorizontalCenter - horizontalCenter
                
            }
        }
        return CGPoint(x: proposedContentOffset.x + offsetAdjusment, y: proposedContentOffset.y)
    }
    


}
