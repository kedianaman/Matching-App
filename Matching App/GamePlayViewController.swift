//
//  GamePlayViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 6/14/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var collection = Collection()
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var textCollectionView: UICollectionView!
    var images = [UIImage]()
    var texts = [String]()
    var selectedImageCell: ImageCollectionViewCell?
    var selectedTextCell: TextCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = collection.getImages()
        texts = collection.animals
    }
    
    //MARK: Collection View Delegate Methopds

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
            cell.contentImageView.image = images[(indexPath as NSIndexPath).row]
            cell.layer.cornerRadius = 20
            return cell
        } else if collectionView == textCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! TextCollectionViewCell
            cell.nameLabel.text = collection.animals[indexPath.row]
            cell.layer.cornerRadius = 20
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imageCollectionView {
            if let oldselectedImageCell = selectedImageCell {
                oldselectedImageCell.setHighlighted(selected: false)
            }
            selectedImageCell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
            selectedImageCell?.setHighlighted(selected: true)
        } else if collectionView == textCollectionView {
            if let oldselectedTextCell = selectedTextCell {
                oldselectedTextCell.setHighlighted(selected: false)
            }
            selectedTextCell = collectionView.cellForItem(at: indexPath) as! TextCollectionViewCell
            selectedTextCell?.setHighlighted(selected: true)
        }
        
        // check to see if they match if both are non-nil 
        if selectedTextCell != nil && selectedImageCell != nil {
            let image = selectedImageCell?.contentImageView.image
            let text = selectedTextCell?.nameLabel.text
            let match = collection.match(image!, name: text!)
            if match == true {
                selectedTextCell?.setMatched()
                selectedTextCell = nil
                selectedImageCell?.setMatched()
                selectedImageCell = nil
            } else {
                selectedImageCell?.setHighlighted(selected: false)
                selectedImageCell?.shake()
                selectedImageCell = nil
                selectedTextCell?.setHighlighted(selected: false)
                selectedTextCell?.incorrectShake()
                selectedTextCell = nil
            }
        }
    }
    
 
    


}
