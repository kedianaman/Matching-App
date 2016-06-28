//
//  HomeScreenCoverFlowViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 6/28/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class HomeScreenCoverFlowViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var coverFlowCollectionView: UICollectionView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    var currentIndexPath: NSIndexPath?

    
    var collection = Collection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.numberOfSectionDatas()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = coverFlowCollectionView.dequeueReusableCell(withReuseIdentifier: "SectionDataCoverCollectionViewCellIdentifier", for: indexPath) as! SectionDataCoverCollectionViewCell
        let sectionData = collection.sectionDataAtIndex(index: indexPath.row)
        cell.backgroundImage.image = sectionData.backgroundImage
        cell.layer.cornerRadius = 40 
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var indexPath: NSIndexPath?
        var minimumDistanceToCell = CGFloat.greatestFiniteMagnitude
        let visibleCells = coverFlowCollectionView.visibleCells()
        for cell in visibleCells {
            let cellBoundsInSuperview = cell.convert(cell.bounds, to: self.view)
            let distanceToCell = abs((cellBoundsInSuperview.origin.x + cellBoundsInSuperview.width) - self.view.center.x)
            if distanceToCell < minimumDistanceToCell {
                minimumDistanceToCell = distanceToCell
                indexPath = coverFlowCollectionView.indexPath(for: cell)
            }
        }
        
        
        
        if indexPath != nil {
            if currentIndexPath != indexPath {
                currentIndexPath = indexPath
                UIView.transition(with: backgroundImage, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    let sectionData = self.collection.sectionDataAtIndex(index: self.currentIndexPath!.row)
                    self.backgroundImage.image = sectionData.backgroundImage
                    self.titleLabel.text = sectionData.title
                    }, completion: nil)
                
            }
        }
    }

    

 
}
