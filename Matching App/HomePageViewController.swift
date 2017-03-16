//
//  HomePageViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 6/29/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var sectionsCollectionView: UICollectionView!


    var collection = Collection()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.numberOfSectionDatas()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sectionsCollectionView.dequeueReusableCell(withReuseIdentifier: "SectionCollectionViewCellIdentifier", for: indexPath) as! SectionCollectionViewCell
        let section = collection.sectionDataAtIndex(index: indexPath.row)
        cell.backgroundImageView.image = section.backgroundImage
        cell.cardImageView.image = section.backgroundImage
        cell.titleLabel.text = section.title
        cell.scoreLabel.text = String(section.topScore!)
        return cell
    }
    
    


}
