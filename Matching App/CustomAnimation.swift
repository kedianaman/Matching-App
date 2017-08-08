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
    var presenting: Bool!
    var originFrame = CGRect.zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            let containerView = transitionContext.containerView
            let fromViewController = transitionContext.viewController(forKey: .from) as! CoverFlowViewController
            let toViewController = transitionContext.viewController(forKey: .to) as! GamePlayViewController
            toViewController.imageCollectionView.alpha = 0.0
            toViewController.textCollectionView.alpha = 0.0
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                fromViewController.sectionCollectionView.transform = CGAffineTransform(translationX: 0, y: fromViewController.sectionCollectionView.bounds.height)
                fromViewController.titleImageView.transform = CGAffineTransform(translationX: 0, y: -fromViewController.titleImageView.bounds.height)
            }) { (finished) in
                UIView.animate(withDuration: 0.3, animations: {
                    toViewController.view.alpha = 1.0
                }, completion: { (finished) in
                    for cell in toViewController.imageCollectionView.visibleCells {
                        cell.transform = CGAffineTransform(scaleX: 0, y: 0)
                    }
                    for cell in toViewController.textCollectionView.visibleCells {
                        cell.transform = CGAffineTransform(scaleX: 0, y: 0)
                    }
                    toViewController.imageCollectionView.alpha = 1.0
                    toViewController.textCollectionView.alpha = 1.0
                    UIView.animate(withDuration: 0.3, animations: {
                        for cell in toViewController.imageCollectionView.visibleCells {
                            cell.transform = CGAffineTransform.identity
                        }
                        for cell in toViewController.textCollectionView.visibleCells {
                            cell.transform = CGAffineTransform.identity
                        }
                    }, completion: { (finished) in
                        transitionContext.completeTransition(true)
                    })
                })
            }
        } else {
            let containerView = transitionContext.containerView
            let fromViewController = transitionContext.viewController(forKey: .from) as! GamePlayViewController
            let toViewController = transitionContext.viewController(forKey: .to) as! CoverFlowViewController
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                fromViewController.view.alpha = 0.0
                toViewController.view.alpha = 1.0
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.3, animations: {
                    toViewController.sectionCollectionView.transform = CGAffineTransform.identity
                    toViewController.titleImageView.transform = CGAffineTransform.identity
                }, completion: { (finished) in
                    transitionContext.completeTransition(true)
                })
            })
        }
    }
}
