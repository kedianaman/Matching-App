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
        let sectionData = collection.sectionDataAtIndex(index: 0)
        backgroundImageView.image = sectionData.lightBlurredBackgroundImage
        test()
    }
    
    func test() {
        let defaults = UserDefaults.standard
        defaults.setValue(20, forKey: "test")
        print(defaults.integer(forKey: "test"))
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
        
        cell.layer.masksToBounds = false
        cell.layer.shadowOpacity = 0.75
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 30.0).cgPath
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale

        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GamePlaySegueIdentifier", sender: indexPath.row)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GamePlaySegueIdentifier" {
            let gameViewController = segue.destination as! GamePlayViewController
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
