//
//  CoverFlowViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 7/25/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class CoverFlowViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // A class which holds the collection view that displays the different categories.
    
    var collection = Collection()
    var currentIndexPath: NSIndexPath?
    let customAnimation = CustomAnimation()
    var selectedSectionIndex: Int?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    @IBOutlet weak var titleImageView: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sectionData = collection.sectionDataAtIndex(index: 0)
        backgroundImageView.image = sectionData.lightBlurredBackgroundImage
        self.sectionCollectionView.addParalaxToView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.numberOfSectionDatas()
    }
    
    // Returns the card (cell) of the category at a particular indexPath. Customizes title and image for the particular catgory.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sectionCollectionView.dequeueReusableCell(withReuseIdentifier: "SectionCollectionViewCellIdentifier", for: indexPath) as! SectionCollectionViewCell
        let sectionData = collection.sectionDataAtIndex(index: indexPath.row)
        cell.sectionImage.image = sectionData.backgroundImage
        cell.sectionImage.layer.cornerRadius = 15.0
        cell.titleLabel.text = sectionData.title
        if sectionData.topScore != nil {
            cell.scoreLabel.text = "Score: \(sectionData.topScore!)"
        } else {
            cell.scoreLabel.text = "Score: --"
        }
        
        cell.layer.masksToBounds = false
        cell.layer.shadowOpacity = 0.75
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 30.0).cgPath
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        return cell
    }
    
    // Function which gets called when user selects a certain card. Takes user to the game view controller.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSectionIndex = indexPath.row
        if (selectedSectionIndex == currentIndexPath?.row) {
            performSegue(withIdentifier: "GamePlaySegueIdentifier", sender: indexPath.row)
        } else {
            if let customLayout = sectionCollectionView.collectionViewLayout as? CircularCollectionViewLayout {
                sectionCollectionView.setContentOffset(customLayout.contentOffsetForIndex(index: indexPath.row), animated: true)
            }
        }
    }
    
    // Preperation for Segue. Passes the section data to the Game View Controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GamePlaySegueIdentifier" {
            let gameViewController = segue.destination as! GamePlayViewController
            let index = sender as! Int
            gameViewController.sectionData = collection.sectionDataAtIndex(index: index)
            gameViewController.transitioningDelegate = self
        }
    }
    
    
    @IBAction func exitToMenu(segue:UIStoryboardSegue) {
        //Unwind Segue
        sectionCollectionView.reloadData()
        
        if let selectedSectionIndex = selectedSectionIndex,
            let collectionViewLayout = sectionCollectionView.collectionViewLayout as? CircularCollectionViewLayout {
            sectionCollectionView.contentOffset = collectionViewLayout.contentOffsetForIndex(index: selectedSectionIndex)
        }
    }
    
    // Function which changes and animates the background image when user scrolls through the collection.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var indexPath: NSIndexPath?
        var minimumOriginY = CGFloat.greatestFiniteMagnitude
        let visibleCells = sectionCollectionView.visibleCells
        for cell in visibleCells {
            let originY = cell.frame.origin.y
            if originY < minimumOriginY {
                minimumOriginY = originY
                indexPath = sectionCollectionView.indexPath(for: cell) as NSIndexPath?
            }
        }
        if indexPath != nil {
            if currentIndexPath != indexPath {
                currentIndexPath = indexPath
                UIView.transition(with: backgroundImageView, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    let sectionData = self.collection.sectionDataAtIndex(index: self.currentIndexPath!.row)
                    self.backgroundImageView.image = sectionData.lightBlurredBackgroundImage
                }, completion: nil)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        selectedSectionIndex = nil
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("finished")
        if let selectedSectionIndex = selectedSectionIndex {
            performSegue(withIdentifier: "GamePlaySegueIdentifier", sender: selectedSectionIndex)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("finished decelerating")
    }
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        print("changed content inset")
    }
}

extension CoverFlowViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        customAnimation.presenting = true
        return customAnimation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        customAnimation.presenting = false
        return customAnimation
    }
    
}
