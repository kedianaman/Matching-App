//
//  CustomAnimation.swift
//  Matching App
//
//  Created by Naman Kedia on 8/7/17.
//  Copyright © 2017 Naman Kedia. All rights reserved.
//

import UIKit

class CustomAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from) as! CoverFlowViewController
        let toViewController = transitionContext.viewController(forKey: .to) as! GamePlayViewController
        containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.3, animations: {
            let collectionView = fromViewController.sectionCollectionView
            let flowLayout = collectionView?.collectionViewLayout as! CircularCollectionViewLayout
            fromViewController.sectionCollectionView.transform = CGAffineTransform(translationX: 0, y: fromViewController.sectionCollectionView.bounds.height)
            flowLayout.radius = 1000
        }) { (finished) in
            UIView.animate(withDuration: 0.3, animations: {
                toViewController.view.alpha = 1.0
            }) { (finished) in
                fromViewController.sectionCollectionView.transform = CGAffineTransform.identity
                
                transitionContext.completeTransition(true)
            }
        }
        
        
//        UIView.animate(withDuration: duration,
//                       animations: {
//                        fromViewController.sectionCollectionView.transform = CGAffineTransform(translationX: 0, y: 500)
//                        toViewController.view.alpha = 1.0
//        },
//                       completion: { _ in
//                        fromViewController.sectionCollectionView.transform = CGAffineTransform.identity
//
//                        transitionContext.completeTransition(true)
//        }
//        )
    }


}
