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
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    @IBOutlet weak var titleImageView: UIImageView!
    
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
        performSegue(withIdentifier: "GamePlaySegueIdentifier", sender: indexPath.row)

//        let layout = collectionView.collectionViewLayout as! CircularCollectionViewLayout
//
//        let newLayout = CircularCollectionViewLayout()
//        newLayout.radius = layout.radius == 1000 ? 10000 : 1000
//        newLayout.spacingMultiplier = 0.01
//        collectionView.setCollectionViewLayout(newLayout, animated: true)
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
        
    }

    // Function which changes and animates the background image when user scrolls through the collection.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var indexPath: NSIndexPath?
        var minimumDistanceToCell = CGFloat.greatestFiniteMagnitude
        let visibleCells = sectionCollectionView.visibleCells
        for cell in visibleCells {
            
            let cellBoundsInSuperview = cell.convert(cell.bounds, to: self.view)
            let distanceToCell = abs((cellBoundsInSuperview.origin.x + cellBoundsInSuperview.width) - self.view.center.x)
            if distanceToCell < minimumDistanceToCell {
                minimumDistanceToCell = distanceToCell
                indexPath = sectionCollectionView.indexPath(for: cell) as NSIndexPath?
            }
        }
        
        if indexPath != nil {
            if currentIndexPath != indexPath {
                currentIndexPath = indexPath
                //temporary hack because method returns one cell to the left
                var modifiedIndex = currentIndexPath!.row + 1
                if modifiedIndex == collection.numberOfSectionDatas() {
                    modifiedIndex = modifiedIndex - 1
                }
                UIView.transition(with: backgroundImageView, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    let sectionData = self.collection.sectionDataAtIndex(index: modifiedIndex)
                    self.backgroundImageView.image = sectionData.lightBlurredBackgroundImage
                    }, completion: nil)
                
            }
        }
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
