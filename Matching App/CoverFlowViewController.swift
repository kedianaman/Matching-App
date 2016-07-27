//
//  CoverFlowViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 7/25/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class CoverFlowViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    var collection = Collection()
    var currentIndexPath: NSIndexPath?
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        sectionCollectionView.addShadow()
        // Do any additional setup after loading the view.
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.numberOfSectionDatas()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sectionCollectionView.dequeueReusableCell(withReuseIdentifier: "SectionCollectionViewCellIdentifier", for: indexPath) as! SectionCollectionViewCell
        let sectionData = collection.sectionDataAtIndex(index: indexPath.row)
        cell.sectionImage.image = sectionData.backgroundImage
        cell.titleLabel.text = sectionData.title
        cell.scoreLabel.text = "Score: \(sectionData.topScore!)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GamePlaySegueIdentifier", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GamePlaySegueIdentifier" {
            let gameViewController = segue.destinationViewController as! GamePlayViewController
            let index = sender as! Int
            gameViewController.sectionData = collection.sectionDataAtIndex(index: index)
        }
    }
    
    @IBAction func exitToMenu(segue:UIStoryboardSegue) {
        //Unwind Segue
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var indexPath: NSIndexPath?
        var minimumDistanceToCell = CGFloat.greatestFiniteMagnitude
        let visibleCells = sectionCollectionView.visibleCells()
        for cell in visibleCells {
            
            let cellBoundsInSuperview = cell.convert(cell.bounds, to: self.view)
            let distanceToCell = abs((cellBoundsInSuperview.origin.x + cellBoundsInSuperview.width) - self.view.center.x)
            if distanceToCell < minimumDistanceToCell {
                minimumDistanceToCell = distanceToCell
                indexPath = sectionCollectionView.indexPath(for: cell)
            }
        }
        
        
        
        if indexPath != nil {
            if currentIndexPath != indexPath {
                currentIndexPath = indexPath
                UIView.transition(with: backgroundImageView, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    let sectionData = self.collection.sectionDataAtIndex(index: self.currentIndexPath!.row + 1)
                    self.backgroundImageView.image = sectionData.lightBlurredBackgroundImage
                    }, completion: nil)
                
            }
        }
    }

    

}
